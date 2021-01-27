import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android/model/home_article_bean.dart';
import 'package:wan_android/view/webview_page.dart';

class HomeListItem extends StatelessWidget {
  HomeArticle article;

  HomeListItem(this.article);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => WebViewPage(article.title, article.link) ));
      },
      child: Card(
        margin: EdgeInsets.all(10),
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
      ),
    );
  }
}
