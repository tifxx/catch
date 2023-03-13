import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  var onPressed;
  String label;

  CustomButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.only(left: 40, right: 40),
          ),
        ),
      ),
    );
  }
}
