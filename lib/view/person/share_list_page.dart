

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/model/home_article_bean.dart';
import 'package:wan_android/view/home_list_page.dart';
import 'package:wan_android/view/webview_page.dart';
import 'package:wan_android/widget/slide_container.dart';

class ShareListPage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return ShareListState();
  }
}

class ShareListState extends State<ShareListPage> {

  var curPage = 1;
  List<HomeArticle> datas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的分享"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(itemBuilder: (context,index) {
            return buildItemWidget(datas[index]);
          },itemCount: datas.length,),
          showLoading(),
        ],
      ),
    );
  }

  Widget showLoading() {
    if (!isLoading) return Container();
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  void getListData() async {
    final bean = await ApiManager.instance.shareList(curPage);
    if (bean.isSuccess()) {
      setState(() {
        isLoading = false;
        datas.clear();
        datas.addAll(bean.data.shareArticles.datas);
      });
    } else {
      Fluttertoast.showToast(msg: bean.errorMsg,fontSize: 16,gravity: ToastGravity.CENTER);
    }
  }

  void delete(HomeArticle article) async {
    setState(() {
      isLoading = true;
    });
    final bean = await ApiManager.instance.deleteShare(article.id);
    if (bean.isSuccess()) {
      setState(() {
        isLoading = false;
        datas.remove(article);
      });
    }
  }

  Widget buildItemWidget(HomeArticle article) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Slidable(child: getBodyContent(article), actionPane: SlidableDrawerActionPane(),actionExtentRatio: 0.25,secondaryActions: [
        IconSlideAction(
          caption: "删除",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () { delete(article); },
        )
      ],),
    );
  }

  Widget getBodyContent(HomeArticle article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => WebViewPage(article.title, article.link) ));
      },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(child: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black,fontSize: 16),
                    ))
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.blue,
                    size: 15,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(
                    article.niceDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                 Padding(padding: EdgeInsets.only(left: 10)),
                 getAudit(article.audit),
                  Expanded(child: Text("")),
                ],
              )
            ],
          ),
      ),
    );
  }
  
  Widget getAudit(int audit) {
    String auditTxt = "已审核";
    if (audit == 0) {
      auditTxt = "未审核";
    }
    return Container(
      padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(color: Colors.grey,width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(auditTxt,style: TextStyle(color: Colors.white,fontSize: 10),),
    );
  }
}