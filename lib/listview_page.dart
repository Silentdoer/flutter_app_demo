import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListViewPageState();
  }
}

class _ListViewPageState extends State<ListViewPage> {
  /// initState()不能有async方法
  @override
  void initState() {
    super.initState();

    this.initData();
  }

  /*
  Flutter 的生命周期分为两个部分：

    Widget 的生命周期
    App 的生命周期
  */
  void initData() {
    // addPostFrameCallback 类似是nextTick，所以它的回调是在initState()执行完毕后执行的，所以这个时候页面的组件已经初始化了
    // 不会存在null的情况【frame是帧的意思，也类似tick，或者可以理解为添加了一个异步task
    // addPostFrameCallback是 StatefulWidge 渲染结束的回调,只会被调用一次,之后 StatefulWidget 需要刷新 UI 也不会被调用
    /* Future.microtask(() async {
      this._indicatorKey.currentState!.show();
      List<int> tempList = await _getData();
      tempList.addAll(listData);
      listData = tempList;
      setState(() {});
    }); */
    // 在initState()之后调用这个则instance就一定不是null
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      this._indicatorKey.currentState!.show();
      List<int> tempList = await _getData();
      tempList.addAll(listData);
      listData = tempList;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Divider blueD = Divider(
    color: Colors.blue,
    height: 0,
  );
  Divider yellowD = Divider(
    color: Colors.yellow,
    height: 0,
  );
  SizedBox noneD = SizedBox.shrink();

  /// 虽然itemBuilder默认支持局部展示，但是这个也不能太大了，数据量到了一定层度还是要考虑清理
  var listData = <int>[];

  // TODO 用于手动触发RefreshIndicator刷新
  GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    // Scaffold可以没有header和footer，所以它也是一个容器【不过一般是页面的第一层容器】
    // 不过如果单纯是这样的话，直接用Material即可
    return Material(
        child: RefreshIndicator(
            key: _indicatorKey,
            onRefresh: _onRefresh,
            child: ListView.separated(
              // 上拉有回弹的效果【所以其实大多数情况下不需要用到pull_to_refresh的上拉效果】
              // 好吧，这个和Refreshindicator不和
              //physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) => index % 3 == 0
                  ? blueD
                  : index % 3 == 1
                      ? yellowD
                      : noneD,
              itemBuilder: (context, index) {
                // 不是一次性build出来，而是build视窗范围内的item【隐藏的一部分也会build出来，这里一次性build了45，总共60，
                // 视窗范围内是31的样子，所以通过itemBuilder的方式可以防止一次性展示的内容太多而挂掉】
                print('不是一次性build出来？$index');
                // TODO 下次不用ListTile了，不知道有什么鬼用，用了反而经常报错；
                // TODO 好吧，ListTile要配合容器Scaffold，否则就会报错【不过它也确实没啥用，还是不用了】
                // ListTile还是可以用的，它提供了很多参数可以写出有左侧标题，中间体，右侧icon的item
                return Row(children: [
                  Text(
                    'aaa$index',
                    style: TextStyle(
                        color: Colors.black, decoration: TextDecoration.none),
                  )
                ]);
              },
              itemCount: listData.length,
            )));
  }

  Future<void> _onRefresh() async {
    print('下拉刷新开始');

    // 3秒后加载完毕
    var tempList = await _getData();
    tempList.addAll(listData);
    listData = tempList;
    print('下拉刷新结束');
    setState(() {});
  }

  Future<List<int>> _getData() async {
    return Future.delayed(Duration(seconds: 3), () {
      List<int> tempList = List.generate(10, (i) => i);
      return tempList;
    });
    ;
  }
}
