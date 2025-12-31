import 'package:flutter/material.dart';

class SettingsUIButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const SettingsUIButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        8.0,
        0.0,
        8.0,
        15.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 3.0),
            child: Row(
              children: [
                Icon(icon,
                  size: 30.0,
                ),
                const SizedBox(
                  width: 12.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Expanded(
                  child: SizedBox()
                ),
                const Icon(
                  Icons.arrow_right,
                  size: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}