import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csc322_starter_app/widgets/navigation/widget_primary_app_bar.dart';

class ScreenFiles extends ConsumerStatefulWidget {
  const ScreenFiles({super.key});

  static const routeName = '/files';

  @override
  ConsumerState<ScreenFiles> createState() => _ScreenFilesState();
}

class _ScreenFilesState extends ConsumerState<ScreenFiles> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addFile(String userId, String fileName) async {
    final timestamp = DateTime.now();
    await _firestore.collection('users').doc(userId).collection('files').add({
      'fileName': fileName,
      'uploadedAt': timestamp,
      'pinned': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userId =
        "currentUserId"; // Replace with actual user ID retrieval logic

    return Scaffold(
      appBar: WidgetPrimaryAppBar(
        title: const Text('Files'),
      ),
      body: Column(
        children: [
          // Section: Recently Uploaded
          _buildSectionTitle('Recently Uploaded'),
          _buildFileList(userId, isRecent: true),

          // Section: Videos
          _buildSectionTitle('Videos'),
          _buildFileList(userId, category: 'videos'),

          // Section: Other Files
          _buildSectionTitle('Files'),
          _buildFileList(userId, category: 'files'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFileDialog(context, userId),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFileList(String userId,
      {String? category, bool isRecent = false}) {
    Query fileQuery = _firestore
        .collection('users')
        .doc(userId)
        .collection('files')
        .orderBy('uploadedAt', descending: true);

    if (category != null) {
      fileQuery = fileQuery.where('category', isEqualTo: category);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: fileQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final files = snapshot.data?.docs ?? [];

        if (files.isEmpty) {
          // Display a 2-second delay before showing "No files found"
          return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 2)),
            builder: (context, delaySnapshot) {
              if (delaySnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                  child: Text('No files found'),
                );
              }
            },
          );
        }

        if (isRecent) {
          final pinnedFiles =
              files.where((file) => file['pinned'] == true).toList();
          final otherFiles =
              files.where((file) => file['pinned'] == false).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pinnedFiles.isNotEmpty)
                _buildFileRow('Pinned Files', pinnedFiles),
              _buildFileRow('Recent Files', otherFiles),
            ],
          );
        }

        return _buildFileRow(null, files);
      },
    );
  }

  Widget _buildFileRow(String? title, List<QueryDocumentSnapshot> files) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: files.map((file) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(file['fileName']),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddFileDialog(BuildContext context, String userId) async {
    final TextEditingController fileNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New File'),
        content: TextField(
          controller: fileNameController,
          decoration: const InputDecoration(hintText: 'Enter file name'),
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
                await _addFile(userId, fileName);
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
