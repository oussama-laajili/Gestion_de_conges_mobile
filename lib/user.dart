import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a class to hold user data
class User {
  final String fullname;
  final DateTime dob;
  final String gender;
  final int cin;
  final int phone;
  final String email;
  final String adresse;
  final String street;
  final String state;
  final String city;
  final int postalcode;
  final String country;
  final String typeofdegree;
  final String speciality;
  final DateTime dateofdegree;
  final String jobtitle;
  final String departement;
  final String linemanager;
  final DateTime startdate;
  final DateTime enddate;
  final String avatar;
  final String status;
  final String id2;
  final String degree;
  final String password;

  User({
    required this.fullname,
    required this.dob,
    required this.gender,
    required this.cin,
    required this.phone,
    required this.email,
    required this.adresse,
    required this.street,
    required this.state,
    required this.city,
    required this.postalcode,
    required this.country,
    required this.typeofdegree,
    required this.speciality,
    required this.dateofdegree,
    required this.jobtitle,
    required this.departement,
    required this.linemanager,
    required this.startdate,
    required this.enddate,
    required this.avatar,
    required this.status,
    required this.id2,
    required this.degree,
    required this.password,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'],
      dob: DateTime.parse(json['dob']),
      gender: json['gender'],
      cin: json['cin'],
      phone: json['phone'],
      email: json['email'],
      adresse: json['adresse'],
      street: json['street'],
      state: json['state'],
      city: json['city'],
      postalcode: json['postalcode'],
      country: json['country'],
      typeofdegree: json['typeofdegree'],
      speciality: json['speciality'],
      dateofdegree: DateTime.parse(json['dateofdegree']),
      jobtitle: json['jobtitle'],
      departement: json['departement'],
      linemanager: json['linemanager'],
      startdate: DateTime.parse(json['startdate']),
      enddate: DateTime.parse(json['enddate']),
      avatar: json['avatar'],
      status: json['status'],
      id2: json['id2'],
      degree: json['degree'],
      password: json['password'],
    );
  }

  // Method to format dates without time
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Example methods to get formatted dates
  String getFormattedDob() => formatDate(dob);
  String getFormattedDateOfDegree() => formatDate(dateofdegree);
  String getFormattedStartDate() => formatDate(startdate);
  String getFormattedEndDate() => formatDate(enddate);
}

// Function to fetch user data from the API
Future<User> fetchUserData() async {
  // Retrieve the email from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == null) {
    throw Exception('No email found in SharedPreferences');
  }

  // Make the API request with the retrieved email
  final response =
      await http.get(Uri.parse('http://192.168.1.20:5000/users/$email'));

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load user data');
  }
}
