import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tickpocket_app/ticketlist.dart';
import 'package:tickpocket_app/routes/ticketinfo.dart';

class TicketSearchAnchor extends StatefulWidget {
  const TicketSearchAnchor({super.key});

  @override
  State<TicketSearchAnchor> createState() => TicketSearchAnchorState();
}

class TicketSearchAnchorState extends State<TicketSearchAnchor> {
  String? _searchingWithQuery;

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
          );
        });

        return _lastOptions;
      },
    );
  }

  Future<List<Ticket>> searchTickets(String? text) async {
    // Perform Firestore query to search for tickets based on the input text
    // Replace 'your_collection' with your Firestore collection name
    final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection('Tickets')
        .where('title', isGreaterThanOrEqualTo: text)
        .where('title',
            isLessThan:
                '${text!}z') // Example: search titles starting with the input text
        .get();

    // Extract ticket titles from the result
    final List<Ticket> tickets =
        result.docs.map((doc) => Ticket.fromJson(doc.data())).toList();
    if (text == '') {
      return List<Ticket>.empty();
    }
    return tickets;
  }
}
