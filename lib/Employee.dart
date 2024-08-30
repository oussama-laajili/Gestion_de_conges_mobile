import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Define a class to hold employee data
class Employee {
  final String id;
  final String email;
  final int congemaladierestant;
  final int congeannuelrestant;
  final int congepersonellerestant;
  final List<dynamic> congehistorique;

  Employee({
    required this.id,
    required this.email,
    required this.congemaladierestant,
    required this.congeannuelrestant,
    required this.congepersonellerestant,
    required this.congehistorique,
  });

  // Factory method to create an Employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      email: json['email'],
      congemaladierestant: json['congemaladierestant'],
      congeannuelrestant: json['congeannuelrestant'],
      congepersonellerestant: json['congepersonellerestant'],
      congehistorique: json['congehistorique'],
    );
  }
}

// Function to fetch employee data from the API
Future<Employee> fetchEmployeeData() async {
  // Retrieve the email from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == null) {
    throw Exception('No email found in SharedPreferences');
  }

  // Make the API request with the retrieved email
  final response = await http.get(Uri.parse('http://192.168.1.20:5000/employees/$email'));

  if (response.statusCode == 200) {
    return Employee.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load employee data');
  }
}
