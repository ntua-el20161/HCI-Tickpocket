import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('TaskLogger');

// ignore: must_be_immutable
class Ticket extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: [
          Column(
            children: [
              Text(title),
              Text(place),
              Text(date),
            ],
          ),
          Text(price),
        ],
      )
    ]);
  }

  static List<Ticket> getTickets(int howmany) {
    return List.generate(
        howmany,
        (index) => Ticket(index, "title:$index", "place: $index",
            "date: $index", "price: $index"));
  }
}
