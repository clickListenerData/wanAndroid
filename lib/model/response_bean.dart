

class BaseResponse<T> {

  T data;
  int errorCode;
  String errorMsg;

  BaseResponse(this.errorCode,this.errorMsg);

  BaseResponse.fromJson(Map<String, dynamic> json) {
    this.errorCode = json['errorCode'];
    this.errorMsg = json['errorMsg'];
  }

  bool isSuccess() => errorCode == 0;
}