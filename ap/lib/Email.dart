import 'package:firebaseesp32/Home.dart';
import 'package:firebaseesp32/Notificatioess.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: Emails(),
    debugShowCheckedModeBanner: false,
  ));
}

class Emails extends StatefulWidget {
  const Emails({Key? key}) : super(key: key);

  @override
  _EmailsState createState() => _EmailsState();
}

class _EmailsState extends State<Emails> {
  DateTime? _lastEmailSentTime;
  String? serverIp;

  @override
  void initState() {
    super.initState();
    _listenToIpChanges();
    _listenForGasLevelUpdates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const notifications()),
      ).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      });
    });
  }

  void _listenToIpChanges() {
    final ref = FirebaseDatabase.instance.ref("EspData/ipai");
    ref.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          serverIp = data.toString();
          print("IP Updated from Firebase: $serverIp");
        });
      }
    });
  }

  void _listenForGasLevelUpdates() {
    FirebaseFirestore.instance
        .collection('EspData')
        .orderBy('Timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data();
        int gasLevel = (data['GasLevel'] as num).toInt();

        if (gasLevel > 50) {
          DateTime now = DateTime.now();
          if (_lastEmailSentTime == null ||
              now.difference(_lastEmailSentTime!) > const Duration(seconds: 6)) {
            _lastEmailSentTime = now;
            await _sendEmailNotification(gasLevel);
          }
        }
      }
    });
  }

  Future<void> _sendEmailNotification(int gasLevel) async {
    if (serverIp == null) {
      print("IP not yet loaded from Firebase.");
      return;
    }

    final url = Uri.parse('http://$serverIp/Email/alert.php');

    final response = await http.post(
      url,
      body: {'gas_level': gasLevel.toString()},
    );

    if (response.statusCode == 200) {
      print("Send Success to $url");
    } else {
      print("Error sending to $url: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
