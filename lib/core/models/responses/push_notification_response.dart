class PushNotificationResponse {
  String? id;
  String? message;
  String? subject;
  bool? isSend;
  DateTime? createdAt;
  bool? isNew;
  String? metaData;
  String? code;

  PushNotificationResponse(
      {this.id,
      this.message,
      this.subject,
      this.isSend,
      this.createdAt,
      this.isNew,
      this.code,
      this.metaData});
  factory PushNotificationResponse.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json["createdAt"]);
    final now = DateTime.now();
    final isSameMoment = createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day &&
        createdAt.hour == now.hour &&
        createdAt.minute == now.minute;

    return PushNotificationResponse(
      id: json["id"],
      message: json["message"],
      subject: json["subject"],
      isSend: json["isSend"],
      code: json["code"],
      metaData: json["metaData"],
      createdAt: createdAt,
      isNew: isSameMoment,
    );
  }
}
