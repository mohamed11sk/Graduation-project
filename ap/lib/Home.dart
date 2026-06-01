import 'package:flutter/material.dart';
import 'History.dart';
import 'Control.dart';
import 'Gaslevel.dart';
import 'Chart.dart';
import 'profile.dart';
import 'start.dart';
import 'ChatScreen.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
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
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 30, 34, 51),
          child: ListView(
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.grey[900],
                elevation: 0,
                automaticallyImplyLeading: false,
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.close,
                          color: Color.fromARGB(255, 228, 100, 100)),
                      onPressed: () {
                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                  ),
                ],
              ),
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    image: DecorationImage(
                      image: AssetImage('images/logo.png'),
                      scale: 1.30,
                    )),
                child: null,
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('My Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Log Out',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Start()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 90.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildButton("GAS LEVEL", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Gas_Level()),
                    );
                  }),
                  buildButton("History", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryPage()),
                    );
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildButton("Charts", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Chart()),
                    );
                  }),
                  buildButton("Control", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Control()),
                    );
                  }),
                ],
              ),
              buildButton("Chat Ai", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 5,
        shadowColor: Colors.cyanAccent.withOpacity(0.5),
        fixedSize: const Size(150, 150),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
