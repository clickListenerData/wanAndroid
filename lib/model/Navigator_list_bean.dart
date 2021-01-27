

import 'package:wan_android/model/home_article_bean.dart';

class NaviListBean {
  List<HomeArticle> articles;
  int cid;
  String name;

  NaviListBean(this.cid,this.name);

  NaviListBean.fromJson(Map<String,dynamic> json) {
    this.cid = json['cid'];
    this.name = json['name'];
    final data = json['articles'];
    if (data is List) {
      this.articles = [];
      data.forEach((element) {
        articles.add(HomeArticle.fromJson(element));
      });
    }
  }
}