import 'package:flutter/material.dart';
import 'package:never_lost/components/color.dart';

class MyMessage extends StatelessWidget {
  final String message;
  const MyMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.indigo),
          child: Text(
            message,
            style: TextStyle(color: textColor2),
          ),
        ),
      ),
    );
  }
}
