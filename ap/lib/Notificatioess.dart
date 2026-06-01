import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notifications extends StatefulWidget {
  const notifications({super.key});

  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenForGasLevelUpdates();
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.pop(context);
    });
  }

  // Initialize local notifications
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
      0, 
      'Gas Level Alert', 
      'Gas level has reached $gasLevel ppm!', 
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
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
