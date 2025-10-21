import 'package:flutter/material.dart';
import 'primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: PrimaryButton(
          label: 'Press me',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Button pressed')),
            );
          },
        ),
      ),
    );
  }
}
