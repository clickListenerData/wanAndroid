/**
 * "children":[],
 * "courseId":13,
 * "id":60,
 * "name":"Android Studio相关",
 * "order":1000,
 * "parentChapterId":150,
 * "userControlSetTop":false,
 * "visible":1
 */
class AnswerList {

  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;
  List<AnswerList> children;

  AnswerList(this.courseId,this.id,this.name,this.order,this.parentChapterId,this.userControlSetTop,this.visible);

  AnswerList.fromJson(Map<String,dynamic> json) {
      this.courseId = json['courseId'];
      this.id = json['id'];
      this.name = json['name'];
      this.order = json['order'];
      this.parentChapterId = json['parentChapterId'];
      this.userControlSetTop = json['userControlSetTop'];
      this.visible = json['visible'];
      final data = json['children'];
      if (data is List && data.isNotEmpty) {
        final lists = <AnswerList>[];
        data.forEach((element) {
          lists.add(AnswerList.fromJson(element));
        });
        children = lists;
      }
  }
}