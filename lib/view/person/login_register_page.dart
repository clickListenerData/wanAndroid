
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/view/person/register_page.dart';

class LoginPage extends StatefulWidget {

  final String USER_KEY = "USER_ACCOUNT";

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  TextEditingController userController;
  TextEditingController pwdController;
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userController = TextEditingController();
    pwdController = TextEditingController();

    initUserText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 14,right: 14),
        alignment: Alignment.center,
        child: Form(
          key: formKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 100)),
                TextFormField(
                  controller: userController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),hintText: "请输入用户名",labelText: "用户名",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue),borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red),borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue),borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "用户名不能为空";
                  },
                  onSaved: saveUser,
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
                TextFormField(
                  obscureText: true,
                  controller: pwdController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),hintText: "请输入密码",labelText: "密码",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue),borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red),borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue),borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  validator: (v) {
                    return v.trim().length > 5 ? null : "密码不能少于6位";
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 14)),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    child: Text("登录"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final state = formKey.currentState as FormState;
                      bool validate = state.validate();
                      if(validate) {
                        login(userController.text, pwdController.text);
                      }
                    }),),
                Padding(padding: EdgeInsets.only(top: 14)),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      child: Text("注册"),
                      color: Colors.cyanAccent,
                      textColor: Colors.white,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                      })
                  ,)
              ],
            )
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  void login(String userName,String password) async {
    final response = await ApiManager.instance.login(userName, password);
    // print("login response ::: ${response.data} ,, ${response.headers}");
    final sp = await SharedPreferences.getInstance();
    if (response.isSuccess()) {
      sp.setString("public_name", response.data.publicName);
      sp.setString("nick_name", response.data.nickname);
      sp.setString(widget.USER_KEY, response.data.username);
      sp.setStringList("collects", response.data.collectIds);
      Navigator.of(context).pop();
    } else {

    }
  }

  void initUserText() async {
    final sp = await SharedPreferences.getInstance();
    final user = sp.getString(widget.USER_KEY);
    userController.text = user;
  }

  void saveUser(String user) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(widget.USER_KEY, user);
  }
}