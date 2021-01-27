

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/model/answer_list_bean.dart';
import 'package:wan_android/model/project_tab.dart';
import 'package:wan_android/model/response_bean.dart';
import 'package:wan_android/view/project_list_page.dart';

class ProjectPage extends StatefulWidget {

  int type;
  AnswerList answerList;
  ProjectPage(this.type,{this.answerList});

  @override
  State<StatefulWidget> createState() {
    return ProjectPageState(type);
  }
}

class ProjectPageState extends State<ProjectPage> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {

  List<ProjectTab> tabs = [];
  List<AnswerList> newTabs = [];
  TabController tabController;

  int type;
  ProjectPageState(this.type);

  @override
  void initState() {
    super.initState();
    if (type == 3) {
      createAnswerListData();
    } else {
      getProjectTabData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tabs.length == 0 && newTabs.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        TabBar(
            indicator: createIndicator(),
            indicatorColor: Colors.blue,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.black45,
            controller: tabController,
            isScrollable: true,
            tabs: createTabs()),
        Expanded(
            flex: 1,
            child: TabBarView(
              controller: tabController,
                children: createList(),
            ))
      ],
    );
  }

  Decoration createIndicator() {
    if (type == 1) return null;
    return BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    );
  }

  void getProjectTabData() async {
    BaseResponse<List<ProjectTab>> bean;
    if (type == 0) {
      bean = await ApiManager.instance.getProjectTab();
    } else {
      bean = await ApiManager.instance.getWeChatTab();
    }
    setState(() {
      tabs.clear();
      tabs.addAll(bean.data);
      if (tabController == null) tabController = TabController(length: tabs.length, vsync: this);
    });
  }

  void createAnswerListData() {
    print("answer :: ${widget.answerList == null}");
    setState(() {
      newTabs.clear();
      newTabs.addAll(widget.answerList.children);
      print("answer size :: ${newTabs.length}");
      if (tabController == null) tabController = TabController(length: newTabs.length, vsync: this);
    });
  }

  List<Widget> createTabs() {
    final lists = <Widget>[];
    if (type == 3) {
      newTabs.forEach((element) {
        lists.add(Tab(text: element.name,));
      });
    } else {
      tabs.forEach((element) {
        lists.add(Tab(text: element.name,));
      });
    }
    return lists;
  }

  List<Widget> createList() {
    final lists = <Widget>[];
    if (type == 3) {
      newTabs.forEach((element) {
        lists.add(ProjectListPage(element.id,type));
      });
    } else {
      tabs.forEach((element) {
        lists.add(ProjectListPage(element.id,type));
      });
    }
    return lists;
  }

  @override
  bool get wantKeepAlive => false;
}