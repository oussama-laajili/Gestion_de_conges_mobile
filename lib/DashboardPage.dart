// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   List<String> labelsType = [];
//   List<double> dataType = [];
//   List<String> labelsStatus = [];
//   List<double> dataStatus = [];
//   bool isLoading = true;
//   int? touchedIndexType;
//   int? touchedIndexStatus;
//   Map<String, int> specialLeaveTypes = {}; // Variable for special leave types
//   int totalSpecialLeave = 0;

//   // List of icons for leave types
//   final List<IconData> leaveIcons = [
//     Icons.beach_access, // Replace with your own icons
//     Icons.flight_takeoff,
//     Icons.local_activity,
//     Icons.event,
//     Icons.mood
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchChartData();
//   }

//   Future<void> fetchChartData() async {
//     try {
//       final responseType = await http
//           .get(Uri.parse('http://192.168.1.20:5000/conges/count-by-type'));
//       final responseStatus = await http
//           .get(Uri.parse('http://192.168.1.20:5000/conges/count-by-status'));
//       final responseSpecial = await http.get(
//           Uri.parse('http://192.168.1.20:5000/conges/count-special-types'));

//       if (responseType.statusCode == 200 &&
//           responseStatus.statusCode == 200 &&
//           responseSpecial.statusCode == 200) {
//         final responseDataType = json.decode(responseType.body);
//         final responseDataStatus = json.decode(responseStatus.body);
//         final responseSpecialData = json.decode(responseSpecial.body);

//         setState(() {
//           labelsType = List<String>.from(responseDataType['labels']);
//           dataType = List<double>.from(
//               responseDataType['data'].map((value) => value.toDouble()));

//           labelsStatus = List<String>.from(responseDataStatus['labels']);
//           dataStatus = List<double>.from(
//               responseDataStatus['data'].map((value) => value.toDouble()));

//           specialLeaveTypes = Map<String, int>.from(responseSpecialData);
//           totalSpecialLeave =
//               specialLeaveTypes.values.fold(0, (sum, count) => sum + count);

//           // Set the default selected index for pie charts
//           touchedIndexType =
//               dataType.indexOf(dataType.reduce((a, b) => a > b ? a : b));
//           touchedIndexStatus =
//               dataStatus.indexOf(dataStatus.reduce((a, b) => a > b ? a : b));

//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
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
//               'Dashboard',
//               style: TextStyle(color: Colors.white), // Set title color to white
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   // GridView for special leave types
//                   GridView.builder(
//                     shrinkWrap:
//                         true, // Allows GridView to take only the space it needs
//                     physics:
//                         NeverScrollableScrollPhysics(), // Disable GridView scrolling
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 16.0,
//                       mainAxisSpacing: 16.0,
//                       childAspectRatio: 2.0,
//                     ),
//                     itemCount:
//                         specialLeaveTypes.length + 1, // Add 1 for the total box
//                     itemBuilder: (context, index) {
//                       if (index == specialLeaveTypes.length) {
//                         // Total Box
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             border: Border(
//                               left: BorderSide(
//                                 color:
//                                     Colors.green, // Set border color to green
//                                 width: 4.0,
//                               ),
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 spreadRadius: 2,
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           padding: EdgeInsets.all(16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Total Special Leave',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 totalSpecialLeave.toString(),
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       } else {
//                         // Leave Type Boxes
//                         final leaveType =
//                             specialLeaveTypes.keys.elementAt(index);
//                         final count = specialLeaveTypes[leaveType]!;

//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             border: Border(
//                               left: BorderSide(
//                                 color: Color(0xFF4069E5),
//                                 width: 4.0,
//                               ),
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 spreadRadius: 2,
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           padding: EdgeInsets.all(16),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 leaveIcons[index % leaveIcons.length],
//                                 size: 30,
//                                 color: Color(0xFF4069E5),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 child: Text(
//                                   leaveType,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 count.toString(),
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                   SizedBox(
//                       height: 25), // Margin between the boxes and the charts
//                   // Pie Charts and Legends
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Pie Chart for Leave Types
//                       Center(
//                         child: _buildCircularChart(
//                           dataType,
//                           labelsType,
//                           touchedIndexType,
//                           (index) {
//                             setState(() {
//                               touchedIndexType = index;
//                             });
//                           },
//                           [
//                             Color(0xFF4069E5),
//                             Color(0xFFC5D1F7),
//                             Color(0xFF98AFF2)
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 16), // Margin between chart and legend
//                       _buildLegend(labelsType, [
//                         Color(0xFF4069E5),
//                         Color(0xFFC5D1F7),
//                         Color(0xFF98AFF2)
//                       ]),
//                       SizedBox(height: 32), // Margin between charts
//                       // Pie Chart for Leave Status
//                       Center(
//                         child: _buildCircularChart(
//                           dataStatus,
//                           labelsStatus,
//                           touchedIndexStatus,
//                           (index) {
//                             setState(() {
//                               touchedIndexStatus = index;
//                             });
//                           },
//                           [
//                             Color(0xFF3c4cb9),
//                             Color(0xFF38429b),
//                             Color(0xFF303978)
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 16), // Margin between chart and legend
//                       _buildLegend(labelsStatus, [
//                         Color(0xFF3c4cb9),
//                         Color(0xFF38429b),
//                         Color(0xFF303978)
//                       ]),
//                     ],
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildCircularChart(
//     List<double> data,
//     List<String> labels,
//     int? touchedIndex,
//     void Function(int) onTouch,
//     List<Color> colors,
//   ) {
//     return SizedBox(
//       height: 220,
//       width: 200,
//       child: PieChart(
//         PieChartData(
//           sectionsSpace: 0,
//           centerSpaceRadius: 50,
//           sections: List.generate(data.length, (index) {
//             final isTouched = index == touchedIndex;
//             final fontSize = isTouched ? 16.0 : 14.0;
//             final radius = isTouched ? 70.0 : 60.0;
//             final value = data[index];
//             return PieChartSectionData(
//               color: colors[index],
//               value: value,
//               radius: radius,
//               title: '', // Remove title if using badgeWidget
//               titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               titlePositionPercentageOffset: 0.55,
//               badgeWidget: isTouched
//                   ? Text(
//                       '$value',
//                       style: TextStyle(
//                         fontSize: fontSize,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     )
//                   : null,
//             );
//           }),
//           pieTouchData: PieTouchData(
//             touchCallback: (FlTouchEvent event, pieTouchResponse) {
//               if (event is FlTapUpEvent && pieTouchResponse != null) {
//                 final index =
//                     pieTouchResponse.touchedSection!.touchedSectionIndex;
//                 onTouch(index);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLegend(List<String> labels, List<Color> colors) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(labels.length, (index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Container(
//                   width: 10,
//                   height: 16,
//                   color: colors[index],
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   labels[index],
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:visto_mobile/main.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> labelsType = [];
  List<double> dataType = [];
  List<String> labelsStatus = [];
  List<double> dataStatus = [];
  bool isLoading = true;
  int? touchedIndexType;
  int? touchedIndexStatus;
  Map<String, int> specialLeaveTypes = {}; // Variable for special leave types
  int totalSpecialLeave = 0;

  // List of icons for leave types
  final List<IconData> leaveIcons = [
    Icons.beach_access, // Replace with your own icons
    Icons.flight_takeoff,
    Icons.local_activity,
    Icons.event,
    Icons.mood
  ];

  @override
  void initState() {
    super.initState();
    fetchChartData();
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

  Future<void> fetchChartData() async {
    try {
      final responseType = await http
          .get(Uri.parse('http://192.168.1.20:5000/conges/count-by-type'));
      final responseStatus = await http
          .get(Uri.parse('http://192.168.1.20:5000/conges/count-by-status'));
      final responseSpecial = await http.get(
          Uri.parse('http://192.168.1.20:5000/conges/count-special-types'));

      if (responseType.statusCode == 200 &&
          responseStatus.statusCode == 200 &&
          responseSpecial.statusCode == 200) {
        final responseDataType = json.decode(responseType.body);
        final responseDataStatus = json.decode(responseStatus.body);
        final responseSpecialData = json.decode(responseSpecial.body);

        setState(() {
          labelsType = List<String>.from(responseDataType['labels']);
          dataType = List<double>.from(
              responseDataType['data'].map((value) => value.toDouble()));

          labelsStatus = List<String>.from(responseDataStatus['labels']);
          dataStatus = List<double>.from(
              responseDataStatus['data'].map((value) => value.toDouble()));

          specialLeaveTypes = Map<String, int>.from(responseSpecialData);
          totalSpecialLeave =
              specialLeaveTypes.values.fold(0, (sum, count) => sum + count);

          // Set the default selected index for pie charts
          touchedIndexType =
              dataType.indexOf(dataType.reduce((a, b) => a > b ? a : b));
          touchedIndexStatus =
              dataStatus.indexOf(dataStatus.reduce((a, b) => a > b ? a : b));

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              'Tableau de bord',
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
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // GridView for special leave types
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 2.0,
                    ),
                    itemCount:
                        specialLeaveTypes.length + 1, // Add 1 for the total box
                    itemBuilder: (context, index) {
                      if (index == specialLeaveTypes.length) {
                        // Total Box

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.black],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Total des congés ',
                                  style: TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                totalSpecialLeave.toString(),
                                style: TextStyle(
                                  color:
                                      Colors.white, // Set text color to white
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Leave Type Boxes
                        final leaveType =
                            specialLeaveTypes.keys.elementAt(index);
                        final count = specialLeaveTypes[leaveType]!;

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                            border: Border(
                              left: BorderSide(
                                color:
                                    Colors.blue, // Set the border color to blue
                                width: 4, // Set the border width as desired
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                leaveIcons[index % leaveIcons.length],
                                size: 30,
                                color: Colors.black,
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  leaveType,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                count.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(
                      height: 25), // Margin between the boxes and the charts
                  // Pie Charts and Legends
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Pie Chart for Leave Types
                      Center(
                        child: _buildCircularChart(
                          dataType,
                          labelsType,
                          touchedIndexType,
                          (index) {
                            setState(() {
                              touchedIndexType = index;
                            });
                          },
                          [
                            Color(0xFF4069E5),
                            Color(0xFFC5D1F7),
                            Color(0xFF98AFF2)
                          ],
                        ),
                      ),
                      SizedBox(height: 16), // Margin between chart and legend
                      _buildLegend(labelsType, [
                        Color(0xFF4069E5),
                        Color(0xFFC5D1F7),
                        Color(0xFF98AFF2)
                      ]),
                      SizedBox(height: 32), // Margin between charts
                      // Pie Chart for Leave Status
                      Center(
                        child: _buildCircularChart(
                          dataStatus,
                          labelsStatus,
                          touchedIndexStatus,
                          (index) {
                            setState(() {
                              touchedIndexStatus = index;
                            });
                          },
                          [
                            Color(0xFF3c4cb9),
                            Color(0xFF38429b),
                            Color(0xFF303978)
                          ],
                        ),
                      ),
                      SizedBox(height: 16), // Margin between chart and legend
                      _buildLegend(labelsStatus, [
                        Color(0xFF3c4cb9),
                        Color(0xFF38429b),
                        Color(0xFF303978)
                      ]),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCircularChart(
    List<double> data,
    List<String> labels,
    int? touchedIndex,
    void Function(int) onTouch,
    List<Color> colors,
  ) {
    return SizedBox(
      height: 220,
      width: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 50,
          sections: List.generate(data.length, (index) {
            final isTouched = index == touchedIndex;
            final fontSize = isTouched ? 16.0 : 14.0;
            final radius = isTouched ? 70.0 : 60.0;
            final value = data[index];
            return PieChartSectionData(
              color: colors[index],
              value: value,
              radius: radius,
              title: '', // Remove title if using badgeWidget
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titlePositionPercentageOffset: 0.55,
              badgeWidget: isTouched
                  ? Text(
                      '$value',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            );
          }),
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              if (event is FlTapUpEvent && pieTouchResponse != null) {
                final index =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                onTouch(index);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(List<String> labels, List<Color> colors) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(labels.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 16,
                  color: colors[index],
                ),
                SizedBox(width: 8),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}





















// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   List<String> labelsType = [];
//   List<double> dataType = [];
//   List<String> labelsStatus = [];
//   List<double> dataStatus = [];
//   bool isLoading = true;
//   int? touchedIndexType;
//   int? touchedIndexStatus;
//   Map<String, int> specialLeaveTypes = {}; // Variable for special leave types
//   int totalSpecialLeave = 0;

//   // List of icons for leave types
//   final List<IconData> leaveIcons = [
//     Icons.beach_access, // Replace with your own icons
//     Icons.flight_takeoff,
//     Icons.local_activity,
//     Icons.event,
//     Icons.mood
//   ];

//   // List of gradients for the boxes
//   final List<List<Color>> boxGradients = [
//     [Colors.purple, Colors.blue],
//     [Colors.red, Colors.orange],
//     [Colors.green, Colors.teal],
//     [Colors.blue, Colors.indigo],
//     [Colors.pink, Colors.purple],
//     [Colors.yellow, Colors.orange],
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchChartData();
//   }

//   Future<void> fetchChartData() async {
//     try {
//       final responseType = await http
//           .get(Uri.parse('http://192.168.1.20:5000/conges/count-by-type'));
//       final responseStatus = await http
//           .get(Uri.parse('http://192.168.1.20:5000/conges/count-by-status'));
//       final responseSpecial = await http.get(
//           Uri.parse('http://192.168.1.20:5000/conges/count-special-types'));

//       if (responseType.statusCode == 200 &&
//           responseStatus.statusCode == 200 &&
//           responseSpecial.statusCode == 200) {
//         final responseDataType = json.decode(responseType.body);
//         final responseDataStatus = json.decode(responseStatus.body);
//         final responseSpecialData = json.decode(responseSpecial.body);

//         setState(() {
//           labelsType = List<String>.from(responseDataType['labels']);
//           dataType = List<double>.from(
//               responseDataType['data'].map((value) => value.toDouble()));

//           labelsStatus = List<String>.from(responseDataStatus['labels']);
//           dataStatus = List<double>.from(
//               responseDataStatus['data'].map((value) => value.toDouble()));

//           specialLeaveTypes = Map<String, int>.from(responseSpecialData);
//           totalSpecialLeave =
//               specialLeaveTypes.values.fold(0, (sum, count) => sum + count);

//           // Set the default selected index for pie charts
//           touchedIndexType =
//               dataType.indexOf(dataType.reduce((a, b) => a > b ? a : b));
//           touchedIndexStatus =
//               dataStatus.indexOf(dataStatus.reduce((a, b) => a > b ? a : b));

//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
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
//               'Dashboard',
//               style: TextStyle(color: Colors.white), // Set title color to white
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   // GridView for special leave types
// GridView.builder(
//   shrinkWrap: true,
//   physics: NeverScrollableScrollPhysics(),
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 16.0,
//     mainAxisSpacing: 16.0,
//     childAspectRatio: 2.0,
//   ),
//   itemCount: specialLeaveTypes.length + 1, // Add 1 for the total box
//   itemBuilder: (context, index) {
//     final gradientColors = boxGradients[index % boxGradients.length];
//     if (index == specialLeaveTypes.length) {
//       // Total Box
//       return Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: gradientColors,
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 'Total Special Leave',
//                 style: TextStyle(
//                   color: Colors.white, // Set text color to white
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Text(
//               totalSpecialLeave.toString(),
//               style: TextStyle(
//                 color: Colors.white, // Set text color to white
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Leave Type Boxes
//       final leaveType = specialLeaveTypes.keys.elementAt(index);
//       final count = specialLeaveTypes[leaveType]!;

//       return Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: gradientColors,
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Icon(
//               leaveIcons[index % leaveIcons.length],
//               size: 30,
//               color: Colors.white, // Set icon color to white
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 leaveType,
//                 style: TextStyle(
//                   color: Colors.white, // Set text color to white
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Text(
//               count.toString(),
//               style: TextStyle(
//                 color: Colors.white, // Set text color to white
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   },
// ),

//                   SizedBox(
//                       height: 25), // Margin between the boxes and the charts
//                   // Pie Charts and Legends
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Pie Chart for Leave Types
//                       Center(
//                         child: _buildCircularChart(
//                           dataType,
//                           labelsType,
//                           touchedIndexType,
//                           (index) {
//                             setState(() {
//                               touchedIndexType = index;
//                             });
//                           },
//                           [
//                             Color(0xFF4069E5),
//                             Color(0xFFC5D1F7),
//                             Color(0xFF98AFF2)
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 16), // Margin between chart and legend
//                       _buildLegend(labelsType, [
//                         Color(0xFF4069E5),
//                         Color(0xFFC5D1F7),
//                         Color(0xFF98AFF2)
//                       ]),
//                       SizedBox(height: 32), // Margin between charts
//                       // Pie Chart for Leave Status
//                       Center(
//                         child: _buildCircularChart(
//                           dataStatus,
//                           labelsStatus,
//                           touchedIndexStatus,
//                           (index) {
//                             setState(() {
//                               touchedIndexStatus = index;
//                             });
//                           },
//                           [
//                             Color(0xFF3c4cb9),
//                             Color(0xFF38429b),
//                             Color(0xFF303978)
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 16), // Margin between chart and legend
//                       _buildLegend(labelsStatus, [
//                         Color(0xFF3c4cb9),
//                         Color(0xFF38429b),
//                         Color(0xFF303978)
//                       ]),
//                     ],
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildCircularChart(
//     List<double> data,
//     List<String> labels,
//     int? touchedIndex,
//     void Function(int) onTouch,
//     List<Color> colors,
//   ) {
//     return SizedBox(
//       height: 220,
//       width: 200,
//       child: PieChart(
//         PieChartData(
//           sectionsSpace: 0,
//           centerSpaceRadius: 50,
//           startDegreeOffset: -90,
//           sections: List.generate(data.length, (i) {
//             final isTouched = i == touchedIndex;
//             final fontSize = isTouched ? 18.0 : 16.0;
//             final radius = isTouched ? 60.0 : 50.0;
//             final widgetSize = isTouched ? 40.0 : 30.0;
//             final value = data[i];

//             return PieChartSectionData(
//               color: colors[i % colors.length],
//               value: value,
//               title: value.toString(),
//               radius: radius,
//               titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               badgeWidget: _Badge(
//                 value.toString(),
//                 size: widgetSize,
//                 borderColor: colors[i % colors.length],
//               ),
//               badgePositionPercentageOffset: .98,
//             );
//           }),
//           pieTouchData: PieTouchData(
//             touchCallback: (FlTouchEvent event, pieTouchResponse) {
//               if (event is FlTapUpEvent && pieTouchResponse != null) {
//                 final index =
//                     pieTouchResponse.touchedSection!.touchedSectionIndex;
//                 onTouch(index);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLegend(List<String> labels, List<Color> colors) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: List.generate(labels.length, (i) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 16,
//               height: 16,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: colors[i % colors.length],
//               ),
//             ),
//             SizedBox(width: 4),
//             Text(
//               labels[i],
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black, // Set legend text color to black
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// class _Badge extends StatelessWidget {
//   final String value;
//   final double size;
//   final Color borderColor;

//   const _Badge(
//     this.value, {
//     Key? key,
//     required this.size,
//     required this.borderColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: borderColor, width: 2),
//       ),
//       child: Center(
//         child: Text(
//           value,
//           style: TextStyle(
//             fontSize: size * 0.4,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
