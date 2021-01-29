

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/model/home_article_bean.dart';
import 'package:wan_android/view/home_list_page.dart';
import 'package:wan_android/view/webview_page.dart';
import 'package:wan_android/widget/slide_container.dart';

class PersonArticlePage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return PersonArticleState();
  }
}

class PersonArticleState extends State<PersonArticlePage> {

  var curPage = 0;
  List<HomeArticle> datas = [];

  @override
  void initState() {
    super.initState();
    getListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
        centerTitle: true,
      ),
      body: ListView.builder(itemBuilder: (context,index) {
        return buildItemWidget(datas[index]);
      },itemCount: datas.length,),
    );
  }

  void getListData() async {
    final bean = await ApiManager.instance.collectList(curPage);
    if (bean.isSuccess()) {
      setState(() {
        datas.clear();
        datas.addAll(bean.data.datas);
      });
    } else {
      Fluttertoast.showToast(msg: bean.errorMsg,fontSize: 16,gravity: ToastGravity.CENTER);
    }
  }

  void delete(HomeArticle article) async {
    final bean = await ApiManager.instance.unCollect(article.id, article.originId);
    if (bean.isSuccess()) {
      setState(() {
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
              Row(
                children: [
                  Icon(
                    Icons.child_care,
                    color: Colors.blue,
                    size: 18,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(
                    article.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Expanded(child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      article.chapterName,
                      maxLines: 1,
                    ),
                  ))

                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
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
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            article.niceDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey),
                          ))),
                ],
              )
            ],
          ),
      ),
    );
  }
}