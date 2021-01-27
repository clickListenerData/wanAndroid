

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatelessWidget {

  String title;
  String url;
  WebViewPage(this.title,this.url);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: WebviewScaffold(url: url,
        withZoom: false,
        withLocalStorage: true,
        hidden: true,
        withJavascript: true,),
    );
  }

}