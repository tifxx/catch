import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

abstract class ButtonFactory {
  Widget createButton(VoidCallback onPressed, String label);
}

class AndroidButtonFactory implements ButtonFactory {
  @override
  Widget createButton(VoidCallback onPressed, String label) {
    return CustomButton(onPressed: onPressed, label: label);
  }
}

class iOSButtonFactory implements ButtonFactory {
  @override
  Widget createButton(VoidCallback onPressed, String label) {
    return CupertinoButton(
      child: Text(label, style: TextStyle(fontSize: 20, color: Colors.white)),
      onPressed: onPressed,
    );
  }
}
