import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenSignUps extends ConsumerStatefulWidget {
  const ScreenSignUps({super.key});

  static const routeName = '/signups';

  @override
  ConsumerState<ScreenSignUps> createState() => _ScreenSignUpsState();
}

class _ScreenSignUpsState extends ConsumerState<ScreenSignUps>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Three tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text('Sign-Ups'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Mandatory'),
            Tab(text: 'Optional'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSignUpList(category: 'Mandatory'), // Mandatory Sign-Ups
          _buildSignUpList(category: 'Optional'), // Optional Sign-Ups
          _buildApprovedList(), // Approved Sign-Ups
        ],
      ),
    );
  }

  /// Builds the list of **Approved Sign-Ups**
  Widget _buildApprovedList() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('signups')
          .where('approvedBy', arrayContains: userId) // Approved by the user
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No approved sign-ups found.'));
        }

        final signUps = snapshot.data!.docs;

        return ListView.builder(
          itemCount: signUps.length,
          itemBuilder: (context, index) {
            final signUp = signUps[index].data() as Map<String, dynamic>;
            final name = signUp['name'] ?? 'Unknown';

            return ListTile(
              title: Text(name),
              trailing: const Icon(Icons.check, color: Colors.green),
            );
          },
        );
      },
    );
  }

  /// Builds the list of **Pending Sign-Ups** filtered by category
  Widget _buildSignUpList({required String category}) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('signups')
          .where('category', isEqualTo: category) // Mandatory or Optional
          .where('status', isEqualTo: 'Pending') // Only Pending events
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading sign-ups: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No $category sign-ups found.'));
        }

        final signUps = snapshot.data!.docs
            .where((doc) {
              final approvedBy = doc['approvedBy'] as List<dynamic>;
              return !approvedBy.contains(userId); // Exclude already approved
            })
            .toList();

        if (signUps.isEmpty) {
          return Center(child: Text('No $category sign-ups found.'));
        }

        return ListView.builder(
          itemCount: signUps.length,
          itemBuilder: (context, index) {
            final signUp = signUps[index].data() as Map<String, dynamic>;
            final googleFormUrl = signUp['google_form_url'] ?? '';
            final documentId = signUps[index].id;
            final name = signUp['name'] ?? 'Unknown';

            return ListTile(
              title: Text(name),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _handleSignUpTap(context, googleFormUrl, documentId),
            );
          },
        );
      },
    );
  }

  /// Handles the sign-up click and updates the Firestore document
  Future<void> _handleSignUpTap(
      BuildContext context, String googleFormUrl, String documentId) async {
    if (googleFormUrl.isEmpty) {
      _showSnackBar('Invalid URL.');
      return;
    }

    final Uri uri = Uri.parse(googleFormUrl);

    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // After opening the URL, ask for confirmation
        final bool? completed = await _confirmCompletion(context);

        if (completed == true) {
          final userId = FirebaseAuth.instance.currentUser!.uid;

          // Update the Firestore document: Add user ID to the 'approvedBy' array
          await FirebaseFirestore.instance
              .collection('signups')
              .doc(documentId)
              .update({
            'approvedBy': FieldValue.arrayUnion([userId])
          });

          _showSnackBar('Sign-up marked as Approved!');
        }
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  /// Shows a confirmation dialog to check if the user completed the form
  Future<bool?> _confirmCompletion(BuildContext context) {
    return showDialog<bool>(
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
  }

  /// Displays a SnackBar message using the ScaffoldMessenger
  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
