import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_demo/config/routes.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _countdown = 5;
  late Timer _countdownTimer;

  // 初始化状态
  @override
  void initState() {
    super.initState();
    // 两个参数 垂直动态演示  和显示的秒数
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: _countdown));

    _animation = Tween(begin: 0.2, end: 1.0).animate(_animationController);

    /*动画事件监听器，
    它可以监听到动画的执行状态，
    这里只监听动画是否结束，
    如果结束则执行页面跳转动作。 */
    _animation.addStatusListener((status) {
      // 判断动画是否结束，现在改为由时间控制
      /* if (status == AnimationStatus.completed) {
        /*
        在App里，有一个普遍存在的场景，即打开一个App之后，会出现App的启动页，然后进入欢迎页面
        ，最后才是首页。在这种情况下，用户选择返回，是应该从首页退出App的，而不是再次倒退到欢迎页和启动页。
        这个时候，pushNamedAndRemoveUntil方法就派上用场了
        */
        Navigator.of(context).pushAndRemoveUntil(
            // 动画结束跳转到首页，false可以确保动画结束后清除所有的路由栈跳到首页【是remove而非pop】
            MaterialPageRoute(builder: routeMap['/home']!),
            (route) => route == false);
      } */
    });
    // 进入页面播放动画
    _animationController.forward();
    Future.delayed(Duration(milliseconds: 500), _startRecordTime);
  }

  // 销毁控制器
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startRecordTime() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown < 1) {
          /*
          在App里，有一个普遍存在的场景，即打开一个App之后，会出现App的启动页，然后进入欢迎页面
          ，最后才是首页。在这种情况下，用户选择返回，是应该从首页退出App的，而不是再次倒退到欢迎页和启动页。
          这个时候，pushNamedAndRemoveUntil方法就派上用场了
          */
          Navigator.of(context).pushAndRemoveUntil(
              // 动画结束跳转到首页，false可以确保动画结束后清除所有的路由栈跳到首页【是remove而非pop】
              MaterialPageRoute(builder: RouterTable.routeMap['/home']!),
              (route) => route == false);
          _countdownTimer.cancel();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // 动画透明的控件
        FadeTransition(
          opacity: _animation,
          // 随便找的一张网络图片
          child: Image.network(
            'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg95.699pic.com%2Fphoto%2F40106%2F0954.gif_wh300.gif%21%2Fgifto%2Ftrue&refer=http%3A%2F%2Fimg95.699pic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1636376239&t=2a5e8349e4fd798601331ee2fff65c5c',
            scale: 2.0,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 30,
          right: 30,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12,
            ),
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: '$_countdown',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    )),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        /*
                        在App里，有一个普遍存在的场景，即打开一个App之后，会出现App的启动页，然后进入欢迎页面
                        ，最后才是首页。在这种情况下，用户选择返回，是应该从首页退出App的，而不是再次倒退到欢迎页和启动页。
                        这个时候，pushNamedAndRemoveUntil方法就派上用场了
                        */
                        Navigator.of(context).pushAndRemoveUntil(
                            // 动画结束跳转到首页，false可以确保动画结束后清除所有的路由栈跳到首页【是remove而非pop】
                            MaterialPageRoute(builder: RouterTable.routeMap['/home']!),
                            (route) => route == false);
                        _countdownTimer.cancel();
                      },
                    text: '跳过',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    )),
              ]),
            ),
          ),
        )
      ],
    );
  }
}
