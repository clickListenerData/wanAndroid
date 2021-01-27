/**
 * "desc":"扔物线",
 * "id":29,"imagePath":
 * "https://wanandroid.com/blogimgs/8690f5f9-733a-476a-8ad2-2468d043c2d4.png",
 * "isVisible":1,
 * "order":0,
 * "title":"Kotlin 的 Lambda，大部分人学得连皮毛都不算",
 * "type":0,
 * "url":"http://i0k.cn/5jhSp"
 */
class HomeBannerBean {

  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  HomeBannerBean(this.desc,this.id,this.imagePath,this.isVisible,this.order,this.title,this.type,this.url);

  factory HomeBannerBean.fromJson(Map<String,dynamic> json) {
    return HomeBannerBean(json['desc'],json['id'],json['imagePath'],json['isVisible'],json['order'],json['title'],json['type'],json['url']);
  }

}