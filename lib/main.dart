// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tickpocket_app/services/auth_gate.dart';
import 'package:tickpocket_app/services/auth_service.dart';
import 'services/firebase_options.dart';
import 'package:tickpocket_app/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:tickpocket_app/ticket.dart';
import 'package:tickpocket_app/search.dart';
import 'package:tickpocket_app/screens/newpost.dart';
import 'package:tickpocket_app/screens/inbox.dart';
import 'package:tickpocket_app/screens/profile.dart';
import 'package:tickpocket_app/ticketlist.dart';
import 'package:camera/camera.dart';
import 'package:tickpocket_app/screens/camera.dart';

final log = Logger('MainLogger');

late List<CameraDescription> _cameras;
late CameraDescription firstCamera;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(TicketFirestoreService());
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '${record.loggerName} --> ${record.level.name}: ${record.time}: ${record.message}');
  });
  _cameras = await availableCameras();
  firstCamera = _cameras.first;

  runApp(
    ChangeNotifierProvider(
        create: (context) => AuthService(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tickpocket',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.

          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0XFFFF834E)),
          useMaterial3: true,
        ),
        home: const AuthGate(),
        routes: {
          '/NewPost': (context) => const NewPostScreen(),
          '/Inbox': (context) => const InboxScreen(),
          '/Profile': (context) => const ProfileScreen()
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  final SearchController controller = SearchController();
  late CameraController _cameraController;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

        //Μπάρα στο πάνω μέρος της οθόνης
        appBar: AppBar(
          //title
          title: Text(
            'TICKPOCKET',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: const Color.fromARGB(255, 255, 131, 78),

          //Για να μην μπαίνει το κουμπί back αυτόματα
          automaticallyImplyLeading: false,

          //Search button and profile button
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CameraScreenWidget(camera: firstCamera)));
              },
              icon: const Icon(Icons.camera_alt),
            ),
            //Search Button

            const TicketSearchAnchor(),

            //Profile Button
            IconButton(
              tooltip: "Profile",
              onPressed: () {
                Navigator.pushNamed(context, '/Profile');
              },
              icon: const Icon(Icons.account_circle_rounded),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Tickets')
                .where('email',
                    isNotEqualTo: _firebaseAuth.currentUser!.email.toString())
                .snapshots(),
            builder: (context, snapshot) {
              List<TicketTile> postsLists = [];
              if (snapshot.hasData) {
                final Tickets = snapshot.data?.docs.reversed.toList();
                for (var ticket in Tickets!) {
                  final ticketWidget = TicketTile(Ticket(
                    ticket['email'],
                    ticket['title'],
                    ticket['place'],
                    ticket['date'],
                    ticket['price'],
                    ticket['smallDesc'],
                  ));
                  postsLists.add(ticketWidget);
                }
              }
              return ListView(
                children: postsLists,
              );
            }),

        //Μπάρα στο κάτω μέρος της οθόνης
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
                      icon: const Icon(Icons.home)),

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
                ])));
  }
}
