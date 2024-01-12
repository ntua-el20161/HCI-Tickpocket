import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tickpocket_app/ticketlist.dart';
import 'package:get/get.dart';

class TicketFirestoreService extends GetxController {
  static TicketFirestoreService get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> addTicketToDb(Ticket ticket) async {
    await _db.collection("Tickets").add(ticket.toJson());
  }
}
