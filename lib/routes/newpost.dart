import 'package:flutter/material.dart';
import 'package:tickpocket_app/firestoreService.dart';
import 'package:get/get.dart';
import 'package:tickpocket_app/ticketlist.dart';
import 'package:intl/intl.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('New Post'),
            backgroundColor: const Color.fromARGB(255, 255, 131, 78)),
        body: const SingleChildScrollView(
          child: NewTicketForm(),
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

//Κατασκευή μιας στήλης απο Text Fields για την εισαγωγή στοιχείων του εισητηρίου που θέλουμε να δημοσιεύσουμε
class NewTicketForm extends StatefulWidget {
  const NewTicketForm({super.key});

  @override
  State<NewTicketForm> createState() => _TextFieldState();
}

class _TextFieldState extends State<NewTicketForm> {
  late DateTime _selectedDate;

  late TextEditingController _titleController;
  late TextEditingController _placeController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TicketFirestoreService ticketFirestoreService;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    //ticketFirestoreService = TicketFirestoreService();
    //controllers για κάθε ένα text field ώστε να μπορούμε να χειριστούμε αυτό που γράφεται
    _titleController = TextEditingController();
    _placeController = TextEditingController();
    _dateController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          buildTextField(_titleController, 'Title'),
          buildTextField(_placeController, 'Place'),
          buildTextField(_dateController, 'Date'),
          buildTextField(_priceController, 'Price'),
          buildTextField(_descriptionController, 'Small Description'),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
                child: const Text('Post'),
                onPressed: () async {
                  await postTicket();
                }),
          ),
        ],
      ),
    );
  }

  //Συνάρτηση που αποθηκεύει το εισητήριο στη βάση δεδομένων παίρνωντας ο,τι είναι γραμμένο σε κάθε text field ως δεδομένο
  Future<void> postTicket() async {
    try {
      TicketFirestoreService ticketFirestoreService =
          Get.find<TicketFirestoreService>();

      if (_titleController.text.isNotEmpty &&
          _placeController.text.isNotEmpty &&
          _dateController.text.isNotEmpty &&
          _priceController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty) {
        await ticketFirestoreService.addTicketToDb(Ticket(
          'Deez Nuts',
          _titleController.text,
          _placeController.text,
          _dateController.text,
          _priceController.text,
          _descriptionController.text,
        ));
        //TODO: potential issue here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ticket posted successfully."),
            duration: Duration(seconds: 2),
          ),
        );
        //όταν πατάμε post τα text fields γίνονται reset
        _titleController.clear();
        _placeController.clear();
        _dateController.clear();
        _priceController.clear();
        _descriptionController.clear();
      }
      //Εαν κάποιο text field είναι κενό, εμφανίζεται ένα snackbar με κατάλληλο μήνυμα και η αποθήκευση αποτυγχάνει
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill in all fields."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error uploading the ticket."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  //δομή ενός text field
  Widget buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        width: 300,
        //όταν πρόκειται για ημερομηνία, υπάρχουν αλλαγές ωστε να εμφανίζεται ένας date picker
        child: labelText == 'Date'
            ? InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: labelText,
                    ),
                    controller: controller,
                  ),
                ),
              )
            //στο price field το πληκτρολόγιο που εμφανίζεται περιέχει μόνο αριθμούς
            : (labelText == 'Price'
                ? TextField(
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: labelText,
                    ),
                    controller: controller,
                  )
                : TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: labelText,
                    ),
                    controller: controller,
                  )),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
