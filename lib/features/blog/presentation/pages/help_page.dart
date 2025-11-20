import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static route() => MaterialPageRoute(builder: (context) => const HelpPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Need Help?'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'If you need help, please reach out.\n'
            'These numbers are examples – replace with your local Monroe community helplines.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),

          // Example card 1
          Card(
            child: ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text('Emergency Services'),
              subtitle: Text('Call 911 for life-threatening emergencies.'),
            ),
          ),
          SizedBox(height: 8),

          // Example card 2
          Card(
            child: ListTile(
              leading: Icon(Icons.phone_in_talk),
              title: Text('Mental Health / Crisis Support'),
              subtitle: Text(
                'National Suicide & Crisis Lifeline: 988\n'
                'Available 24/7, confidential support.',
              ),
            ),
          ),
          SizedBox(height: 8),

          // Example card 3 – local community placeholder
          Card(
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text('Local Community Center (Monroe)'),
              subtitle: Text(
                'Example: Monroe Community Resource Center\n'
                'Phone: (000) 000-0000\n'
                'Replace this with your actual local helpline.',
              ),
            ),
          ),
          SizedBox(height: 8),

          // Example card 4
          Card(
            child: ListTile(
              leading: Icon(Icons.shield),
              title: Text('Domestic Violence / Safety'),
              subtitle: Text(
                'National Domestic Violence Hotline: 1-800-799-SAFE (7233)\n'
                'Chat & resources available 24/7.',
              ),
            ),
          ),

          SizedBox(height: 24),
          Text(
            'If you are in immediate danger, call 911 right away.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
