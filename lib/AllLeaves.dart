// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:visto_mobile/Leaves.dart';
// import 'package:visto_mobile/main.dart';

// class LeaveListPage extends StatefulWidget {
//   @override
//   _LeaveListPageState createState() => _LeaveListPageState();
// }

// class _LeaveListPageState extends State<LeaveListPage> {
//   late Future<List<Leave>> _futureLeaveData;

//   @override
//   void initState() {
//     super.initState();
//     _futureLeaveData = fetchLeaveData();
//   }

//   Widget buildLegendItem(Color color, String label) {
//     return Row(
//       children: [
//         Container(
//           width: 20,
//           height: 20,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [color, Colors.black],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//         SizedBox(width: 8),
//         Text(
//           label,
//           style: TextStyle(color: Colors.black),
//         ),
//       ],
//     );
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
//               'Leave Requests',
//               style: TextStyle(color: Colors.white), // Set title color to white
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.notifications,
//                     color: Colors.white), // Notification icon
//                 onPressed: () {
//                   // Handle the notification icon tap event here
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.logout, color: Colors.white), // Logout icon
//                 onPressed: () async {
//                   final prefs = await SharedPreferences.getInstance();
//                   await prefs.remove('access_token');
//                   await prefs.remove('fullname');
//                   await prefs.remove('avatar');
//                   await prefs.remove('email');

//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomePage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 buildLegendItem(Colors.green, 'Accepted'),
//                 buildLegendItem(Colors.orange, 'Pending'),
//                 buildLegendItem(Colors.red, 'Refused'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Leave>>(
//               future: _futureLeaveData,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No leave data available.'));
//                 } else {
//                   return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       final leave = snapshot.data![index];

//                       // Determine the gradient and shadow based on the statut
//                       BoxDecoration boxDecoration;
//                       if (leave.statut == 'refuse') {
//                         boxDecoration = BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.red, Colors.black],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         );
//                       } else if (leave.statut == 'accepte') {
//                         boxDecoration = BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.green, Colors.black],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         );
//                       } else if (leave.statut == 'en attente') {
//                         boxDecoration = BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.orange, Colors.black],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         );
//                       } else {
//                         boxDecoration = BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         );
//                       }

//                       return Container(
//                         decoration: boxDecoration,
//                         margin:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         child: Stack(
//                           children: [
//                             Column(
//                               children: [
//                                 Card(
//                                   color: Colors.transparent,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(15),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '${leave.type}', // Removed leave.statut
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Text(
//                                           'From ${leave.start} to ${leave.end}',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         if (leave.supportingdoc != null)
//                                           Align(
//                                             alignment: Alignment.centerRight,
//                                             child: IconButton(
//                                               icon: Icon(Icons.attach_file,
//                                                   color: Colors.white),
//                                               onPressed: () {
//                                                 // Handle document view or download
//                                               },
//                                             ),
//                                           ),
//                                         SizedBox(
//                                             height:
//                                                 40), // Add space for the delete icon if needed
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             if (leave.statut == 'en attente')
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: IconButton(
//                                   icon: Icon(Icons.edit, color: Colors.white),
//                                   onPressed: () {
//                                     // Handle edit action
//                                   },
//                                 ),
//                               ),
//                             if (leave.statut == 'en attente')
//                               Positioned(
//                                 bottom: 10,
//                                 left: 10,
//                                 child: IconButton(
//                                   icon: Icon(Icons.delete, color: Colors.white),
//                                   onPressed: () {
//                                     // Handle delete action
//                                   },
//                                 ),
//                               ),
//                             if (leave.statut == 'accepte' &&
//                                 leave.type == 'Congés de maladie')
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: IconButton(
//                                   icon: Icon(Icons.edit, color: Colors.white),
//                                   onPressed: () {
//                                     // Handle edit action
//                                   },
//                                 ),
//                               ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:visto_mobile/Leaves.dart';
import 'package:visto_mobile/main.dart';

class LeaveListPage extends StatefulWidget {
  @override
  _LeaveListPageState createState() => _LeaveListPageState();
}

class _LeaveListPageState extends State<LeaveListPage> {
  late Future<List<Leave>> _futureLeaveData;

  @override
  void initState() {
    super.initState();
    _futureLeaveData = fetchLeaveData();
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

  Widget buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              'Demandes de congé²',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLegendItem(Colors.green, 'Accepté'),
                buildLegendItem(Colors.orange, 'En attente'),
                buildLegendItem(Colors.red, 'Refusé'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Leave>>(
              future: _futureLeaveData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No leave data available.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final leave = snapshot.data![index];

                      // Determine the decoration based on the statut
                      BoxDecoration boxDecoration;
                      if (leave.statut == 'refuse') {
                        boxDecoration = BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        );
                      } else if (leave.statut == 'accepte') {
                        boxDecoration = BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        );
                      } else if (leave.statut == 'en attente') {
                        boxDecoration = BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        );
                      } else {
                        boxDecoration = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        );
                      }

                      return Container(
                        decoration: boxDecoration,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Card(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${leave.type}', // Removed leave.statut
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'From: ${leave.formatDate(leave.start)} To: ${leave.formatDate(leave.end)}',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        if (leave.supportingdoc != null)
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: Icon(Icons.attach_file,
                                                  color: Colors.black),
                                              onPressed: () {
                                                // Handle file attachment
                                                print(
                                                    'Attached file: ${leave.supportingdoc}');
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (leave.statut == 'accepte')
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Accepté',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            else if (leave.statut == 'refuse')
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Refusé',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            else if (leave.statut == 'en attente')
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'En attente',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
