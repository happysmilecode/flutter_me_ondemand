import 'package:socialv/models/members/friend_request_model.dart';

class DashboardAPIResponse {
  int? notificationCount;
  List<VisibilityOptions>? visibilities;
  List<VisibilityOptions>? accountPrivacyVisibility;
  List<ReportType>? reportTypes;
  List<String>? storyAllowedTypes;
  String? verificationStatus;
  List<FriendRequestModel>? suggestedUser;
  bool? isHighlightStoryEnable;
  bool? isWoocommerceEnable;
  String? wooCurrency;
  String? giphyKey;
  List<StoryActions>? storyActions;
  bool? isShopEnable;
  String? lmsCurrency;
  bool? isReactionEnable;
  List<SuggestedGroup>? suggestedGroups;

  DashboardAPIResponse({
    this.notificationCount,
    this.visibilities,
    this.storyAllowedTypes,
    this.reportTypes,
    this.verificationStatus,
    this.accountPrivacyVisibility,
    this.suggestedUser,
    this.isHighlightStoryEnable,
    this.isWoocommerceEnable,
    this.wooCurrency,
    this.giphyKey,
    this.storyActions,
    this.isShopEnable,
    this.lmsCurrency,
    this.isReactionEnable,
    this.suggestedGroups,
  });

  factory DashboardAPIResponse.fromJson(Map<String, dynamic> json) {
    return DashboardAPIResponse(
      notificationCount: json['notification_count'],
      verificationStatus: json['verification_status'],
      visibilities: json['visibilities'] != null ? (json['visibilities'] as List).map((i) => VisibilityOptions.fromJson(i)).toList() : null,
      accountPrivacyVisibility: json['account_privacy_visibility'] != null ? (json['account_privacy_visibility'] as List).map((i) => VisibilityOptions.fromJson(i)).toList() : null,
      reportTypes: json['report_types'] != null ? (json['report_types'] as List).map((i) => ReportType.fromJson(i)).toList() : null,
      storyAllowedTypes: json['story_allowed_types'] != null ? new List<String>.from(json['story_allowed_types']) : null,
      suggestedUser: json['suggested_user'] != null ? (json['suggested_user'] as List).map((i) => FriendRequestModel.fromJson(i)).toList() : null,
      isHighlightStoryEnable: json['is_highlight_story_enable'],
      isWoocommerceEnable: json['is_woocommerce_enable'],
      wooCurrency: json['woo_currency'],
      giphyKey: json['giphy_key'],
      storyActions: json['story_actions'] != null ? (json['story_actions'] as List).map((i) => StoryActions.fromJson(i)).toList() : null,
      isShopEnable: json['is_shop_enable'],
      lmsCurrency: json['lms_currency'],
      isReactionEnable: json['is_reaction_enable'],
      suggestedGroups: json['suggested_groups'] != null ? (json['suggested_groups'] as List).map((i) => SuggestedGroup.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_count'] = this.notificationCount;
    data['verification_status'] = this.verificationStatus;
    if (this.visibilities != null) {
      data['visibilities'] = this.visibilities!.map((v) => v.toJson()).toList();
    }
    if (this.visibilities != null) {
      data['account_privacy_visibility'] = this.accountPrivacyVisibility!.map((v) => v.toJson()).toList();
    }
    if (this.storyAllowedTypes != null) {
      data['story_allowed_types'] = this.storyAllowedTypes;
    }
    if (this.reportTypes != null) {
      data['report_types'] = this.reportTypes!.map((v) => v.toJson()).toList();
    }
    if (this.storyActions != null) {
      data['story_actions'] = this.storyActions!.map((v) => v.toJson()).toList();
    }
    if (this.suggestedGroups != null) {
      data['suggested_groups'] = this.storyActions!.map((v) => v.toJson()).toList();
    }
    data['is_highlight_story_enable'] = this.isHighlightStoryEnable;
    data['is_woocommerce_enable'] = this.isWoocommerceEnable;
    data['woo_currency'] = this.wooCurrency;
    data['giphy_key'] = this.giphyKey;
    data['is_shop_enable'] = this.isShopEnable;
    data['lms_currency'] = this.lmsCurrency;
    data['is_reaction_enable'] = this.isReactionEnable;

    return data;
  }
}

class VisibilityOptions {
  String? id;
  String? label;

  VisibilityOptions({this.id, this.label});

  factory VisibilityOptions.fromJson(Map<String, dynamic> json) {
    return VisibilityOptions(
      id: json['id'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}

class ReportType {
  String? key;
  String? label;

  ReportType({this.key, this.label});

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      key: json['key'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['label'] = this.label;
    return data;
  }
}

class StoryActions {
  String? action;
  String? name;

  StoryActions({this.action, this.name});

  factory StoryActions.fromJson(Map<String, dynamic> json) {
    return StoryActions(
      action: json['action'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['name'] = this.name;
    return data;
  }
}

class SuggestedGroup {
  int? id;
  String? groupAvtarImage;
  String? name;

  SuggestedGroup({this.groupAvtarImage, this.name, this.id});

  factory SuggestedGroup.fromJson(Map<String, dynamic> json) {
    return SuggestedGroup(
      id: json['id'],
      groupAvtarImage: json['group_avtar_image'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_avtar_image'] = this.groupAvtarImage;
    data['name'] = this.name;
    return data;
  }
}
