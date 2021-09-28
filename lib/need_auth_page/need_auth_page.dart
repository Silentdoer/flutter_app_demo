import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeedAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Opacity(
          opacity: 0.8,
          child: Container(
            color: Colors.blueAccent,
            child: UnconstrainedBox(
              child: Container(
                height: 100,
                width: 100,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('auth back')),
              ),
            ),
          ),
        ));
  }
}
