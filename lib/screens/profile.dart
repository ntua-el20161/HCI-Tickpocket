import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:tickpocket_app/services/auth_gate.dart';
import 'package:tickpocket_app/services/auth_service.dart';
import 'package:tickpocket_app/ticketlist.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: const Color.fromARGB(255, 255, 131, 78),
          actions: [
            IconButton(
                onPressed: () {
                  signOut();
                },
                icon: const Icon(Icons.logout_rounded))
          ],
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ProfilePicture(
                name: _firebaseAuth.currentUser!.email.toString(),
                radius: 60,
                fontsize: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0, bottom: 30),
                child: Text(
                  _firebaseAuth.currentUser!.email.toString(),
                  style: const TextStyle(fontSize: 21),
                ),
              ),
              const Divider(color: Colors.black),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Posts',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Tickets')
                        .where('email',
                            isEqualTo:
                                _firebaseAuth.currentUser!.email.toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<MyTicketTile> myPostsList = [];
                      if (snapshot.hasData) {
                        final myTickets = snapshot.data?.docs.reversed.toList();
                        for (var ticket in myTickets!) {
                          final myTicketWidget = MyTicketTile(Ticket(
                            ticket['email'],
                            ticket['title'],
                            ticket['place'],
                            ticket['date'],
                            ticket['price'],
                            ticket['smallDesc'],
                          ));
                          myPostsList.add(myTicketWidget);
                        }
                      }
                      return ListView(
                        children: myPostsList,
                      );
                    }),
              ),
            ],
          ),
        ),
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
                    icon: const Icon(Icons.inbox_outlined),
                  )
                ])));
  }
}
