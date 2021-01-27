

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          onTap: () {
            Navigator.push(context,new MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Column(
            children: [
              Image.asset("images/ic_launcher_round.png"),
              Padding(padding: EdgeInsets.only(top: 14)),
              Text(" WAN ANDROID ",style: TextStyle(fontSize: 14,color: Colors.white),),
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


}