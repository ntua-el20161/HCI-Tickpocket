import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:swipe_widget/swipe_widget.dart';
import 'package:swipe_to/swipe_to.dart';

final log = Logger('TaskLogger');

// ignore: must_be_immutable
class Ticket {
  //int? id;
  late String title;
  late String place;
  late String date;
  late String price;
  late String smallDesc;

  Ticket(
      //int? id,
      this.title,
      this.place,
      this.date,
      this.price,
      this.smallDesc);

  Ticket.fromJson(Map<String, dynamic> json) {
    //id = json['id'];
    title = json['title'];
    place = json['place'];
    date = json['date'];
    price = json['price'];
    smallDesc = json['smallDesc'];
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'title': title,
      'place': place,
      'date': date,
      'price': price,
      'smallDesc': smallDesc
    };
  }

  static List<Ticket> getTickets(int howmany) {
    return List.generate(
        howmany,
        (index) => Ticket("title:$index", "place: $index", "date: $index",
            "price: $index", "smallDesc: $index"));
  }
}

class TicketTile extends StatelessWidget {
  final Ticket ticket;

  const TicketTile(this.ticket, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
  void Delete() {}

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      iconOnLeftSwipe: Icons.delete,
      onLeftSwipe: (details) {
        Delete();
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
    );
  }
}
