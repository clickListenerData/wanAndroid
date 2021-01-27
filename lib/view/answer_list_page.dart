

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/model/answer_list_bean.dart';
import 'package:wan_android/view/answer_detail_page.dart';
import 'package:wan_android/view/project_list_page.dart';

class AnswerListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnswerPageState();
  }
}

class AnswerPageState extends State<AnswerListPage> with AutomaticKeepAliveClientMixin {


  List<AnswerList> data = [];

  @override
  void initState() {
    super.initState();
    getAnswerListData();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(itemBuilder: (context,index) {
      return createNewTab(data[index]);
    },itemCount: data.length,);
  }


  void getAnswerListData() async {
    final bean = await ApiManager.instance.getAnswerList();
    setState(() {
      data.clear();
      data.addAll(bean.data);
    });
  }

  Widget createNewTab(AnswerList data) {
    return Card(
      margin: EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: InkWell(
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => ArticleListPage(data) ));
        },
        child: Container(
          padding: EdgeInsets.only(top: 10,bottom: 10),
          child: Row(
            children: [
              Expanded(child: Column(
                children: [
                  Text(data.name,style: TextStyle(color: Colors.black,fontSize: 14),),
                  Wrap(
                    children: createSubList(data.children),
                  )
                ],
              )),
              Padding(padding: EdgeInsets.only(top: 10)),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
      ),
    );
  }

  Widget createTab(AnswerList data) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10,top: 10),
            child: Text(
              data.name,
              style: TextStyle(fontSize: 16,color: Colors.black),),
          ),
        ),
        Container(
          child: Wrap(
            children: createSubList(data.children),
          ),
        )
        /*Wrap(
          children: createSubList(data.children),
        )*/
      ],
    );
  }

  List<Widget> createSubList(List<AnswerList> list) {
    final widgets = <Widget>[];
    if (list == null || list.isEmpty) return widgets;
    list.forEach((element) {
      widgets.add(createNewSubTab(element));
    });
    return widgets;
  }

  Widget createNewSubTab(AnswerList data) {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,top: 5),
      child: Text(data.name,style: TextStyle(color: Colors.black45,fontSize: 12),),
    );
  }

  Widget createSubTab(AnswerList data) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, new MaterialPageRoute(builder: (context) => ArticleListPage(data.name, data.id) ));
      },
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10,top: 10),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(width: 1.0,color: Colors.black)
        ),
        child: Text(data.name,style: TextStyle(
            fontSize: 12,color: Colors.white70),),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


}