

class LoginBean {
  bool admin;
  int coinCount;
  List<String> collectIds;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String publicName;
  String token;
  int type;
  String username;

  LoginBean.fromJson(Map<String,dynamic> json) {
    this.admin = json['admin'];
    this.coinCount = json['coinCount'];
    this.email = json['email'];
    this.icon = json['icon'];
    this.id = json['id'];
    this.nickname = json['nickname'];
    this.password = json['password'];
    this.publicName = json['publicName'];
    this.token = json['token'];
    this.type = json['type'];
    this.username = json['username'];
    final data = json['collectIds'];
    collectIds = [];
    if (data is List) {
      data.forEach((element) {
        collectIds.add(element.toString());
      });
    }


  }
}