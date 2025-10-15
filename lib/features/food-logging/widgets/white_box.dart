import 'package:flutter/material.dart';

class WhiteBoxFooter extends StatelessWidget {
  const WhiteBoxFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 28),
                backgroundColor: Theme.of(context).cardColor,
              ),
              onPressed: () {
                // TODO: Navigate to workout screen
              },
              child: Column(
                children: [
                  const Text("Test",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
          ),
        ],
      );
  }
}