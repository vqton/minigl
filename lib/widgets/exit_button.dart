import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  void closeApp() {
    SystemNavigator.pop(); // Closes the app
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12), // Adjust spacing
      child: InkWell(
        borderRadius: BorderRadius.circular(8), // Amazon-style rounded edges
        onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Exit App",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text("Are you sure you want to close the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Amazon's warning color
                  foregroundColor: Colors.white,
                ),
                onPressed: closeApp,
                child: const Text("Exit"),
              ),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.shade600, // Amazon-style strong action button
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.exit_to_app, color: Colors.white, size: 20),
              SizedBox(width: 6),
              Text(
                "Exit",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
