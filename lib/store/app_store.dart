import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/language/app_localizations.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/dashboard_api_response.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/models/members/friend_request_model.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/models/mentions_model.dart';
import 'package:socialv/models/reactions/reactions_model.dart';
import 'package:socialv/utils/colors.dart';
import 'package:socialv/utils/constants.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isReactionEnable = false;

  @observable
  ReactionsModel defaultReaction = ReactionsModel();

  @observable
  String giphyKey = '\$';

  @observable
  String wooCurrency = '\$';

  @observable
  String nonce = '';

  @observable
  String verificationStatus = '';

  @observable
  bool showStoryLoader = false;

  @observable
  bool showWoocommerce = true;

  @observable
  bool showStoryHighlight = false;

  @observable
  bool showGif = false;

  @observable
  bool showAppbarAndBottomNavBar = true;

  @observable
  bool showShopBottom = true;

  @observable
  bool isLoggedIn = false;

  @observable
  bool doRemember = false;

  @observable
  bool isDarkMode = false;

  @observable
  String selectedLanguage = "";

  @observable
  bool isLoading = false;

  @observable
  String token = '';

  @observable
  String loginEmail = '';

  @observable
  String loginFullName = '';

  @observable
  String loginName = '';

  @observable
  String password = '';

  @observable
  String loginUserId = '';

  @observable
  String loginAvatarUrl = '';

  @observable
  List<MemberResponse> recentMemberSearchList = [];

  @observable
  List<GroupResponse> recentGroupsSearchList = [];

  @observable
  List<FriendRequestModel> suggestedUserList = [];

  @observable
  List<SuggestedGroup> suggestedGroupsList = [];

  @observable
  int notificationCount = 0;

  @action
  void setReactionsEnable(bool val) {
    isReactionEnable = val;
  }

  @action
  Future<void> setDefaultReaction(ReactionsModel val, {bool isInitializing = false}) async {
    defaultReaction = val;
  }

  @action
  Future<void> setGiphyKey(String val, {bool isInitializing = false}) async {
    giphyKey = val;
    if (!isInitializing) await setValue(SharePreferencesKey.GIPHY_API_KEY, '$val');
  }

  @action
  Future<void> setWooCurrency(String val, {bool isInitializing = false}) async {
    wooCurrency = val;
    if (!isInitializing) await setValue(SharePreferencesKey.WOO_CURRENCY, '$val');
  }

  @action
  Future<void> setNonce(String val, {bool isInitializing = false}) async {
    nonce = val;
    if (!isInitializing) await setValue(SharePreferencesKey.NONCE, '$val');
  }

  @action
  Future<void> setVerificationStatus(String val, {bool isInitializing = false}) async {
    verificationStatus = val;
    if (!isInitializing) await setValue(SharePreferencesKey.VERIFICATION_STATUS, '$val');
  }

  @action
  void setNotificationCount(int value) {
    notificationCount = value;
  }

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(SharePreferencesKey.IS_LOGGED_IN, val);
  }

  @action
  void setStoryLoader(bool val) {
    showStoryLoader = val;
  }

  @action
  void setShowWooCommerce(bool val) {
    showWoocommerce = val;
  }

  @action
  void setShowStoryHighlight(bool val) {
    showStoryHighlight = val;
  }

  @action
  void setShowGif(bool val) {
    showGif = val;
  }

  @action
  void setAppbarAndBottomNavBar(bool val) {
    showAppbarAndBottomNavBar = val;
  }

  @action
  void setShopBottom(bool val) {
    showShopBottom = val;
  }

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(SharePreferencesKey.TOKEN, '$val');
  }

  @action
  Future<void> setLoginEmail(String val, {bool isInitializing = false}) async {
    loginEmail = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_EMAIL, val);
  }

  @action
  Future<void> setLoginFullName(String val, {bool isInitializing = false}) async {
    loginFullName = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_FULL_NAME, val);
  }

  @action
  Future<void> setLoginName(String val, {bool isInitializing = false}) async {
    loginName = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_DISPLAY_NAME, val);
  }

  @action
  Future<void> setPassword(String val, {bool isInitializing = false}) async {
    password = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_PASSWORD, val);
  }

  @action
  Future<void> setLoginUserId(String val, {bool isInitializing = false}) async {
    loginUserId = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_USER_ID, val);
  }

  @action
  Future<void> setLoginAvatarUrl(String val, {bool isInitializing = false}) async {
    loginAvatarUrl = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_AVATAR_URL, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  Future<void> setRemember(bool val, {bool isInitializing = false}) async {
    doRemember = val;
    if (!isInitializing) await setValue(SharePreferencesKey.REMEMBER_ME, val);
  }

  @action
  Future<void> toggleDarkMode({bool? value, bool isFromMain = false}) async {
    isDarkMode = value ?? !isDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = bodyDark;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = bodyWhite;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = appColorPrimary;
      shadowColorGlobal = Colors.black12;
    }

    if (!isFromMain) setStatusBarColor(isDarkMode ? appBackgroundColorDark : appLayoutBackground, delayInMilliSeconds: 300);
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: Constants.defaultLanguage);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: Constants.defaultLanguage)!.languageCode!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }
}
