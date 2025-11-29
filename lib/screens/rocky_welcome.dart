import 'package:flutter/material.dart';
import 'register.dart';

class RockyWelcome extends StatefulWidget {
  const RockyWelcome({super.key});

  @override
  State<RockyWelcome> createState() => _RockyWelcomeState();
}

class _RockyWelcomeState extends State<RockyWelcome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hi! I am ROCKY 🤖",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween(begin: 0.9, end: 1.1).animate(_controller),
              child: const Icon(Icons.smart_toy, size: 100, color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("START"),
            ),
          ],
        ),
      ),
    );
  }
}

