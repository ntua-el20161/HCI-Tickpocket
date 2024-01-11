import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tickpocket_app/routes/chatpage.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Inbox'),
            backgroundColor: const Color.fromARGB(255, 255, 131, 78)),
        body: _buildUserList(),
        bottomNavigationBar: BottomAppBar(
            color: const Color.fromARGB(255, 255, 131, 78),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Home Button
                  IconButton(
                      tooltip: 'Home Page',
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      icon: const Icon(Icons.home_outlined)),

                  //New Post Button
                  IconButton(
                    tooltip: 'New Post',
                    onPressed: () {
                      Navigator.pushNamed(context, '/NewPost');
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),

                  //Inbox Button
                  IconButton(
                    tooltip: 'Chat',
                    onPressed: () {
                      Navigator.pushNamed(context, '/Inbox');
                    },
                    icon: const Icon(Icons.inbox),
                  )
                ])));
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        final chatRooms = snapshot.data!.docs;
        final currentUserUid = _auth.currentUser!.uid;

        return ListView(
          children: chatRooms
              .where((room) =>
                  (room['members'] as List<dynamic>).contains(currentUserUid))
              .map<Widget>((room) => _buildUserListItem(room))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    final roomMembers = document['members'] as List<dynamic>;
    final otherUserId = roomMembers
        .firstWhere(
          (memberId) => memberId != _auth.currentUser!.uid,
          orElse: () => '',
        )
        .toString();

    if (otherUserId.isNotEmpty) {
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // or another loading indicator
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.hasData) {
            final userData = snapshot.data?.data();
            final otherUserEmail = userData?['email'] ?? 'Unknown Email';

            return ListTile(
              title: Text(otherUserEmail),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverUserEmail: otherUserEmail,
                      receiverUserID: otherUserId,
                    ),
                  ),
                );
              },
            );
          }

          return Container(); // Return an empty container if something goes wrong
        },
      );
    } else {
      return Container();
    }
  }
}
