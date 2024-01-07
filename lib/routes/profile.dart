import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tickpocket_app/ticketlist.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: const Color.fromARGB(255, 255, 131, 78),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const ProfilePicture(
                name: 'Deez Nuts',
                radius: 60,
                fontsize: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 17.0, bottom: 30),
                child: Text(
                  'Deez Nuts',
                  style: TextStyle(fontSize: 21),
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
                        .collection('myTickets')
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<myTicketTile> myPostsList = [];
                      if (snapshot.hasData) {
                        final myTickets = snapshot.data?.docs.reversed.toList();
                        for (var ticket in myTickets!) {
                          final myTicketWidget = myTicketTile(Ticket(
                            ticket['username'],
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
