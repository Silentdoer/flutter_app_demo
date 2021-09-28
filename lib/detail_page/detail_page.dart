import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 注意，转到这个页面后，Home页面创建的overlayEntry由于本质上是属于最外层窗体的，因此不会消失还是会浮动在detail里，
/// 要消失需要跳转的时候主动关闭掉；
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
        color: Colors.green,
        child: UnconstrainedBox(
          child: Container(
            height: 100,
            width: 100,
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('detial back')),
          ),
        ),
      ),
    );
  }
}
