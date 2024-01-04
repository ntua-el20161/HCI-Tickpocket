import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tickpocket_app/ticketlist.dart';
import 'package:get/get.dart';

class TicketFirestoreService extends GetxController {
  static TicketFirestoreService get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  postTicket(Ticket ticket) async {
    await _db.collection("Tickets").add(ticket.toJson()).whenComplete(() =>
        Get.snackbar("Thank you!", "Ticket posted successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green));
    /*.catchError((error, stackTrace) {
      Get.snackbar("Error", "Error uploading the ticket",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });*/
  }
}
