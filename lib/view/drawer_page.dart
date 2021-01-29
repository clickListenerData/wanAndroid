

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android/const/sp_const_key.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/model/login_bean.dart';
import 'package:wan_android/view/person/login_register_page.dart';

class _MenuInfo {
  final String title;
  final IconData icon;

  _MenuInfo({this.title, this.icon});
}

final List<_MenuInfo> menus = [  // TODO 积分 收藏 广场 设置 退出登录
  _MenuInfo(title: '个人积分', icon: Icons.account_balance_wallet),
  _MenuInfo(title: 'TODO', icon: Icons.today_outlined),
  _MenuInfo(title: '我的收藏', icon: Icons.collections),
  _MenuInfo(title: '我的分享', icon: Icons.folder_shared_rounded),
  _MenuInfo(title: '设置', icon: Icons.settings),
  _MenuInfo(title: '退出登录', icon: Icons.logout),
];

class PersonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PersonPageState();
  }
}

class PersonPageState extends State<PersonPage> {

  String userName = " WAN ANDROID ";
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    initUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,Colors.cyanAccent,Colors.green
                ],begin: Alignment.topLeft,end: Alignment.bottomRight,
              ),
          ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 80,top: 60),
        child: GestureDetector(
          onTap: routeLogin,
          child: Column(
            children: [
              Image.asset("images/ic_launcher_round.png"),
              Padding(padding: EdgeInsets.only(top: 14)),
              Text(userName,style: TextStyle(fontSize: 14,color: Colors.black),),
            ],
          ),
        ),
      ), preferredSize: Size(MediaQuery.of(context).size.width, 200)),
      body: ListView.builder(itemBuilder: (context,index) {
        if (index == 0) {
          return SizedBox(height: 40,);
        }
        return InkWell(
          onTap: () {
            listItemClick(index - 1);
          },
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top:14)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Icon(menus[index - 1].icon,size: 20,color: Colors.grey,),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Text(menus[index - 1].title,style: TextStyle(color: Colors.black87,fontSize: 20),)
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 14)),
              Container(color: Colors.grey,height: 1,margin: EdgeInsets.only(left: 20),)
            ],
          ),
        );
      },itemCount: menus.length + 1,),
    );
  }

  void routeLogin() async {
    final result = await Navigator.push(context,new MaterialPageRoute(builder: (context) => LoginPage()));
    if (result is LoginBean) {
      setState(() {
        isLogin = true;
        userName = result.nickname;
      });
    }
  }

  void listItemClick(int index) {
    if (!isLogin && index != menus.length - 2) {
      Fluttertoast.showToast(msg: "请先登录",fontSize: 16,gravity: ToastGravity.CENTER);
      return;
    }
    if (index == menus.length - 1) {
      showLogoutConfirm();
      return;
    }
    if(index == 2) Navigator.pushNamed(context, "/person/article");
    if(index == 3) Navigator.pushNamed(context, "/person/share");
    if (index == 0) Navigator.pushNamed(context, "/person/coin");

  }

  void showLogoutConfirm() async {
    await showDialog(context: context,builder: (context) => AlertDialog(
      title: Text("退出登录"),
      content: Text("确认退出登录吗？"),
      actions: [
        RaisedButton(onPressed: () {
          Navigator.of(context).pop();
        },child: Text("取消",style: TextStyle(color: Colors.grey),),),
        RaisedButton(onPressed: () {
          ApiManager.instance.logout().then((value) {
            Navigator.of(context).pop();
            if (value.isSuccess()) {
              setState(() {
                isLogin = false;
                userName = " WAN ANDROID ";
              });
            } else {
              Fluttertoast.showToast(msg: value.errorMsg,fontSize: 16,gravity: ToastGravity.CENTER);
            }
          });
        },child: Text("确认",style: TextStyle(color: Colors.blue),),)
      ],
    ));
  }

  void initUserName() async {
    final sp = await SharedPreferences.getInstance();
    final name = sp.getString(SpConst.NICK_NAME);
    final login = sp.getBool(SpConst.IS_LOGIN);
    if (name.isNotEmpty) {
      setState(() {
        userName = name;
        isLogin = login;
      });
    }
  }


}