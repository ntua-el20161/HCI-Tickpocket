import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tickpocket_app/ticketlist.dart';
import 'package:tickpocket_app/screens/ticketinfo.dart';

class TicketSearchAnchor extends StatefulWidget {
  const TicketSearchAnchor({super.key});

  @override
  State<TicketSearchAnchor> createState() => TicketSearchAnchorState();
}

class TicketSearchAnchorState extends State<TicketSearchAnchor> {
  String? _searchingWithQuery;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late Iterable<Widget> _lastOptions = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      viewHintText: 'Search for an event...',
      isFullScreen: false,
      viewConstraints: const BoxConstraints(minWidth: 500),
      builder: (BuildContext context, SearchController controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        _searchingWithQuery = controller.text;
        final List<Ticket> options = await searchTickets(_searchingWithQuery);

        if (_searchingWithQuery != controller.text) {
          return _lastOptions;
        }

        _lastOptions = List<ListTile>.generate(options.length, (int index) {
          final Ticket ticket = options[index];
          return ListTile(
            title: Text(ticket.title),
            subtitle: Text("${ticket.date}, ${ticket.place}"),
            enabled: true,
            enableFeedback: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketInfo(
                      ticket.email,
                      ticket.email !=
                              _firebaseAuth.currentUser!.email.toString()
                          ? true
                          : false,
                      ticket.title,
                      ticket.place,
                      ticket.date,
                      ticket.price,
                      ticket.smallDesc),
                ),
              );
            },
          );
        });

        return _lastOptions;
      },
    );
  }

  Future<List<Ticket>> searchTickets(String? text) async {
    final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
        .instance
        .collection('Tickets')
        .where('title', isGreaterThanOrEqualTo: text)
        .where('title', isLessThan: '${text!}z')
        .get(); // Example: search titles starting with the input text

    // Extract ticket titles from the query
    final List<Ticket> tickets =
        query.docs.map((doc) => Ticket.fromJson(doc.data())).toList();
    if (text == '') {
      return List<Ticket>.empty();
    }
    return tickets;
  }
}
