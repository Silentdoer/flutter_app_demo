import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaled_size/scaled_size.dart';

class NavbarFactory {
  NavbarFactory._();

  static PreferredSizeWidget searchNavbar(String placeholder,
      {TextAlign textAlign = TextAlign.center,
      TextAlignVertical textAlignVertical = TextAlignVertical.center,
      List<Widget>? actions}) {
    return AppBar(
      centerTitle: true,
      title: SizedBox(
          width: 80.vw,
          child: CupertinoTextField(
            
            placeholder: placeholder,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            // 光标在非iOS平台垂直对齐文字【光标垂直居中在web上有问题，但是在windows上可以，所以也可以理解为是flutter的锅】
            // height高度是值乘以fontSize
            style: const TextStyle(height: 1.2, textBaseline: TextBaseline.ideographic),
          )),
      actions: actions,
    );
  }

  static PreferredSizeWidget textTitleBar(String title, {TextStyle style = const TextStyle(fontWeight: FontWeight.bold)}) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: style,),
      toolbarHeight: 8.vh,
    );
  }
}
