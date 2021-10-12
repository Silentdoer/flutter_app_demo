import 'package:flutter/material.dart';
import 'package:flutter_app_demo/animation/splash.dart';
import 'package:flutter_app_demo/detail_page/detail_page.dart';
import 'package:flutter_app_demo/home/home.dart';
import 'package:flutter_app_demo/listview_page.dart';
import 'package:flutter_app_demo/need_auth_page/need_auth_page.dart';
import 'package:flutter_app_demo/page404.dart';

class RouterTable {
  static var routeMap = <String, WidgetBuilder>{
    '/listview': (context) => ListViewPage(),
    '/home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
    '/detail': (context) => DetailPage(),
    // 这种写法其实也不怎么样，至少对于web不怎么样，不能直白的看出页面对应的路由前缀是什么
    NeedAuthPage.route: (context) => NeedAuthPage(),
    // 可以在启动页里从后端加载一些配置，比如用户权限相关【在首页能看到哪些页面的跳转按钮（参考web的侧边栏），当然也可以在登录页获取】
    '/': (context) => SplashScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 主页面/加载也会触发
    // pop(..)的不会触发
    print('back 触发吗？${settings.name}, ${settings.arguments}');
    if (settings.name == '/detail') {
      // login
      // 这里不会二次触发onGenerateRoute
      return MaterialPageRoute(
          builder: routeMap['/needAuth']!, settings: settings);
    } else if (routeMap[settings.name] != null) {
      return MaterialPageRoute(
          builder: routeMap[settings.name]!, settings: settings);
    }
    // TODO 注意，这里是可以返回null的，当是null的时候就会去触发onUnknownRoute了，不过也说明onUnknownRoute其实是没用的
    // 因为完全可以在这里处理404页面
    return null;
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => Page404());
  }
}
