// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:visto_mobile/EditUserDialog.dart';

// class User {
//   final String fullname;
//   final String dob;
//   final String gender;
//   final int cin;
//   final int phone;
//   final String email;
//   final String adresse;
//   final String street;
//   final String state;
//   final String city;
//   final int postalcode;
//   final String country;
//   final String typeofdegree;
//   final String speciality;
//   final String dateofdegree;
//   final String jobtitle;
//   final String departement;
//   final String linemanager;
//   final String startdate;
//   final String enddate;
//   final String avatar;
//   final String status;
//   final String id2;
//   final String degree;
//   final String password;

//   User({
//     required this.fullname,
//     required this.dob,
//     required this.gender,
//     required this.cin,
//     required this.phone,
//     required this.email,
//     required this.adresse,
//     required this.street,
//     required this.state,
//     required this.city,
//     required this.postalcode,
//     required this.country,
//     required this.typeofdegree,
//     required this.speciality,
//     required this.dateofdegree,
//     required this.jobtitle,
//     required this.departement,
//     required this.linemanager,
//     required this.startdate,
//     required this.enddate,
//     required this.avatar,
//     required this.status,
//     required this.id2,
//     required this.degree,
//     required this.password,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       fullname: json['fullname'],
//       dob: json['dob'],
//       gender: json['gender'],
//       cin: json['cin'],
//       phone: json['phone'],
//       email: json['email'],
//       adresse: json['adresse'],
//       street: json['street'],
//       state: json['state'],
//       city: json['city'],
//       postalcode: json['postalcode'],
//       country: json['country'],
//       typeofdegree: json['typeofdegree'],
//       speciality: json['speciality'],
//       dateofdegree: json['dateofdegree'],
//       jobtitle: json['jobtitle'],
//       departement: json['departement'],
//       linemanager: json['linemanager'],
//       startdate: json['startdate'],
//       enddate: json['enddate'],
//       avatar: json['avatar'],
//       status: json['status'],
//       id2: json['id2'],
//       degree: json['degree'],
//       password: json['password'],
//     );
//   }
// }

// Future<User> fetchUserData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? email = prefs.getString('email');

//   if (email == null) {
//     throw Exception('No email found in SharedPreferences');
//   }

//   final response =
//       await http.get(Uri.parse('http://192.168.1.20:5000/users/$email'));

//   if (response.statusCode == 200) {
//     return User.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load user data');
//   }
// }

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late Future<User> _user;

//   @override
//   void initState() {
//     super.initState();
//     _user = fetchUserData();
//   }

//   void _editUserDetails(User user) async {
//     User? editedProfile = await showDialog<User>(
//       context: context,
//       builder: (context) => EditUserDialog(user: user),
//     );

//     if (editedProfile != null) {
//       final response = await http.put(
//         Uri.parse('http://192.168.1.20:5000/users/${editedProfile.email}'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'fullname': editedProfile.fullname,
//           'dob': editedProfile.dob,
//           'gender': editedProfile.gender,
//           'cin': editedProfile.cin,
//           'phone': editedProfile.phone,
//           'email': editedProfile.email,
//           'adresse': editedProfile.adresse,
//           'street': editedProfile.street,
//           'state': editedProfile.state,
//           'city': editedProfile.city,
//           'postalcode': editedProfile.postalcode,
//           'country': editedProfile.country,
//           'typeofdegree': editedProfile.typeofdegree,
//           'speciality': editedProfile.speciality,
//           'dateofdegree': editedProfile.dateofdegree,
//           'jobtitle': editedProfile.jobtitle,
//           'departement': editedProfile.departement,
//           'linemanager': editedProfile.linemanager,
//           'startdate': editedProfile.startdate,
//           'enddate': editedProfile.enddate,
//           'avatar': editedProfile.avatar,
//           'status': editedProfile.status,
//           'id2': editedProfile.id2,
//           'degree': editedProfile.degree,
//           'password': editedProfile.password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _user = fetchUserData(); // Refresh the user data after edit
//         });
//       } else {
//         // Handle error
//         print('Failed to update user');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blue, Colors.black],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: Text(
//               'Profile',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Stack(
//               alignment: Alignment.topCenter,
//               children: [
//                 Image.asset(
//                   'assets/images/aaaa.png',
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//                 FutureBuilder<User>(
//                   future: _user,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (snapshot.hasData) {
//                       final user = snapshot.data!;
//                       return Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 50,
//                             backgroundImage: NetworkImage(user.avatar),
//                           ),
//                           SizedBox(height: 15),
//                           Text(
//                             user.fullname,
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           _buildInfoBox(
//                             title: 'Personal Information',
//                             children: [
//                               _buildInfoRow('Full Name', user.fullname),
//                               _buildInfoRow('Date of Birth', user.dob),
//                               _buildInfoRow('Gender', user.gender),
//                               _buildInfoRow('CIN', user.cin.toString()),
//                               _buildInfoRow('Phone', user.phone.toString()),
//                               _buildInfoRow('Email', user.email),
//                               _buildInfoRow('Address',
//                                   '${user.adresse}, ${user.street}, ${user.state}, ${user.city}, ${user.country}'),
//                             ],
//                           ),
//                           SizedBox(height: 20),
//                           _buildInfoBox(
//                             title: 'Education Information',
//                             children: [
//                               _buildInfoRow('Degree Type', user.typeofdegree),
//                               _buildInfoRow('Speciality', user.speciality),
//                               _buildInfoRow(
//                                   'Date of Degree', user.dateofdegree),
//                             ],
//                           ),
//                           SizedBox(height: 20),
//                           _buildInfoBox(
//                             title: 'Job Information',
//                             children: [
//                               _buildInfoRow('Job Title', user.jobtitle),
//                               _buildInfoRow('Department', user.departement),
//                               _buildInfoRow('Line Manager', user.linemanager),
//                               _buildInfoRow('Start Date', user.startdate),
//                               _buildInfoRow('End Date', user.enddate),
//                             ],
//                           ),
//                           SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: () => _editUserDetails(user),
//                             child: Text('Edit'),
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       );
//                     }
//                     return Center(child: Text('No data available'));
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoBox({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue, Colors.black],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white, // Set title text color to white
//             ),
//           ),
//           SizedBox(height: 10),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white, // Set key text color to white
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: Colors.white, // Set value text color to white
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visto_mobile/EditUserDialog.dart';
import 'package:visto_mobile/main.dart';

class Employee {
  final int congemaladierestant;
  final int congeannuelrestant;
  final int congepersonellerestant;

  Employee({
    required this.congemaladierestant,
    required this.congeannuelrestant,
    required this.congepersonellerestant,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      congemaladierestant: json['congemaladierestant'],
      congeannuelrestant: json['congeannuelrestant'],
      congepersonellerestant: json['congepersonellerestant'],
    );
  }
}

Future<Employee> fetchEmployeeData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == null) {
    throw Exception('No email found in SharedPreferences');
  }

  final response =
      await http.get(Uri.parse('http://192.168.1.20:5000/employees/$email'));

  if (response.statusCode == 200) {
    return Employee.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load employee data');
  }
}

class User {
  final String fullname;
  final String dob;
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
  final String dateofdegree;
  final String jobtitle;
  final String departement;
  final String linemanager;
  final String startdate;
  final String enddate;
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'],
      dob: json['dob'],
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
      dateofdegree: json['dateofdegree'],
      jobtitle: json['jobtitle'],
      departement: json['departement'],
      linemanager: json['linemanager'],
      startdate: json['startdate'],
      enddate: json['enddate'],
      avatar: json['avatar'],
      status: json['status'],
      id2: json['id2'],
      degree: json['degree'],
      password: json['password'],
    );
  }
}

Future<List<Map<String, dynamic>>> fetchNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email') ?? '';

  final response = await http
      .get(Uri.parse('http://192.168.1.20:5000/notifications/$email'));

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> notifications =
        List<Map<String, dynamic>>.from(json.decode(response.body));

    // Filter the notifications where the title is 'Congé accepté' or 'Congé refusé'
    List<Map<String, dynamic>> filteredNotifications =
        notifications.where((notification) {
      final title = notification['title'];
      return title == 'Congé accepté' || title == 'Congé refusé';
    }).toList();

    return filteredNotifications;
  } else {
    throw Exception('Failed to load notifications');
  }
}

Future<User> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == null) {
    throw Exception('Aucun e-mail trouvé dans SharedPreferences');
  }

  final response =
      await http.get(Uri.parse('http://192.168.1.20:5000/users/$email'));

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Échec du chargement des données utilisateur');
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _user;
  late Future<Employee> _employee;

  @override
  void initState() {
    super.initState();
    _user = fetchUserData();
    _employee = fetchEmployeeData();
  }

  void _editUserDetails(User user) async {
    User? editedProfile = await showDialog<User>(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );

    if (editedProfile != null) {
      final response = await http.put(
        Uri.parse('http://192.168.1.20:5000/users/${editedProfile.email}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullname': editedProfile.fullname,
          'dob': editedProfile.dob,
          'gender': editedProfile.gender,
          'cin': editedProfile.cin,
          'phone': editedProfile.phone,
          'email': editedProfile.email,
          'adresse': editedProfile.adresse,
          'street': editedProfile.street,
          'state': editedProfile.state,
          'city': editedProfile.city,
          'postalcode': editedProfile.postalcode,
          'country': editedProfile.country,
          'typeofdegree': editedProfile.typeofdegree,
          'speciality': editedProfile.speciality,
          'dateofdegree': editedProfile.dateofdegree,
          'jobtitle': editedProfile.jobtitle,
          'departement': editedProfile.departement,
          'linemanager': editedProfile.linemanager,
          'startdate': editedProfile.startdate,
          'enddate': editedProfile.enddate,
          'avatar': editedProfile.avatar,
          'status': editedProfile.status,
          'id2': editedProfile.id2,
          'degree': editedProfile.degree,
          'password': editedProfile.password,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _user = fetchUserData(); // Refresh the user data after edit
        });
      } else {
        // Handle error
        print('Échec de la mise à jour de l\'utilisateur');
      }
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
              'Profile',
              style: TextStyle(color: Colors.white), // Set title color to white
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications,
                    color: Colors.white), // Notification icon
                onPressed: () async {
                  try {
                    List<Map<String, dynamic>> notifications =
                        await fetchNotifications();
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
      body: SingleChildScrollView(
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
                FutureBuilder<User>(
                  future: _user,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final user = snapshot.data!;
                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    user.avatar), // Display avatar image
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt,
                                      color: Colors.blue),
                                  onPressed: () {
                                    // Handle camera icon press
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            user.fullname,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildInfoBox(
                            title: 'Informations personnelles',
                            children: [
                              _buildInfoRow('Date de naissance',
                                  user.dob.substring(0, 10)),
                              _buildInfoRow('Genre', user.gender),
                              _buildInfoRow('CIN', user.cin.toString()),
                              _buildInfoRow('Téléphone', user.phone.toString()),
                              _buildInfoRow('Email', user.email),
                              _buildInfoRow('Address', user.adresse),
                              _buildInfoRow('Rue', user.street),
                              _buildInfoRow('État', user.state),
                              _buildInfoRow('Ville', user.city),
                              _buildInfoRow(
                                  'Code Postal', user.postalcode.toString()),
                              _buildInfoRow('Pays', user.country),
                            ],
                          ),
                          SizedBox(height: 20),
                          _buildInfoBox(
                            title: 'Détails de l\'éducation',
                            children: [
                              _buildInfoRow(
                                  'Type de diplôme', user.typeofdegree),
                              _buildInfoRow('Spécialité', user.speciality),
                              _buildInfoRow('Date du diplôme',
                                  user.dateofdegree.substring(0, 10)),
                            ],
                          ),
                          SizedBox(height: 20),
                          _buildInfoBox(
                            title: 'Détails du poste',
                            children: [
                              _buildInfoRow('Titre d\'emploi', user.jobtitle),
                              _buildInfoRow('Département', user.departement),
                              _buildInfoRow('chef d\'équipe', user.linemanager),
                              _buildInfoRow('Date de début',
                                  user.startdate.substring(0, 10)),
                              _buildInfoRow(
                                  'Date de fin', user.enddate.substring(0, 10)),
                            ],
                          ),
                          SizedBox(height: 20),
                          FutureBuilder<Employee>(
                            future: _employee,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                final employee = snapshot.data!;
                                return _buildInfoBox(
                                  title: 'Soldes de congé',
                                  children: [
                                    _buildInfoRow('Congé annuel',
                                        employee.congeannuelrestant.toString()),
                                    _buildInfoRow(
                                        'Congé de maladie',
                                        employee.congemaladierestant
                                            .toString()),
                                    _buildInfoRow(
                                        'Congé personnel',
                                        employee.congepersonellerestant
                                            .toString()),
                                  ],
                                );
                              } else {
                                return Center(child: Text('No data found'));
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.black],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Make button background transparent
                                elevation: 0, // Remove button shadow
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                              ),
                              onPressed: () => _editUserDetails(snapshot.data!),
                              child: Text(
                                'Modifier le profil',
                                style: TextStyle(
                                  color:
                                      Colors.white, // Set text color to white
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text('No data found'));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: Colors.blue, // Blue border color
            width: 5.0, // Border width
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
