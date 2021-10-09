import 'package:flutter/material.dart';
import 'package:flutter_app_demo/animation/splash.dart';
import 'package:flutter_app_demo/detail_page/detail_page.dart';
import 'package:flutter_app_demo/home/home.dart';
import 'package:flutter_app_demo/need_auth_page/need_auth_page.dart';

var routeMap = <String, WidgetBuilder>{
  '/home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
  '/detail': (context) => DetailPage(),
  '/needAuth': (context) => NeedAuthPage(),
  '/': (context) => SplashScreen(),
};