import 'package:flutter/material.dart';
//import 'package:tickpocket_app/ticketlist.dart';

//TODO: add button that saves data into the database

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('New Post'),
            backgroundColor: const Color.fromARGB(255, 255, 131, 78)),
        body: const TicketTextField(),
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
                    icon: const Icon(Icons.add_circle),
                  ),

                  //Inbox Button
                  IconButton(
                    tooltip: 'Chat',
                    onPressed: () {
                      Navigator.pushNamed(context, '/Inbox');
                    },
                    icon: const Icon(Icons.inbox_outlined),
                  )
                ])));
  }
}

class TicketTextField extends StatefulWidget {
  const TicketTextField({super.key});

  @override
  State<TicketTextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TicketTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Title'),
            controller: _controller,
            onSubmitted: (String value) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Place'),
            controller: _controller,
            onSubmitted: (String value) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Date'),
            controller: _controller,
            onSubmitted: (String value) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Price'),
            controller: _controller,
            onSubmitted: (String value) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Small Description'),
            controller: _controller,
            onSubmitted: (String value) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
