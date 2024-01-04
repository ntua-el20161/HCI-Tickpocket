import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('TaskLogger');

// ignore: must_be_immutable
class Ticket {
  int? id;
  late String title;
  late String place;
  late String date;
  late String price;

  Ticket(int? id, this.title, this.place, this.date, this.price);

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    place = json['place'];
    date = json['date'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'place': place,
      'date': date,
      'price': price
    };
  }

  static List<Ticket> getTickets(int howmany) {
    return List.generate(
        howmany,
        (index) => Ticket(index, "title:$index", "place: $index",
            "date: $index", "price: $index"));
  }
}

class TicketListTile extends StatelessWidget {
  final Ticket ticket;

  const TicketListTile(this.ticket);

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
            child: Text(ticket.price),
          ),
        ],
      ),
    );
  }
}
