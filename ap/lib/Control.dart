import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'home.dart';

void main() {
  runApp(const Control());
}

class Control extends StatelessWidget {
  const Control({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool switch1 = true;

  final TextEditingController ipController = TextEditingController();
  WebSocketChannel? _channel;
  bool isConnected = false;
  String receivedMessage = '';
  String firebaseIp = '';

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchIpFromFirebase(); // Fetch the IP address on app startup
  }

  // Fetch IP from Firebase Realtime Database
  Future<void> fetchIpFromFirebase() async {
    DatabaseReference reference = _database.child('EspData/ip');
    reference.once().then((DatabaseEvent event) {
      setState(() {
        firebaseIp = event.snapshot.value.toString();
        ipController.text = '$firebaseIp:81'; // Append :81 to the IP address
      });
    }).catchError((error) {
      print('Error fetching IP: $error');
    });
  }

  // Connect to WebSocket
  Future<void> connect() async {
    if (ipController.text.isNotEmpty) {
      final uri = 'ws://${ipController.text}';
      try {
        _channel = WebSocketChannel.connect(Uri.parse(uri));
        setState(() {
          isConnected = true;
        });
        _channel!.stream.listen((message) {
          setState(() {
            receivedMessage = message;
          });
          print('Received: $message');
        }, onError: (error) {
          print('Error: $error');
          setState(() {
            isConnected = false;
          });
        }, onDone: () {
          setState(() {
            isConnected = false;
          });
        });
      } catch (e) {
        print('Connection failed: $e');
        setState(() {
          isConnected = false;
        });
      }
    } else {
      print('Please enter a valid IP address.');
    }
  }

  // Copy IP to clipboard
  void copyIpToClipboard() {
    final ip = ipController.text;
    if (ip.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: ip)); // Clipboard usage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP Address copied to clipboard')),
      );
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
        title: const Center(
          child: Text(
            "Gas",
            style: TextStyle(
              color: Color.fromARGB(255, 226, 216, 216),
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: ipController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'IP',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: connect,
                  child: const Text("Connect"),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: copyIpToClipboard, // Use the copy function
                ),
              ],
            ),
            if (isConnected)
              const Text("Connected", style: TextStyle(color: Colors.green))
            else
              const Text("Not connected", style: TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            Text("Received: $receivedMessage"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Heater:",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Switch(
                  value: switch1,
                  onChanged: (value) {
                    setState(() {
                      switch1 = value;
                      _channel?.sink.add('LED1:${value ? 1 : 0}');
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
