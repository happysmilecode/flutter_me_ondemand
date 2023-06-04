class NotificationCountModel {
  int? notificationCount;

  NotificationCountModel({this.notificationCount});

  factory NotificationCountModel.fromJson(Map<String, dynamic> json) {
    return NotificationCountModel(
      notificationCount: json['notification_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_count'] = this.notificationCount;
    return data;
  }
}
