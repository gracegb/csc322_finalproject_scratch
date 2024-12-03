import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:url_launcher/url_launcher.dart';

class ScreenForms extends ConsumerStatefulWidget {
  const ScreenForms({super.key});

  static const routeName = '/forms';

  @override
  ConsumerState<ScreenForms> createState() => _ScreenFormsState();
}

class _ScreenFormsState extends ConsumerState<ScreenForms>
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
        title: const Text('Forms'),
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
          _buildToDoForms(), // To-Do Forms Tab
          _buildCompletedForms(), // Completed Forms Tab
        ],
      ),
    );
  }

  Widget _buildToDoForms() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('forms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No To-Do forms found.'));
        }

        final forms = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final completedBy = List<String>.from(data['completedBy'] ?? []);
          return !completedBy.contains(userId);
        }).toList();

        if (forms.isEmpty) {
          return const Center(child: Text('No To-Do forms found.'));
        }

        return ListView.builder(
          itemCount: forms.length,
          itemBuilder: (context, index) {
            final form = forms[index].data() as Map<String, dynamic>;
            final name = form['name'] ?? 'Unnamed Form';
            final dueDate = (form['dueDate'] as Timestamp?)?.toDate();
            final url = form['url'] ?? '';
            final documentId = forms[index].id;

            return ListTile(
              title: Text(name),
              subtitle: dueDate != null
                  ? Text(
                      'Due: ${DateFormat.yMMMMd().add_jm().format(dueDate)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  : null,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _handleFormTap(context, url, documentId),
            );
          },
        );
      },
    );
  }

  Widget _buildCompletedForms() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('forms')
          .where('completedBy', arrayContains: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No completed forms found.'));
        }

        final forms = snapshot.data!.docs;

        return ListView.builder(
          itemCount: forms.length,
          itemBuilder: (context, index) {
            final form = forms[index].data() as Map<String, dynamic>;
            final name = form['name'] ?? 'Unnamed Form';
            final dueDate = (form['dueDate'] as Timestamp?)?.toDate();

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

  Future<void> _handleFormTap(
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
        final bool? completed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Form Completion'),
            content: const Text('Did you complete the form?'),
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

          await FirebaseFirestore.instance
              .collection('forms')
              .doc(documentId)
              .update({
            'completedBy': FieldValue.arrayUnion([userId])
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form marked as completed!')),
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
