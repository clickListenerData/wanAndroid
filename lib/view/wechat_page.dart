

import 'package:flutter/cupertino.dart';

class WeChatPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return WeChatPageState();
  }
}

class WeChatPageState extends State<WeChatPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("we chat page"),
    );
  }

  @override
  bool get wantKeepAlive => true;
}