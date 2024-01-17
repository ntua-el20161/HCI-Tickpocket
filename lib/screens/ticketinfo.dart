import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tickpocket_app/screens/chatpage.dart';

class TicketInfo extends StatelessWidget {
  final bool fromOtherUser;
  final String email;
  final String title;
  final String place;
  final String date;
  final String price;
  final String smallDesc;
  const TicketInfo(this.email, this.fromOtherUser, this.title, this.place,
      this.date, this.price, this.smallDesc,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 131, 78),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 7),
              child: Row(
                children: [
                  ProfilePicture(
                    name: email,
                    radius: 30,
                    fontsize: 15,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                'Place: $place',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Date: $date',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                smallDesc,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            fromOtherUser
                ? Center(
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () {
                            _navigateToChat(context);
                          },
                          child: const Text('Message Seller')),
                    ),
                  )
                : Container()
          ],
        ));
  }

  Future<void> _navigateToChat(BuildContext context) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userId = querySnapshot.docs.first.id;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            receiverUserEmail: email,
            receiverUserID: userId,
          ),
        ),
      );
    }
  }
}
