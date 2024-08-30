import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visto_mobile/main.dart';
import 'package:visto_mobile/validate.dart';

class Leaverequest extends StatefulWidget {
  @override
  _LeaverequestState createState() => _LeaverequestState();
}

class _LeaverequestState extends State<Leaverequest> {
  late Future<Map<String, dynamic>> _user;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _leaveType;
  String? _comment;
  File? _file;
  bool _showValidationPage =
      false; // Flag to control the display of ValidatePage

  final _leaveTypes = [
    'Congés spéciaux pour raison de famille',
    'Congés de Maternité',
    'Congés exceptionnels',
    'Congés de maladie',
    'Congés pour obligations militaires',
    'Congés sans solde',
    'Congés payés',
  ];

  @override
  void initState() {
    super.initState();
    _user = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email == null) {
      throw Exception('Email not found in SharedPreferences');
    }

    final response =
        await http.get(Uri.parse('http://192.168.1.20:5000/users/$email'));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

Future<List<Map<String, dynamic>>> fetchNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email') ?? '';

  final response = await http.get(Uri.parse('http://192.168.1.20:5000/notifications/$email'));

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> notifications = List<Map<String, dynamic>>.from(json.decode(response.body));

    // Filter the notifications where the title is 'Congé accepté' or 'Congé refusé'
    List<Map<String, dynamic>> filteredNotifications = notifications.where((notification) {
      final title = notification['title'];
      return title == 'Congé accepté' || title == 'Congé refusé';
    }).toList();

    return filteredNotifications;
  } else {
    throw Exception('Failed to load notifications');
  }
}


  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitRequest() async {
    if (_startDate == null ||
        _endDate == null ||
        _leaveType == null ||
        _comment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving email.')),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.20:5000/conges'),
      );

      request.fields['start'] = _startDate!.toIso8601String();
      request.fields['end'] = _endDate!.toIso8601String();
      request.fields['type'] = _leaveType!;
      request.fields['statut'] = 'en attente';
      request.fields['commentaire'] = _comment!;
      request.fields['email'] = email;

      if (_file != null) {
        request.fields['supportingdoc'] = _file!.path.split('/').last;
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          _file!.path,
        ));
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        setState(() {
          _showValidationPage = true;
        });

        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _showValidationPage = false;
          });
        });

        // Clear the form
        setState(() {
          _startDate = null;
          _endDate = null;
          _leaveType = null;
          _comment = null;
          _file = null;
        });
      } else {
        throw Exception('Failed to submit request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
  preferredSize: Size.fromHeight(kToolbarHeight),
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black, Colors.blue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Demande de congé',
        style: TextStyle(color: Colors.white), // Set title color to white
      ),
      actions: [
        IconButton(
  icon: Icon(Icons.notifications, color: Colors.white), // Notification icon
  onPressed: () async {
    try {
      List<Map<String, dynamic>> notifications = await fetchNotifications();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Notifications'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification['title']),
                  subtitle: Text(notification['createdAt']),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (error) {
      // Handle errors
      print('Error fetching notifications: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notifications')),
      );
    }
  },
),

        IconButton(
          icon: Icon(Icons.logout, color: Colors.white), // Logout icon
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('access_token');
            await prefs.remove('fullname');
            await prefs.remove('avatar');
            await prefs.remove('email');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ],
    ),
  ),
),



      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                      'assets/images/aaaa.png',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _user,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final user = snapshot.data!;
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(user['avatar']),
                              ),
                              SizedBox(height: 15),
                              Text(
                                user['fullname'],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                        return Center(child: Text('Aucune donnée disponible'));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date de début',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Sélectionnez la date de début',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _startDate = pickedDate;
                                      });
                                    }
                                  },
                                  controller: TextEditingController(
                                    text: _startDate != null
                                        ? '${_startDate!.toLocal()}'
                                            .split(' ')[0]
                                        : '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date de fin',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Sélectionnez la date de fin',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _endDate = pickedDate;
                                      });
                                    }
                                  },
                                  controller: TextEditingController(
                                    text: _endDate != null
                                        ? '${_endDate!.toLocal()}'.split(' ')[0]
                                        : '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Type de congé', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        value: _leaveType,
                        items: _leaveTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _leaveType = value;
                          });
                        },
                        hint: Text('Sélectionnez le type de congé'),
                      ),
                      SizedBox(height: 16),
                      Text('Commentaire', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _comment = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickFile,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.black],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                                minHeight:
                                    50.0), // Set minimum height for the button
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    12), // Optional padding for better spacing
                            child: Text(
                              'Télécharger un fichier',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 200, // Adjust the width as needed
                          child: ElevatedButton(
                            onPressed: _submitRequest,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.black],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12), // Adjust padding for height
                                child: Text(
                                  'Soumettre la demande',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showValidationPage)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: ValidatePage(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
