import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visto_mobile/main.dart';

class ScrollingCalendarPage extends StatefulWidget {
  @override
  _ScrollingCalendarPageState createState() => _ScrollingCalendarPageState();
}

class _ScrollingCalendarPageState extends State<ScrollingCalendarPage> {
  int _selectedYear = DateTime.now().year;
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
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

  Future<void> _fetchEvents() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.20:5000/calendar'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _events = data
            .map((event) => {
                  'title': event['title'],
                  'startDate': DateTime.parse(event['startDate']),
                  'endDate': DateTime.parse(event['endDate']),
                  'recurrence': event['recurrence'],
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load events');
    }
  }

  void _onYearChanged(int newYear) {
    setState(() {
      _selectedYear = newYear;
    });
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
              'Calendrier des congés',
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Année: $_selectedYear',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedYear,
                  items: List.generate(20, (index) => 2018 + index)
                      .map<DropdownMenuItem<int>>((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      _onYearChanged(newValue);
                    }
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Ensure row takes only as much space as needed
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text('Accepté', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 16),
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text('Refusé', style: TextStyle(fontSize: 16)),
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Text('En attente', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          Expanded(
            child: CalendarYearView(year: _selectedYear, events: _events),
          ),
        ],
      ),
    );
  }
}

class CalendarYearView extends StatelessWidget {
  final int year;
  final List<Map<String, dynamic>> events;

  CalendarYearView({required this.year, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            year.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return CalendarMonthView(
                month: index + 1,
                year: year,
                events: events,
              );
            },
          ),
        ),
      ],
    );
  }
}

class CalendarMonthView extends StatelessWidget {
  final int month;
  final int year;
  final List<Map<String, dynamic>> events;

  CalendarMonthView(
      {required this.month, required this.year, required this.events});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isCurrentMonth = now.month == month && now.year == year;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _monthName(month),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: DateTime(year, month + 1, 0).day,
                itemBuilder: (context, index) {
                  int day = index + 1;
                  DateTime date = DateTime(year, month, day);
                  bool isToday = isCurrentMonth && now.day == day;
                  List<Color> highlightColors = _getHighlightColors(date);

                  return GestureDetector(
                    onTap: () {
                      _showEventDetails(context, date);
                    },
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isToday ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            // Draw lines for events
                            for (int i = 0; i < highlightColors.length; i++)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  color: highlightColors[i],
                                ),
                              ),
                            // Display day number
                            Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  color: isToday ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    return [
      'Jan',
      'Fev',
      'Mar',
      'Avr',
      'Mai',
      'juin',
      'Juillet',
      'Août',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month - 1];
  }

  List<Color> _getHighlightColors(DateTime date) {
    Set<Color> colors = {};
    for (var event in events) {
      if (date.isAfter(event['startDate'].subtract(Duration(days: 1))) &&
          date.isBefore(event['endDate'].add(Duration(days: 1)))) {
        colors.add(_getEventColor(event['recurrence']));
      }
    }
    return colors.toList();
  }

  Color _getEventColor(String recurrence) {
    // Define your colors for different event types here
    final Map<String, Color> eventColors = {
      "accepted": Colors.green,
      "refused": Colors.red,
      "en attente": Colors.orange,
    };
    return eventColors[recurrence] ?? Colors.blueAccent;
  }

  void _showEventDetails(BuildContext context, DateTime date) {
    final eventsForDay = events
        .where((event) =>
            event['startDate'].isBefore(date.add(Duration(days: 1))) &&
            event['endDate'].isAfter(date.subtract(Duration(days: 1))))
        .toList();

    if (eventsForDay.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Événements pour ${DateFormat('d/M/yyyy').format(date)}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: eventsForDay.map((event) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${event['title']} (${DateFormat('d/M/yyyy').format(event['startDate'])} - ${DateFormat('d/M/yyyy').format(event['endDate'])})',
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
