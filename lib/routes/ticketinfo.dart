import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class TicketInfo extends StatelessWidget {
  final bool isPersonal;
  final String title;
  final String place;
  final String date;
  final String price;
  final String smallDesc;
  const TicketInfo(this.isPersonal, this.title, this.place, this.date,
      this.price, this.smallDesc,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 131, 78),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 15, bottom: 7),
              child: Row(
                children: [
                  ProfilePicture(
                    name: 'Deez Nuts',
                    radius: 30,
                    fontsize: 15,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Deez Nuts',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Text(title)
          ],
        ));
  }
}
