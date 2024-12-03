import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:url_launcher/url_launcher.dart';

class ScreenTasks extends ConsumerStatefulWidget {
  const ScreenTasks({super.key});

  static const routeName = '/tasks';

  @override
  ConsumerState<ScreenTasks> createState() => _ScreenTasksState();
}

class _ScreenTasksState extends ConsumerState<ScreenTasks>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'To-Do'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToDoTasks(), // To-Do Tasks Tab
          _buildCompletedTasks(), // Completed Tasks Tab
        ],
      ),
    );
  }

  /// Fetch and display To-Do Tasks
  Widget _buildToDoTasks() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No To-Do tasks found.'));
        }

        // Filter tasks that are NOT completed by the current user
        final tasks = snapshot.data!.docs.where((doc) {
          final completedBy = (doc['completedBy'] as List?) ?? [];
          return !completedBy.contains(userId);
        }).toList();

        if (tasks.isEmpty) {
          return const Center(child: Text('No To-Do tasks found.'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index].data() as Map<String, dynamic>;
            final name = task['name'] ?? 'Unnamed Task';
            final dueDate = (task['dueDate'] as Timestamp?)?.toDate();
            final url = task['url'] ?? '';
            final documentId = tasks[index].id;

            return ListTile(
              title: Text(name),
              subtitle: dueDate != null
                  ? Text(
                      'Due: ${DateFormat.yMMMMd().add_jm().format(dueDate)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  : null,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _handleTaskTap(context, url, documentId),
            );
          },
        );
      },
    );
  }

  /// Fetch and display Completed Tasks
  Widget _buildCompletedTasks() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('completedBy', arrayContains: userId) // Tasks completed by user
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No completed tasks found.'));
        }

        final tasks = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index].data() as Map<String, dynamic>;
            final name = task['name'] ?? 'Unnamed Task';
            final dueDate = (task['dueDate'] as Timestamp?)?.toDate();

            return ListTile(
              title: Text(name),
              subtitle: dueDate != null
                  ? Text(
                      'Due: ${DateFormat.yMMMMd().add_jm().format(dueDate)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  : null,
              trailing: const Icon(Icons.check, color: Colors.green),
            );
          },
        );
      },
    );
  }

  /// Handles task tap, opens the task URL, and updates Firestore on completion
  Future<void> _handleTaskTap(
      BuildContext context, String url, String documentId) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid URL')),
      );
      return;
    }

    final Uri uri = Uri.parse(url);

    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Ask for confirmation after opening the task
        final bool? completed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Task Completion'),
            content: const Text('Did you complete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );

        if (completed == true) {
          final userId = FirebaseAuth.instance.currentUser!.uid;

          // Update Firestore: Add user ID to 'completedBy' array
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(documentId)
              .update({
            'completedBy': FieldValue.arrayUnion([userId])
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task marked as completed!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
