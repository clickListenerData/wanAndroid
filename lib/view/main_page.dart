

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android/view/answer_list_page.dart';
import 'package:wan_android/view/drawer_page.dart';
import 'package:wan_android/view/home_page.dart';
import 'package:wan_android/view/navigator_page.dart';
import 'package:wan_android/view/person/person_article_page.dart';
import 'package:wan_android/view/person/person_coin_page.dart';
import 'package:wan_android/view/person/share_list_page.dart';
import 'package:wan_android/view/project_list_page.dart';
import 'package:wan_android/view/project_page.dart';
import 'package:wan_android/view/search_page.dart';
import 'package:wan_android/view/wechat_page.dart';
import 'package:wan_android/widget/slide_container.dart';

class MainLessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/" : (context) => MainPage(),
        "/person/article": (context) => PersonArticlePage(),
        "/person/share": (context) => ShareListPage(),
        "/person/coin": (context) => PersonCoinPage(),


      },
    );
  }
}

class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {

  var currentIndex = 0;
  PageController pageCtr;

  final titles = ["首页","项目","体系","公众号","问答"];

  final GlobalKey<ContainerState> _slideKey = GlobalKey<ContainerState>();

  double get maxSlideDistance => MediaQuery.of(context).size.width * 0.7;

  bool centerTitle = true;

  double get maxHeight => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    pageCtr = PageController(initialPage: 0,keepPage: true);
  }

  @override
  void dispose() {
    super.dispose();
    pageCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return getBody();
  }

  void onTap(int index,bool isPage) {
    setState(() {
      currentIndex = index;
      if(!isPage) pageCtr.jumpToPage(currentIndex);
    });
  }

  Widget getBody() {
    return SlideStack(
        SlideContainer(
      getBodyContainer(),
      key: _slideKey,
      drawerSize: maxSlideDistance,
      onSlide: (value) {
        _slideKey.currentState.setContainerHeight((maxHeight * (1 - value / 5)));
        _slideKey.currentState.heightOffset = maxHeight * value / 10;
      },
      // transform: Matrix4.translationValues(0.0,height * position / 10, 0.0),
    ), PersonPage());
  }

  Widget getBodyContainer() {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Image.asset("images/ic_launcher_round.png"),
          onTap: () {
            _slideKey.currentState.openOrClose();
          },
        ),
        title: Text(titles[currentIndex]),
        centerTitle: centerTitle,
        backgroundColor: Colors.blue,
        shadowColor: Colors.grey,
        elevation: 10,
      ),
      body: PageView(
        controller: pageCtr,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) => onTap(index, true),
        children: [
          HomePage(),
          ProjectPage(0),
          AnswerListPage(),
          ProjectPage(1),
          ProjectListPage(0, 2),
        ],
      ),
      endDrawer: NavigatorPage(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 100,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
        onTap: (index) => onTap(index, false),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: titles[0]),
          BottomNavigationBarItem(icon: Icon(Icons.map),label: titles[1]),
          BottomNavigationBarItem(icon: Icon(Icons.request_quote),label: titles[2]),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail),label: titles[3]),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer),label: titles[4]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => SearchPage() ));
        },
        tooltip: 'search',
        child: Icon(Icons.search),
      ),
    );
  }

}