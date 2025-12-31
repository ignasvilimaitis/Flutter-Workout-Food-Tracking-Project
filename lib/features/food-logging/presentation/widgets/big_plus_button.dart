import 'package:flutter/material.dart';

class BigBlackPlusButton extends StatelessWidget {
  const BigBlackPlusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(70, 70),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
        ),
        onPressed: () {

        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }
}
