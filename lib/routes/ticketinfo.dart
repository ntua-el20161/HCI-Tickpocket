import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class TicketInfo extends StatelessWidget {
  final bool fromOtherUser;
  final String username;
  final String title;
  final String place;
  final String date;
  final String price;
  final String smallDesc;
  const TicketInfo(this.username, this.fromOtherUser, this.title, this.place,
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
              padding: EdgeInsets.only(top: 10, left: 15, bottom: 7),
              child: Row(
                children: [
                  ProfilePicture(
                    name: username,
                    radius: 30,
                    fontsize: 15,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    username,
                    style: TextStyle(fontSize: 20),
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
            SizedBox(
              height: 20,
            ),
            fromOtherUser
                ? Center(
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Message Seller')),
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }
}
