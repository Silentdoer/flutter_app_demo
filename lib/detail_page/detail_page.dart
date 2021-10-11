import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 注意，转到这个页面后，Home页面创建的overlayEntry由于本质上是属于最外层窗体的，因此不会消失还是会浮动在detail里，
/// 要消失需要跳转的时候主动关闭掉；
class DetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

/// 可拖动排序的控件
class _DetailPageState extends State<DetailPage> {
  List<String> items = List.generate(20, (int i) => '$i');
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
        color: Colors.green,
        child: UnconstrainedBox(
            child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('detial back')),
            ),
            SizedBox(
                width: 100,
                height: 500,
                child: ReorderableListView(
                  buildDefaultDragHandles: false,

                  /// 防止拖动时背景白色
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return child;
                  },
                  children: <Widget>[
                    for (int index = 0; index < items.length; index++)
                      Container(
                        key: ValueKey(items[index]),
                        height: 50,
                        child: ReorderableDragStartListener(
                          index: index,
                          // TODO 这里似乎只能是Card。。，Card默认有margin
                          child: Card(
                            color: Colors.primaries[int.parse(items[index]) %
                                Colors.primaries.length],
                          ),
                        ),
                      )
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    var child = items.removeAt(oldIndex);
                    items.insert(newIndex, child);
                    setState(() {});
                  },
                ))
          ],
        )),
      ),
    );
  }
}
