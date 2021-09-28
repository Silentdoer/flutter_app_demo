import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_demo/main.dart';

class NeedAuthPage extends StatelessWidget {
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
                height: 100,
                width: 100,
                child: TextButton(
                    onPressed: () {
                      // 第二个参数是返回时的参数result，这个result由await xxx.pushNamed(...);获取
                      //Navigator.pop(context, 88);
                      // 先pop后push也不好，它会跳转回去然后再跳转到之前要访问的页面，这种情况用pushReplacement，即将新页面替换当前页面；
                      // 既直接跳转了新页面，当前页面也从路由history里去掉了；
                      // 由其它页面跳转而来；
                      if (settings.name != '/needAuth' && settings.name != null) {
                        // 这里就直接push页面了，否则还要走一遍路由判断是否已经登录；
                        //Navigator.of(context).pushNamed(settings.name!);
                        //Navigator.of(context).push(MaterialPageRoute(builder: routeMap[settings.name!]!));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: routeMap[settings.name!]!));
                      }
                      // 居然能获取overlay
                      //Navigator.of(context).overlay
                    },
                    child: Text('auth back')),
              ),
            ),
          ),
        ));
  }
}
