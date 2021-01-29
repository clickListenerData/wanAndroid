

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android/const/sp_const_key.dart';

class CookieManager {

  static List<Cookie> cookies = <Cookie>[];

  static void saveCookie(List<String> list,bool isLogin) {
    if (list == null || list.isEmpty) return;
    cookies.clear();
    if (isLogin) saveLocalCookie(list);
    list.forEach((element) {
      final cookie = Cookie.fromSetCookieValue(element);
      final expires = cookie.expires;
      if (expires != null && !isLogin) {
        final isExpires = expires.compareTo(DateTime.now());
        print("expires::: ,, ${cookie.expires} ,, $expires");
        if (isExpires < 0) {
          clearCookie();
          return;
        }
      }
      cookies.add(cookie);
    });
  }

  static String getCookieHeader() {
    if (cookies.isEmpty) getLocalCookie();
    final buffer = StringBuffer();
    for (int i = 0; i < cookies.length; i++) {
      final c = cookies[i];
      if(i > 0) buffer.write("; ");
      buffer..write(c.name)..write("=")..write(c.value);
    }
    print("header cookie:: ${buffer.toString()}");
    return buffer.toString();
  }

  static void clearCookie() {
    cookies.clear();
    SharedPreferences.getInstance().then((value) {
      value..remove(SpConst.COOKIE_VALUE)..remove(SpConst.IS_LOGIN)..remove(SpConst.NICK_NAME)..remove(SpConst.PUBLIC_NAME);
    });
  }

  static void saveLocalCookie(List<String> list) {
    SharedPreferences.getInstance().then((value) {
      value.setStringList(SpConst.COOKIE_VALUE, list);
    });
  }

  static void getLocalCookie() {
    SharedPreferences.getInstance().then((value) {
      saveCookie(value.getStringList(SpConst.COOKIE_VALUE),false);
    });
  }

}