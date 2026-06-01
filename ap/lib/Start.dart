import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const Start());
}

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/ar.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "𝔀𝓮𝓵𝓬𝓸𝓶𝓮",
              style: TextStyle(
                fontSize: 80.00,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    offset: const Offset(3, 3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 25),
                ),
                child: const Text(
                  "𝑺𝑻𝑨𝑹𝑻",
                  style: TextStyle(
                    fontSize: 50,
                    color: Color.fromARGB(255, 27, 101, 66),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
