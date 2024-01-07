import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:tickpocket_app/routes/ticketinfo.dart';

final log = Logger('TicketLogger');

// ignore: must_be_immutable
class Ticket {
  late String username;
  late String id;
  late String title;
  late String place;
  late String date;
  late String price;
  late String smallDesc;

  Ticket(
    //int? id,
    this.username,
    this.title,
    this.place,
    this.date,
    this.price,
    this.smallDesc,
  ) : id = const Uuid().v4();

  Ticket.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    title = json['title'];
    place = json['place'];
    date = json['date'];
    price = json['price'];
    smallDesc = json['smallDesc'];
    id = json[const Uuid().v4()];
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'title': title,
      'place': place,
      'date': date,
      'price': price,
      'smallDesc': smallDesc,
      'id': id
    };
  }
}

class TicketTile extends StatelessWidget {
  final Ticket ticket;

  const TicketTile(this.ticket, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketInfo(
                  ticket.username,
                  true,
                  ticket.title,
                  ticket.place,
                  ticket.date,
                  ticket.price,
                  ticket.smallDesc),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 12.0),
                  child: Text(ticket.title),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(ticket.place),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 12.0),
                  child: Text(ticket.date),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text("${ticket.price}€"),
            ),
          ],
        ),
      ),
    );
  }
}

class myTicketTile extends StatefulWidget {
  final Ticket ticket;
  const myTicketTile(this.ticket, {super.key});

  @override
  State<myTicketTile> createState() => _myTicketTileState();
}

class _myTicketTileState extends State<myTicketTile> {
  void deleteDocument() async {
    try {
      String documentTitle = widget.ticket.title;

      if (documentTitle.isNotEmpty) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('myTickets')
            .where('title', isEqualTo: documentTitle)
            .get();
        print(querySnapshot.docs.first.id);
        log.info(querySnapshot.docs.first.id);
        if (querySnapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('myTickets')
              .doc(querySnapshot.docs.first.id)
              .delete();
        }
      } else {
        print("Document id is null or empty");
      }
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      iconOnLeftSwipe: Icons.delete,
      onLeftSwipe: (details) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content:
                    const Text('Are you sure you want to delete this ticket?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // User confirmed deletion
                      Navigator.of(context).pop();
                      deleteDocument();
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      // User canceled deletion
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                  ),
                ],
              );
            });
      },
      offsetDx: 1,
      animationDuration: const Duration(milliseconds: 150),
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketInfo(
                  widget.ticket.username,
                  false,
                  widget.ticket.title,
                  widget.ticket.place,
                  widget.ticket.date,
                  widget.ticket.price,
                  widget.ticket.smallDesc),
            ),
          );
        },
        child: Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 12.0),
                    child: Text(widget.ticket.title),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(widget.ticket.place),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 12.0),
                    child: Text(widget.ticket.date),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text("${widget.ticket.price}€"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
