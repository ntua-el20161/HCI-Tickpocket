import 'package:flutter/material.dart';

class TicketSearchAnchor extends StatefulWidget {
  const TicketSearchAnchor();

  @override
  State<TicketSearchAnchor> createState() => TicketSearchAnchorState();
}

class TicketSearchAnchorState extends State<TicketSearchAnchor> {
  String? _searchingWithQuery;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          controller.openView();
        },
      );
    }, suggestionsBuilder:
            (BuildContext context, SearchController controller) async {
      _searchingWithQuery = controller.text;
    });
  }
}
