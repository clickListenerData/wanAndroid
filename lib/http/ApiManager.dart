

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android/const/sp_const_key.dart';
import 'package:wan_android/http/cookie_manager.dart';
import 'package:wan_android/model/Navigator_list_bean.dart';
import 'package:wan_android/model/coin_list_bean.dart';
import 'package:wan_android/model/home_article_bean.dart';
import 'package:wan_android/model/home_banner_bean.dart';
import 'package:wan_android/model/login_bean.dart';
import 'package:wan_android/model/my_share_list.dart';
import 'package:wan_android/model/project_tab.dart';
import 'package:wan_android/model/response_bean.dart';
import 'package:wan_android/model/answer_list_bean.dart';
import 'package:wan_android/model/search_hot_bean.dart';

typedef BaseCall<T> = void Function(BaseResponse<T> bean,Response response);
typedef InitBean<T> = T Function(Map<String,dynamic>);

class ApiManager {
  static ApiManager manager;

  static ApiManager getInstance() {
    if (manager == null) {
      manager = new ApiManager();
    }
    return manager;
  }

  static ApiManager get instance => getInstance();

  Dio dio;

  ApiManager() {
    final options = BaseOptions(
      baseUrl: "https://www.wanandroid.com/",
      connectTimeout: 10000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
    dio.interceptors.add(CustomIntercept());
  }

  Future<BaseResponse<T>> httpResponse<T>(String url,BaseCall<T> call,{Map<String,dynamic> params}) async {
    try {
      Response response = await dio.get(url,queryParameters: params);
      final bean = BaseResponse<T>.fromJson(response.data);
      call(bean,response);
      return bean;
    }catch(e) {
      return BaseResponse(-99,"$e");
    }
  }

  Future<BaseResponse<T>> httpPostResponse<T>(String url,BaseCall<T> call,{Map<String,dynamic> params}) async {
    try {
      Response response = await dio.post(url,queryParameters: params);
      final bean = BaseResponse<T>.fromJson(response.data);
      call(bean,response);
      return bean;
    }catch(e) {
      return BaseResponse(-99,"$e");
    }
  }

  Future<BaseResponse<List<HomeBannerBean>>> getHomeBanner() async {
    return httpResponse("banner/json", parseHomeBanner);
  }

  Future<BaseResponse<HomeArticleBean>> getHomeArticle(int page) async {
    return httpResponse("article/list/$page/json", (bean, response) {
      parseBean(bean, response, (json) => HomeArticleBean.fromJson(json));
    });
  }

  Future<BaseResponse<List<ProjectTab>>> getProjectTab() async {
    return httpResponse("project/tree/json", (bean, response) {
      parseListBean(bean, response, (json) => ProjectTab.fromJson(json));
    });
  }

  Future<BaseResponse<HomeArticleBean>> getProjectList(int page,int cid) async {
    return httpResponse("project/list/$page/json", (bean, response) {
      parseBean(bean, response, (json) => HomeArticleBean.fromJson(json));
    },params: {"cid":"$cid"});
  }

  Future<BaseResponse<List<ProjectTab>>> getWeChatTab() async {
    return httpResponse("wxarticle/chapters/json", (bean, response) {
      parseListBean(bean, response, (json) => ProjectTab.fromJson(json));
    });
  }

  Future<BaseResponse<HomeArticleBean>> getWeChatArticle(int page,int cid) async {
    return httpResponse("wxarticle/list/$cid/$page/json", (bean, response) {
      parseBean(bean, response, (json) => HomeArticleBean.fromJson(json));
    });
  }

  Future<BaseResponse<HomeArticleBean>> getWeDanArticle(int page) async {
    return httpResponse("wenda/list/$page/json", (bean, response) {
      parseBean(bean, response, (json) => HomeArticleBean.fromJson(json));
    });
  }

  Future<BaseResponse<List<AnswerList>>> getAnswerList() async {
    return httpResponse("tree/json",(bean,response) {
      parseListBean(bean,response,(json) => AnswerList.fromJson(json));
    });
  }

  Future<BaseResponse<HomeArticleBean>> getAnswerDetail(int page,int cid) async {
    return httpResponse("article/list/$page/json", (bean, response) {
      parseBean(bean, response, (json) => HomeArticleBean.fromJson(json));
    },params: {"cid":"$cid"});
  }

  Future<BaseResponse<List<NaviListBean>>> getNaviList() async {
    return httpResponse("navi/json",(bean,response) {
      parseListBean(bean,response,(json) => NaviListBean.fromJson(json));
    });
  }

  Future<BaseResponse<List<SearchHotBean>>> getSearchHot() async {
    return httpResponse("hotkey/json",(bean,response) {
      parseListBean(bean,response,(json) => SearchHotBean.fromJson(json));
    });
  }

  Future<BaseResponse<HomeArticleBean>> search(int page,String key) async {
    return httpPostResponse("article/query/$page/json", (bean, response) {
      parseBean(bean, response, (json) => HomeArticleBean.fromJson(json));
    },params: {"k":"$key"});
  }

  Future<BaseResponse<HomeArticleBean>> collectList(int page) async {
    return httpResponse("lg/collect/list/$page/json", (bean, response) {
      parseBean(bean, response, (json) => HomeArticleBean.fromJson(json));
    });
  }

  Future<BaseResponse<dynamic>> unCollect(int id,int originId) async {
    final response = httpPostResponse("lg/uncollect/$id/json", (bean, response) {
      print("uncollect::${response.data}");
    },params: {"originId":"$originId"});
    return response;
  }

  Future<BaseResponse<ShareListBean>> shareList(int page) async {
    return httpResponse("user/lg/private_articles/$page/json", (bean, response) {
      parseBean(bean, response, (json) => ShareListBean.fromJson(json));
    });
  }

  Future<BaseResponse<dynamic>> deleteShare(int id) async {
    final response = httpPostResponse("lg/user_article/delete/$id/json", (bean, response) {
      print("delete share::${response.data}");
    });
    return response;
  }

  Future<BaseResponse<CoinInfoBean>> getPersonCoin() async {
    return httpResponse("lg/coin/userinfo/json", (bean, response) {
      parseBean(bean, response, (json) => CoinInfoBean.fromJson(json));
    });
  }

  Future<BaseResponse<CoinListBean<CoinItemBean>>> getCoinList(int page) async {
    return httpResponse("lg/coin/list/$page/json", (bean, response) {
      parseBean(bean, response, (json) {
        final data = CoinListBean<CoinItemBean>.fromJson(json);
        final itemData = json['datas'];
        if (itemData is List) {
          data.datas = <CoinItemBean>[];
          itemData.forEach((element) {
            data.datas.add(CoinItemBean.fromJson(element));
          });
        }
        return data;
      });
    });
  }

  Future<BaseResponse<CoinListBean<CoinInfoBean>>> getRankList(int page) async {
    return httpResponse("coin/rank/$page/json", (bean, response) {
      parseBean(bean, response, (json) {
        final data = CoinListBean<CoinInfoBean>.fromJson(json);
        final itemData = json['datas'];
        print("coin rank:::${itemData}");
        if (itemData is List) {
          data.datas = <CoinInfoBean>[];
          itemData.forEach((element) {
            data.datas.add(CoinInfoBean.fromJson(element));
          });
        }
        return data;
      });
    });
  }

  Future<BaseResponse<LoginBean>> login(String userName,String password) async {
    final response = httpPostResponse<LoginBean>("user/login", (bean, response) {
      CookieManager.saveCookie(response.headers[HttpHeaders.setCookieHeader],true);
      parseBean(bean, response, (json) => LoginBean.fromJson(json));
    },params: {"username" : "$userName","password" : "$password"});
    // var cookie = Cookie.fromSetCookieValue("value");
    // cookie.expires
    return response;
  }

  Future<BaseResponse<LoginBean>> register(String userName,String password,String repassword) async {
    final response = httpPostResponse<LoginBean>("user/register", (bean, response) {
      parseBean(bean, response, (json) => LoginBean.fromJson(json));
    },params: {"username" : "$userName","password" : "$password","repassword":"$repassword"});
    return response;
  }

  Future<BaseResponse<dynamic>> logout() async {
    CookieManager.clearCookie();
    final response = httpResponse("user/logout/json", (bean, response) {
      print("${response.data}");
    });
    return response;
  }

  void parseListBean<T>(BaseResponse<List<T>> bean,Response response,InitBean init) {
    if (bean.isSuccess()) {
      final data = response.data['data'];
      if (data is List) {
        final lists = <T>[];
        data.forEach((element) {
          lists.add(init(element));
        });
        bean.data = lists;
      }
    }
  }

  void parseBean<T>(BaseResponse<T> bean,Response response,InitBean init) {
    if (bean.isSuccess()) {
      final data = init(response.data['data']);
      bean.data = data;
    }
  }

  void parseHomeBanner(BaseResponse<List<HomeBannerBean>> bean,Response response) {
    parseListBean(bean, response, (json) => HomeBannerBean.fromJson(json));
  }
}

class CustomIntercept extends Interceptor {
  @override
  Future onRequest(RequestOptions options) {
    options.headers[HttpHeaders.cookieHeader] = CookieManager.getCookieHeader();
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }
}