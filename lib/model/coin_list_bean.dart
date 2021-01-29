

/**
 * {"coinCount":10,"date":1611888348000,"desc":"2021-01-29 10:45:48 分享文章 , 积分：10 + 0","id":367691,"reason":"分享文章","type":3,"userId":24271,"userName":"18271434187"}
*/

class CoinListBean<T> {
  int curPage;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  List<T> datas;

  CoinListBean.fromJson(Map<String,dynamic> json) {
    curPage = json['curPage'];
    offset = json['offset'];
    over = json['over'];
    pageCount = json['pageCount'];
    size = json['size'];
    total = json['total'];
  }
}

class CoinItemBean {
  int coinCount;
  int date;
  String desc;
  int id;
  String reason;
  int type;
  int userId;
  String userName;

  CoinItemBean.fromJson(Map<String,dynamic> json) {
    coinCount = json['coinCount'];
    date = json['date'];
    desc = json['desc'];
    id = json['id'];
    reason = json['reason'];
    type = json['type'];
    userId = json['userId'];
    userName = json['userName'];
  }
}