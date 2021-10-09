import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_demo/main.dart';

class NeedAuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NeedAuthPageState();
  }
}

// 只有一个AnimationController用SingleTickerProviderStateMixin
class _NeedAuthPageState extends State<NeedAuthPage>
    with SingleTickerProviderStateMixin {
  // 点击按钮后将100*100的时间内逐步变成200*200
  late Animation animationSize;

  String buttonText = '点我放大';

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            // value 0 到 1【频率是怎么样？不管duration是多少，都是执行N次，比如都触发100次？还是说按60FPS，即1秒钟60次？】
            // 好像确实是60 FPS
            // forward 是从0到1（可以设置起止边界数值），而reverse则是从1到0
            // 有了Animation后可以不需要手动计算大小了
            //_size = 100 + 100 * _animationController.value;
            // 触发update，上面的代码一般放里面，在上面也行
            setState(() {});
          })
          ..addStatusListener((status) {
            //if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
            if (animationSize.isDismissed) {
              setState(() {
                buttonText = '点我放大';
              });
            } else if (animationSize.isCompleted) {
              setState(() {
                buttonText = '点我缩小';
              });
            }
            //}
            print(
                'animation status:$status, animationSizeStatus:${animationSize.status} ${animationSize.isCompleted} ${animationSize.isDismissed}');
          });

    // 注意是100.0，写成100会导致value的类型变成int?；这里还可以通过chain增加动画的Curve效果
    animationSize =
        Tween(begin: 100.0, end: 200.0).chain(CurveTween(curve: Curves.bounceIn)).animate(_animationController);
  }

  @override
  void dispose() {
    print('dispose');
    // TODO 注意，这个必须是super.dispose()之前执行，否则Animation执行过程中先super.dispose()了会报错
    _animationController.dispose();
    super.dispose();
  }

  /// TODO 每次setState都会触发这个
  @override
  Widget build(BuildContext context) {
    // 比如是由其它页面跳转登录页面（当前页面），可以通过这个，验证通过后再跳转回去；
    var settings = ModalRoute.of(context)!.settings;
    print('auth page ${settings.name}, ${settings.arguments}');

    return ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Opacity(
            opacity: 0.8,
            child: Container(
              color: Colors.blueAccent,
              child: UnconstrainedBox(
                child: Container(
                  height: 400,
                  width: 300,
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            print('kkkk');
                            if (buttonText == '点我放大') {
                              _animationController.forward();
                            } else {
                              _animationController.reverse();
                            }
                          },
                          child: Container(
                            height: animationSize.value,
                            width: animationSize.value,
                            color: Colors.grey,
                            alignment: Alignment.center,
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  decoration: TextDecoration.none),
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            // 第二个参数是返回时的参数result，这个result由await xxx.pushNamed(...);获取
                            //Navigator.pop(context, 88);
                            // 先pop后push也不好，它会跳转回去然后再跳转到之前要访问的页面，这种情况用pushReplacement，即将新页面替换当前页面；
                            // 既直接跳转了新页面，当前页面也从路由history里去掉了；
                            // 由其它页面跳转而来；
                            if (settings.name != '/needAuth' &&
                                settings.name != null) {
                              // 这里就直接push页面了，否则还要走一遍路由判断是否已经登录；
                              //Navigator.of(context).pushNamed(settings.name!);
                              //Navigator.of(context).push(MaterialPageRoute(builder: routeMap[settings.name!]!));
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: routeMap[settings.name!]!));
                            } else {
                              Navigator.of(context).pop();
                            }
                            // 居然能获取overlay
                            //Navigator.of(context).overlay
                          },
                          child: Text('auth back'))
                    ],
                  ),
                ),
              ),
            )));
  }
}
