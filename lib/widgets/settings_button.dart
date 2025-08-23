import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const UIButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      width: MediaQuery.of(context).size.height * 0.515,
      margin: const EdgeInsets.fromLTRB(
        8.0,
        0.0,
        8.0,
        15.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.grey),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(
                  width: 12.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
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