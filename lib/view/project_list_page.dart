

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/model/home_article_bean.dart';
import 'package:wan_android/model/response_bean.dart';
import 'package:wan_android/view/home_list_page.dart';
import 'package:wan_android/widget/project_list_item.dart';

class ProjectListPage extends StatefulWidget {

  int cid;
  int type;
  ProjectListPage(this.cid,this.type);

  @override
  State<StatefulWidget> createState() {
    return ProjectListState(cid,type);
  }
}

class ProjectListState extends State<ProjectListPage> with AutomaticKeepAliveClientMixin {

  int curPage = 0;
  int cid;
  int type;
  ProjectListState(this.cid,this.type);

  List<HomeArticle> datas = [];

  @override
  void initState() {
    super.initState();
    getProjectList(false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context,index) {
      return ProjectListItem(datas[index],type);
    },itemCount: datas.length);
  }

  void getProjectList(bool isLoad) async {
    BaseResponse<HomeArticleBean> bean;
    if (type == 0) {
      bean = await ApiManager.instance.getProjectList(curPage, cid);
    } else if(type == 1) {
      bean = await ApiManager.instance.getWeChatArticle(curPage, cid);
    } else if(type == 2) {
      bean = await ApiManager.instance.getWeDanArticle(curPage);
    } else {
      bean = await ApiManager.instance.getAnswerDetail(curPage, cid);
    }
    if (bean.isSuccess()) {
      setState(() {
        if (!isLoad) datas.clear();
        datas.addAll(bean.data.datas);
        print("project list size::${datas.length},,,$cid");
      });
    }
    print("${bean.errorCode}   ${bean.errorMsg}");
  }

  @override
  bool get wantKeepAlive => true;
}