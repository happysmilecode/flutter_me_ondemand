class LoginResponse {
  LoginResponse({
    this.token,
    this.userEmail,
    this.userNicename,
    this.userDisplayName,
  });

  LoginResponse.fromJson(dynamic json) {
    token = json['token'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
  }

  String? token;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;

  LoginResponse copyWith({
    String? token,
    String? userEmail,
    String? userNicename,
    String? userDisplayName,
  }) =>
      LoginResponse(
        token: token ?? this.token,
        userEmail: userEmail ?? this.userEmail,
        userNicename: userNicename ?? this.userNicename,
        userDisplayName: userDisplayName ?? this.userDisplayName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['user_email'] = userEmail;
    map['user_nicename'] = userNicename;
    map['user_display_name'] = userDisplayName;
    return map;
  }
}
