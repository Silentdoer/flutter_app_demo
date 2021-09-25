import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
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
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
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
                  Row(
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
                  ),
                ],
              );
            } else if (index == 1) {
              return Container(
                height: 20.vh,
                width: 100.vw,
                color: Colors.blue,
              );
            } else {
              return ListTile(
                title: Text('老孟$index'),
              );
            }
          },

          /// 似乎是item的高度？如果没有指定则按item实际高度来排列
          //itemExtent: 200,
          itemCount: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(label: 'A', icon: Icon(Icons.ac_unit)),
          BottomNavigationBarItem(
              label: 'B', icon: Icon(Icons.access_time_filled)),
          BottomNavigationBarItem(
              label: 'C', icon: Icon(Icons.accessibility_new_sharp))
        ],
        currentIndex: _bottomIdx,
        onTap: (idx) {
          _bottomIdx = idx;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
