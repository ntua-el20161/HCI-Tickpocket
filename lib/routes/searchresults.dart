import 'package:flutter/material.dart';
import 'package:tickpocket_app/ticketlist.dart';

class SearchResults extends StatelessWidget {
  final Future<List<Ticket>> results;
  const SearchResults(this.results, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 131, 78),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: results,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            List<TicketTile> resultsList = [];
            for (var ticket in snapshot.data!) {
              final ticketWidget = TicketTile(Ticket(
                ticket.email,
                ticket.title,
                ticket.place,
                ticket.date,
                ticket.price,
                ticket.smallDesc,
              ));
              resultsList.add(ticketWidget);
            }
            return ListView(children: resultsList);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 255, 131, 78),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //Home Button
                IconButton(
                    tooltip: 'Home Page',
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: const Icon(Icons.home_outlined)),

                //New Post Button
                IconButton(
                  tooltip: 'New Post',
                  onPressed: () {
                    Navigator.pushNamed(context, '/NewPost');
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),

                //Inbox Button
                IconButton(
                  tooltip: 'Chat',
                  onPressed: () {
                    Navigator.pushNamed(context, '/Inbox');
                  },
                  icon: const Icon(Icons.inbox_outlined),
                )
              ])),
    );
  }
}
