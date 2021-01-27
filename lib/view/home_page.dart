

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wan_android/http/ApiManager.dart';
import 'package:wan_android/model/home_article_bean.dart';
import 'package:wan_android/model/home_banner_bean.dart';
import 'package:wan_android/view/home_list_page.dart';
import 'package:wan_android/view/webview_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  List<HomeBannerBean> banners = [];
  List<HomeArticle> articles = [];

  int curPage = 0;

  SwiperController swiperControl = SwiperController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getHomeData();

    swiperControl.autoplay = true;
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var pixels = scrollController.position.pixels;
      if (maxScroll == pixels) {
        curPage++;
        getHomeArticles(true);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return ListView.builder(itemBuilder: (context,index){
      if (index ==0) return createBannerItem(); else {
        return HomeListItem(articles[index - 1]);
      }
    },itemCount: articles.length + 1,controller: scrollController,);
  }

  void getHomeData() async {
    curPage = 0;
    final data = await ApiManager.instance.getHomeBanner();
    if (data.isSuccess()) {
      setState(() {
        banners.clear();
        banners.addAll(data.data);
      });
    }
    print("banner size::${banners.length} ,, ${data.errorMsg}");
    getHomeArticles(false);
  }

  void getHomeArticles(bool isLoad) async {
    final articles = await ApiManager.instance.getHomeArticle(curPage);
    if (articles.isSuccess()) {
      setState(() {
        if (!isLoad) this.articles.clear();
        this.articles.addAll(articles.data.datas);
      });
    }
  }

  Widget createBannerItem() {
    return Container(
      margin: EdgeInsets.only(left: 5,right: 5,top: 5),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: banners.length != 0 ? Swiper(
        onTap: (index) {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => WebViewPage(banners[index].title, banners[index].url) ));
        },
        autoplayDelay: 3000,
        controller: swiperControl,
        itemWidth: MediaQuery.of(context).size.width,
        itemHeight: 200,
        pagination: pagination(),
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            banners[index].imagePath,
            fit: BoxFit.fill,
          );
        },
        itemCount: banners.length,
        // viewportFraction: 0.8,
        // scale: 0.9,
      )
      : SizedBox(
        width: 0,
        height: 0,
      )
    );
  }

  SwiperPagination pagination() => SwiperPagination(
    margin: EdgeInsets.all(0),
    builder:SwiperCustomPagination(builder: (context,config) {
      return Container(
        color: Colors.black45,
        height: 40,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(banners[config.activeIndex].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0,color: Colors.white),),),
            Align(
              alignment: Alignment.centerRight,
              child: DotSwiperPaginationBuilder(
                  color: Colors.white70,
                  activeColor: Colors.blue,
                  size: 6.0,
                  activeSize: 6.0
              ).build(context, config),
            )

          ],
        ),
      );
    })
  );




  @override
  bool get wantKeepAlive => true;


}