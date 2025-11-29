import 'package:flutter/material.dart';
import 'search.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("User Registration"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email Address"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: const Text("Register & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
