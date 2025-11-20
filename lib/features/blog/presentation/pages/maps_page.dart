import 'package:flutter/material.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  static route() => MaterialPageRoute(builder: (_) => const MapsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map Integration")),
      body: const Center(
        child: Text(
          "Google Maps will be integrated here.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
