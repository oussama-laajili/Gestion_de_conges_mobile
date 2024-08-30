import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:visto_mobile/MainPage.dart'; // Adjust the import as needed

class WelcomePage extends StatelessWidget {
  final String fullname;

  WelcomePage({required this.fullname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Color.fromRGBO(28, 128, 251, 0.5),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '😊',
                  style: TextStyle(
                    fontSize: 48,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bienvenu(e), $fullname',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Gérez vos demandes de congés ici',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFD5D8E2),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              label: Text(
                'Suivant',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              icon: Icon(Icons.arrow_right_alt, size: 24, color: Colors.white), // Set icon color to white
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(28, 128, 251, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
