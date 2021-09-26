import 'package:flutter/material.dart';

class PopupFloatingButton extends StatefulWidget {
  final VoidCallback? onPressed;

  PopupFloatingButton(this.onPressed);

  @override
  State<StatefulWidget> createState() {
    return _PopupFloatingButtonState(this.onPressed);
  }
}

class _PopupFloatingButtonState extends State<PopupFloatingButton> {
  VoidCallback? onPressed;

  bool _pressed = false;

  OverlayEntry? _overlayEntry;

  double popupHeight = 30;

  _PopupFloatingButtonState(this.onPressed);

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    // 获取当前元素【这里是FloatingButton】的坐标和大小方便在哪里绘制弹窗；
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy - popupHeight - 5,
              // 弹窗的width，child的with【即一个是弹窗容器的width，一个是弹窗容器子容器的width】
              // 这里不设置由子容器来决定弹窗大小
              //width: size.width,
              child: Material(
                  elevation: 4.0,
                  child: Container(
                    height: popupHeight,
                    width: size.width,
                    color: Colors.yellowAccent,
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _pressed = !_pressed;
        if (_pressed) {
          this._overlayEntry = this._createOverlayEntry();
          Overlay.of(context)!.insert(this._overlayEntry!);
        } else {
          this._overlayEntry!.remove();
        }
        // 额外的动作【但实际上很少这种】
        this.onPressed!();
      },
      tooltip: 'show popup',
      child: const Icon(Icons.add),
    );
  }
}
