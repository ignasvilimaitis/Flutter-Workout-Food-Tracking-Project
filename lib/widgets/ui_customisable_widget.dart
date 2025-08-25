import 'package:flutter/material.dart';

class UiCustomisableWidget extends StatelessWidget {
  const UiCustomisableWidget({
    super.key,
    required this.height,
    this.width,
    this.circularBorderRadius, this.text,
    });
  final double height;
  final double? width;
  final double? circularBorderRadius;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(
          8.0,
          24.0,
          8.0,
          15.0
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((circularBorderRadius ?? 16.0)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row( // Top Row
              children: [
                Padding(
                  padding: EdgeInsets.all(0)),
                Text(text ?? 'test'),
              ],
            )

          ],
        ),
      );
  }
}