import 'package:flutter/material.dart';
import 'package:scaled_size/scaled_size.dart';

/// 点击按钮显示悬浮框
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

  double top = 21.vh;
  double left = 5.vw;

  double overlayWidth = 50;

  _PopupFloatingButtonState(this.onPressed);

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    // 获取当前元素【这里是FloatingButton】的坐标和大小方便在哪里绘制弹窗；
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    // TODO 可以试着用SizedBox.shrink()+Overlay来接近实现一个fixed【之所以是接近是因为还是需要有个组件作为跳板，只不过这个组件可以是大小为0,
    // 但是即便大小是0，对于一些组件，比如ListView的item而言它也占“位置”，比如会有两条分隔线；
    return OverlayEntry(builder: (context) {
      return Positioned(
        /* left: offset.dx,
              top: offset.dy - popupHeight - 5, */
        left: this.left,
        top: this.top,
        // 弹窗的width，child的with【即一个是弹窗容器的width，一个是弹窗容器子容器的width】
        // 这里不设置由子容器来决定弹窗大小
        //width: size.width,
        // Material封装的容器有box-shadow
        child: Draggable(
          //拖动期间组件的显示
          feedback: Material(
              elevation: 4.0,
              // 改成可拖动
              child: Container(
                height: popupHeight,
                width: overlayWidth,
                color: Colors.white60,
              )),
          // 组件停止时的显示
          child: Material(
              elevation: 4.0,
              // 改成可拖动
              child: Container(
                height: popupHeight,
                width: overlayWidth,
                color: Colors.yellowAccent,
              )),
          // 拖动时原先组件所在位置的显示【如果不需要用一个Offstage
          childWhenDragging: Container(
            height: popupHeight,
            width: overlayWidth,
            color: Colors.deepPurple,
          ), //拖动过程回调
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            print('拖动释放后的坐标：${offset}');
            setState(() {
              //第二个参数为拖动的动态坐标
              this.left = offset.dx;
              this.top = offset.dy;
            });
          },
        ),

        /* Material(
                  elevation: 4.0,
                  // 改成可拖动
                  child: Container(
                    height: popupHeight,
                    width: size.width,
                    color: Colors.yellowAccent,
                  )), */
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        print('鼠标放到按钮上就触发了，没有');
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

  @override
  void dispose() {
    _overlayEntry?.remove(); //移除
    _overlayEntry = null;
    super.dispose();
  }
}
