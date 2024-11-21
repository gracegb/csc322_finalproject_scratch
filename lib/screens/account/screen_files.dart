import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenFiles extends StatefulWidget {
  const ScreenFiles({super.key});

  static const routeName = '/files';

  @override
  State<ScreenFiles> createState() => _ScreenFilesState();
}

class _ScreenFilesState extends State<ScreenFiles>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this); // Added 'Pinned' tab
  }

  String _getFileCategory(String fileName) {
    final videoExtensions = ['mp4', 'avi', 'mov', 'mkv', 'flv', 'wmv'];
    final extension = fileName.split('.').last.toLowerCase();
    if (videoExtensions.contains(extension)) {
      return 'videos';
    }
    return 'files';
  }

  Future<void> _addFile(String fileName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userId = user.uid;
    final timestamp = DateTime.now();
    final category = _getFileCategory(fileName);

    await _firestore.collection('users').doc(userId).collection('files').add({
      'fileName': fileName,
      'uploadedAt': timestamp,
      'pinned': false,
      'fileUrl': 'https://example.com/uploads/$fileName',
      'category': category,
    });
  }

  Future<void> _deleteFile(String docId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('files')
        .doc(docId)
        .delete();
  }

  Future<void> _togglePin(String docId, String userId, bool isPinned) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('files')
        .doc(docId)
        .update({'pinned': !isPinned});
  }

  void _confirmDelete(BuildContext context, String docId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: const Text('Are you sure you want to delete this file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _deleteFile(docId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files & Videos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _FileSearchDelegate(
                  buildFileList: _buildFileList,
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Recent'),
            Tab(text: 'Files'),
            Tab(text: 'Videos'),
            Tab(text: 'Pinned'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFileList(), // Recent view (no filter)
          _buildFileList(category: 'files'), // Files view
          _buildFileList(category: 'videos'), // Videos view
          _buildFileList(isPinned: true), // Pinned files view
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFileDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFileList(
      {String? category, bool isPinned = false, String? query}) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('User not authenticated'));
    }

    final userId = user.uid;
    Query fileQuery = _firestore
        .collection('users')
        .doc(userId)
        .collection('files')
        .orderBy('uploadedAt', descending: true);

    if (category != null) {
      fileQuery = fileQuery.where('category', isEqualTo: category);
    }
    if (isPinned) {
      fileQuery = fileQuery.where('pinned', isEqualTo: true);
    }
    if (query != null && query.isNotEmpty) {
      fileQuery = fileQuery
          .where('fileName', isGreaterThanOrEqualTo: query)
          .where('fileName', isLessThanOrEqualTo: query + '\uf8ff');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: fileQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load files: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No files found'));
        }

        final files = snapshot.data!.docs;
        return ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            final fileDoc = files[index];
            final fileData = fileDoc.data() as Map<String, dynamic>;
            final fileName = fileData['fileName'] ?? 'Unnamed File';
            final uploadedAt = (fileData['uploadedAt'] as Timestamp).toDate();
            final isPinned = fileData['pinned'] ?? false;

            return ListTile(
              title: Text(fileName),
              subtitle: Text('Uploaded at: ${uploadedAt.toString()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: isPinned ? Colors.blue : null,
                    ),
                    onPressed: () => _togglePin(fileDoc.id, userId, isPinned),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _confirmDelete(context, fileDoc.id, userId),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAddFileDialog(BuildContext context) async {
    FilePickerResult? pickedFile;
    final TextEditingController fileNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                pickedFile = await FilePicker.platform.pickFiles();
                if (pickedFile != null && pickedFile!.files.isNotEmpty) {
                  fileNameController.text = pickedFile!.files.first.name;
                }
              },
              child: const Text('Browse Files'),
            ),
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(hintText: 'File name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final fileName = fileNameController.text.trim();
              if (fileName.isNotEmpty) {
                await _addFile(fileName);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Search Delegate for Files
class _FileSearchDelegate extends SearchDelegate {
  final Function buildFileList;

  _FileSearchDelegate({required this.buildFileList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildFileList(query: query); // Pass query here
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildFileList(query: query); // Pass query here
  }
}
