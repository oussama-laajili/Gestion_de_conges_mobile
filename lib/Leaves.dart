import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// Define a class to hold user data
class Leave {
  final DateTime start;
  final DateTime end;
  final String type;
  final String statut;
  final String commentaire;
  final String? supportingdoc;

  Leave({
    required this.start,
    required this.end,
    required this.type,
    required this.statut,
    required this.commentaire,
    this.supportingdoc,
  });

  // Factory method to create a Leave from JSON
  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      type: json['type'],
      statut: json['statut'],
      commentaire: json['commentaire'],
      supportingdoc: json['supportingdoc'],
    );
  }

  // Method to format date without time
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

// Function to fetch leave data from the API
Future<List<Leave>> fetchLeaveData() async {
  // Retrieve the email from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == null) {
    throw Exception('No email found in SharedPreferences');
  }

  // Make the API request with the retrieved email
  final response =
      await http.get(Uri.parse('http://192.168.1.20:5000/conges/$email'));

  if (response.statusCode == 200) {
    // Parse the JSON response as a list of maps
    List<dynamic> jsonData = json.decode(response.body);
    // Convert the list of maps to a list of Leave objects
    return jsonData.map((leave) => Leave.fromJson(leave)).toList();
  } else {
    throw Exception('Failed to load leaves data');
  }
}
