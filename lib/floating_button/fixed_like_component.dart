import 'package:flutter/material.dart';

/// 不要用于ListView item元素等【主要是因为item之间可能有分隔线，那么即便某个item不占空间也会因为存在item而产生分隔线】，
/// 还有就是不要用于那种一定有面积的元素的子元素，否则虽然这个元素没有面积，但是其父元素仍然会占用面积（这个就看具体情况了）
/// 不过由于其全局性，所以最好至少是放到body的子层以上，否则就和css一样乱了难找代码；
class FixedLikeComponent extends StatefulWidget {
  final Widget child;

  final Offset topLeft;

  FixedLikeComponent(this.child, this.topLeft);

  @override
  State<StatefulWidget> createState() {
    return _FixedLikeComponentState(this.child, this.topLeft);
  }
}

class _FixedLikeComponentState extends State<FixedLikeComponent> {
  Widget child;

  Offset topLeft;

  OverlayEntry? _overlayEntry;

  bool created = false;

  _FixedLikeComponentState(this.child, this.topLeft);

  OverlayEntry _createOverlayEntry() {
    // TODO 可以试着用SizedBox.shrink()+Overlay来接近实现一个fixed【之所以是接近是因为还是需要有个组件作为跳板，只不过这个组件可以是大小为0,
    // 但是即便大小是0，对于一些组件，比如ListView的item而言它也占“位置”，比如会有两条分隔线；
    return OverlayEntry(
        builder: (context) => Positioned(
            left: topLeft.dx,
            top: topLeft.dy,
            // 弹窗的width，child的with【即一个是弹窗容器的width，一个是弹窗容器子容器的width】
            // 这里不设置由子容器来决定弹窗大小
            //width: size.width,
            child: Material(elevation: 4.0, child: child)));
  }

  @override
  Widget build(BuildContext context) {
    /// 不能这么写，overlayEntry这个元素必须是在当前widgetbuild之后才能显示【用delay试下】
    /// 用delay是可以的，这里只delay了1微秒（比毫秒小，毫秒用户都无感知【还是用毫秒好，防止不精确问题】），对于用户而言是完全无感知的，所以这种方式可行；
    /// 但是注意，如果直接这么写，而不remove会导致reload会越来越多个浮动控件；
    /* Future.delayed(Duration(milliseconds: 1), () {
      // Overlay的原理是窗口外层本来就有一个Stack，而且它的children里有
      // 一个Overlay对象，因此这里将overlayEntry插入到overlay里就相当于
      // 往最外层的Stack里添加了子孙元素；
      if (!created) {
        created = true;
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context)!.insert(this._overlayEntry!);
      }
    }); */
    // 应该是指这个元素显示之后的回调？
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!created) {
        created = true;
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context)!.insert(this._overlayEntry!);
      }
    });
    return Offstage();

    /* return TextButton(onPressed: () {
       this._overlayEntry = this._createOverlayEntry();
          Overlay.of(context)!.insert(this._overlayEntry!);
    }, child: child); */
  }
}
