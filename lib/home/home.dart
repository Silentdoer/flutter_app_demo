import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_demo/floating_button/fixed_like_component.dart';
import 'package:flutter_app_demo/floating_button/popup_floating_button.dart';
import 'package:flutter_app_demo/navbar/navbar_factory.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:resize/resize.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int _bottomIdx = 0;

  int _currentSwiperItemIdx = 2;

  List<int> _swiperItems = [1, 2, 3, 4, 5];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    print('执行了onRefresh');
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print('执行了onLoading');
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  /// container 类似div【有比较多的属性可以设置，但是也是基于组合，即它内部其实有很多个组件】
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: NavbarFactory.textTitleBar("首页"),
      body: SmartRefresher(
          // 是否生效下拉，上拉
          enablePullDown: true,
          enablePullUp: true,
          // 顶部下拉时的显示UI
          header: WaterDropHeader(),
          // 顶部上拉时执行；
          onLoading: _onLoading,
          // 顶部下拉时执行
          onRefresh: _onRefresh,
          // 底部上拉时的显示
          footer: CustomFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            height: 6.vh,
            builder: (BuildContext context, LoadStatus? mode) {
              return SizedBox.shrink();
              /* Widget body;
            if (mode == LoadStatus.idle) {
              //如果不需要可以返回一个看不到的元素：Offstage【用SizedBox.shrink()比较好，一个没有大小的组件】
              //body = Text("向上拉可刷新数据");
              // 没用，生效了上拉，这个组件会自动为它留一个位置
              //body = SizedBox.shrink();
              return Offstage(
                offstage: false,
              );
            } else if (mode == LoadStatus.loading) {
              // 转圈圈
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              // 应该是指当前的list的数据比count要少的时候？
              body = Text("释放上拉操作开始获取数据");
            } else {
              body = Text("No more Data");
            }
            return Container(
              //height: 10.vh,
              child: Center(child: body),
            ); */
            },
          ),
          controller: _refreshController,
          // FLAG 这个ListView是布局而不是数据展示，即它可以认为是Column，如果ListView内部还需要ListView，则要求子ListView
          // 有具体的高度【而且貌似子ListView不能触发刷新】【但是ListView自带Scroll，因此最后一个content 的元素可以设置大小大一点
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: 12.vh,
                      width: 90.vw,
                      child: CarouselSlider(
                        options: CarouselOptions(

                            /// .h是高度相对父元素百分之百，.w是宽度相对父元素百分之百
                            height: 100.h,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            initialPage: _currentSwiperItemIdx,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentSwiperItemIdx = index;
                              });
                            }),
                        items: _swiperItems.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration:
                                      BoxDecoration(color: Colors.amber),
                                  child: Text(
                                    'text $i',
                                    style: TextStyle(fontSize: 1.rem),
                                  ));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      bottom: 1.vh,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _swiperItems.map((item) {
                          return GestureDetector(
                            child: Container(
                              width: max(1.vh, 1.vw),
                              height: max(1.vh, 1.vw),
                              margin: EdgeInsets.symmetric(
                                  horizontal: max(0.5.vh, 0.5.vw)),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(
                                          _swiperItems[_currentSwiperItemIdx] ==
                                                  item
                                              ? 0.9
                                              : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 20.vh,
                  width: 100.vw,
                  color: Colors.blue,
                ),
                
                FixedLikeComponent(Container(
                  height: 20.vh,
                  width: 20.vh,
                  color: Colors.pink,
                ), Offset(5.vw, 22.vh)),
                //Offstage(),
                //SizedBox.shrink(),
                //Visibility(child: Text('kkk'), visible: false,),
                //Opacity(opacity: 0.2, child: Text('kkk'),),
                Container(
                  height: 100.vh,
                  color: Colors.red,
                  // TODO 这个ListView的下拉不会导致刷新【似乎是Scroll事件没有冒泡？】
                  /* child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('KKK $index'),
                    );
                  },
                  itemCount: 30,
                ), */
                )
              ],
            ),
          ) /*  ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return ;
              /* return Column(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                children: [
                  
                  SizedBox(
                    height: 12.vh,
                    width: 90.vw,
                    child: CarouselSlider(
                      options: CarouselOptions(

                          /// .h是高度相对父元素百分之百，.w是宽度相对父元素百分之百
                          height: 100.h,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          initialPage: _currentSwiperItemIdx,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentSwiperItemIdx = index;
                            });
                          }),
                      items: _swiperItems.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.amber),
                                child: Text(
                                  'text $i',
                                  style: TextStyle(fontSize: 16.0),
                                ));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  // Stack的大小和它最大的元素有关
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(width: 3, height: 3,color: Colors.deepOrange),
                      // fuck, 这个无法超出Stack的元素显示范围（所以不要设置负值），所以没法真正实现css的fixed
                      Positioned(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _swiperItems.map((item) {
                      return GestureDetector(
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _swiperItems[_currentSwiperItemIdx] ==
                                              item
                                          ? 0.9
                                          : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),)
                    ],
                  ),
                ],
              ); */
            } else if (index == 1) {
              return Container(
                height: 20.vh,
                width: 100.vw,
                color: Colors.blue,
              );
            } else {
              /* return ListTile(
                title: Text('Silentdoer $index'),
              ); */
              return Container(
                height: 100.vh,
                color: Colors.red,
                // TODO 这个ListView的下拉不会导致刷新【似乎是Scroll事件没有冒泡？】
                /* child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('KKK $index'),
                    );
                  },
                  itemCount: 30,
                ), */
              );
            }
          },

          /// 似乎是item的高度？如果没有指定则按item实际高度来排列
          //itemExtent: 200,
          // 元素个数，这里将ListView当成布局，因此元素个数是行布局个数【多少行】
          itemCount: 3,
        ), */
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple,
        items: [
          BottomNavigationBarItem(label: 'A', icon: Icon(Icons.ac_unit)),
          BottomNavigationBarItem(
              label: 'B', icon: Icon(Icons.access_time_filled)),
          BottomNavigationBarItem(
              label: 'C', icon: Icon(Icons.accessibility_new_sharp))
        ],
        currentIndex: _bottomIdx,
        onTap: (idx) {
          setState(() {
            _bottomIdx = idx;
          });
        },
      ),
      floatingActionButton: PopupFloatingButton(
        _incrementCounter,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
