

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android/model/answer_list_bean.dart';
import 'package:wan_android/view/project_list_page.dart';
import 'package:wan_android/view/project_page.dart';

class ArticleListPage extends StatefulWidget {

  String title;
  int cid;

  AnswerList answerList;

  // ArticleListPage(this.title,this.cid);

  ArticleListPage(this.answerList);

  @override
  State<StatefulWidget> createState() {
    return ArticleListState();
  }
}

class ArticleListState extends State<ArticleListPage> {

  String title;
  int cid;

  // ArticleListState(this.title,this.cid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.answerList.name),
        centerTitle: true,
      ),
      body: ProjectPage(3,answerList: widget.answerList,),
    );
  }
}