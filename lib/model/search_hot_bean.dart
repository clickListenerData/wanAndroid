

class SearchHotBean {
  int id;
  String link;
  String name;
  int order;
  int visible;

  SearchHotBean(this.id,this.link,this.name,this.order,this.visible);

  SearchHotBean.fromJson(Map<String,dynamic> json) {
    this.id = json['id'];
    this.link = json['link'];
    this.name = json['name'];
    this.order = json['order'];
    this.visible = json['visible'];
  }
}