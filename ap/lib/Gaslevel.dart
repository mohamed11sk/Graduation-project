import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Gas_Level extends StatefulWidget {
  const Gas_Level({super.key});

  @override
  _Gas_LevelState createState() => _Gas_LevelState();
}

class _Gas_LevelState extends State<Gas_Level> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenForGasLevelUpdates();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(int gasLevel) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'gas_level_channel', 
      'Gas Level Alerts', 
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Gas Level Alert', // Title
      'Gas level has reached $gasLevel ppm!', // Body
      platformChannelSpecifics,
    );
  }

  void _listenForGasLevelUpdates() {
    FirebaseFirestore.instance
        .collection('EspData')
        .orderBy('Timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data();
        int gasLevel = (data['GasLevel'] as num).toInt();

        if (gasLevel > 50) {
          _showNotification(gasLevel); 
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Text(
          "GAS LEVEL",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cursve',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('EspData')
            .orderBy('Timestamp', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          Map<String, dynamic> data =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          int gasLevel = (data['GasLevel'] as num).toInt();

          Color backgroundColor = gasLevel > 50 ? Colors.red : Colors.black;
          Color textColor = gasLevel > 50 ? Colors.white : Colors.white70;

          return Container(
            color: backgroundColor,
            child: Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: gasLevel > 50 ? Colors.red : Colors.blueAccent,
                        width: 4),
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: gasLevel > 50
                          ? [Colors.red.shade900, Colors.red.shade700]
                          : [
                              Colors.blueGrey.shade900,
                              Colors.blueGrey.shade700
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (gasLevel > 50 ? Colors.red : Colors.blueAccent)
                            .withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$gasLevel',
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ppm',
                        style: TextStyle(fontSize: 25, color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
