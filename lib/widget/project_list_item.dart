

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android/model/home_article_bean.dart';
import 'package:wan_android/view/home_list_page.dart';
import 'package:wan_android/view/webview_page.dart';

class ProjectListItem extends StatelessWidget {

  HomeArticle article;
  int type;
  ProjectListItem(this.article,this.type);

  @override
  Widget build(BuildContext context) {
    if (type != 0) {  // 无需展示图片
      return HomeListItem(article);
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => WebViewPage(article.title, article.link) ));
      },
      child: Card(
        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
        child: Container(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              FadeInImage.assetNetwork(
                width: 120,
                  height: 240,
                  placeholder: "images/ic_launcher.png", image: article.envelopePic),
              Expanded(
                flex: 1,
                  child: Container(
                padding: EdgeInsets.only(left: 10),
                child: descTextBody(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget descTextBody() {
    return Column(
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
            style: TextStyle(color: Colors.black,fontSize: 15),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            article.desc,
            style: TextStyle(color: Colors.grey,fontSize: 12),
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
    );
  }
}