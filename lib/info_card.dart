import 'package:flutter/material.dart';

class InfoCards extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoCards({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
