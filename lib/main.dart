import 'package:flutter/material.dart';
import 'package:flutter_app_demo/config/routes.dart';
import 'package:flutter_app_demo/detail_page/detail_page.dart';
import 'package:flutter_app_demo/need_auth_page/need_auth_page.dart';
import 'package:resize/resize.dart';

import 'home/home.dart';

void main() {
  runApp(const MyApp());
}

late Widget globalWidght;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Resize(builder: () {
      globalWidght = MaterialApp(
        // TODO 这里有点问题，哪怕initialRoute值是其他的如/loading，启动app后也是首先进/这个路由里来；
        initialRoute: '/',
        //routes: routeMap,
        // 有了这个就不能有routes，否则这个拦截无效；
        onGenerateRoute: (RouteSettings settings) {
          // 主页面/加载也会触发
          // pop(..)的不会触发
          print('back 触发吗？${settings.name}, ${settings.arguments}');
          if (settings.name == '/detail') {
            // login
            // 这里不会二次触发onGenerateRoute
            return MaterialPageRoute(
                builder: routeMap['/needAuth']!, settings: settings);
          } else {
            return MaterialPageRoute(
                builder: routeMap[settings.name]!, settings: settings);
          }
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.lightGreen,
        ),
        //有了initialRoute+routes(routes里有initialRoute前提下)后home就不能写了；
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
      return globalWidght;
    });
  }
}
