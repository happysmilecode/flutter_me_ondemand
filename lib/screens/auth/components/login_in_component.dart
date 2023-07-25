import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/auth/screens/forget_password_screen.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/post/screens/single_post_screen.dart';
import 'package:socialv/services/login_service.dart';

import '../../../utils/app_constants.dart';

class LoginInComponent extends StatefulWidget {
  final VoidCallback? callback;
  final int? activityId;

  LoginInComponent({this.callback, this.activityId});

  @override
  State<LoginInComponent> createState() => _LoginInComponentState();
}

class _LoginInComponentState extends State<LoginInComponent> {
  final loginFormKey = GlobalKey<FormState>();

  bool doRemember = false;

  TextEditingController nameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode name = FocusNode();
  FocusNode password = FocusNode();

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
    if (appStore.doRemember) {
      nameCont.text = appStore.loginName;
      passwordCont.text = appStore.password;
    } else if (await isIqonicProduct) {
      nameCont.text = DEMO_USER_EMAIL;
      passwordCont.text = DEMO_USER_PASSWORD;
    } else {
      //
    }
  }

  Future<void> login({required Map req, bool isSocialLogin = false}) async {
    appStore.setLoading(true);

    hideKeyboard(context);

    await loginUser(request: req, isSocialLogin: isSocialLogin).then((value) async {
      Map req = {"player_id": getStringAsync(SharePreferencesKey.ONE_SIGNAL_PLAYER_ID), "add": 1};

      await setPlayerId(req).then((value) {
        //
      }).catchError((e) {
        log("Player id error : ${e.toString()}");
      });
      appStore.setPassword(passwordCont.text.validate());
      getMemberById();
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> getMemberById() async {
    await getLoginMember().then((value) {
      appStore.setLoginUserId(value.id.toString());
      appStore.setLoginAvatarUrl(value.avatarUrls!.full.validate());
      appStore.setLoading(false);

      if (widget.activityId != null) {
        SinglePostScreen(postId: widget.activityId.validate()).launch(context, isNewTask: true);
      } else {
        push(DashboardScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  ///google sign in

  void googleSignIn() async {
    var service = LoginService();
    await service.signInWithGoogle().then((res) async {
      await login(req: res, isSocialLogin: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// apple login
  void appleSignIn() async {
    var service = LoginService();
    await service.appleSignIn().then((res) async {
      await login(req: res, isSocialLogin: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        width: context.width(),
        color: context.cardColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Text(language.welcomeBack, style: boldTextStyle(size: 24)).paddingSymmetric(horizontal: 16),
              8.height,
              Text(
                language.youHaveBeenMissed,
                style: secondaryTextStyle(weight: FontWeight.w500),
              ).paddingSymmetric(horizontal: 16),
              Form(
                key: loginFormKey,
                child: Container(
                  child: Column(
                    children: [
                      30.height,
                      AppTextField(
                        enabled: !appStore.isLoading,
                        controller: nameCont,
                        nextFocus: password,
                        focus: name,
                        textFieldType: TextFieldType.USERNAME,
                        textStyle: boldTextStyle(),
                        decoration: inputDecoration(
                          context,
                          label: '${language.username}/${language.email}',
                          labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                        ),
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      AppTextField(
                        enabled: !appStore.isLoading,
                        controller: passwordCont,
                        focus: password,
                        textFieldType: TextFieldType.PASSWORD,
                        textStyle: boldTextStyle(),
                        suffixIconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                        decoration: inputDecoration(
                          context,
                          label: language.password,
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                        ),
                        isPassword: true,
                        onFieldSubmitted: (x) {
                          if (loginFormKey.currentState!.validate()) {
                            loginFormKey.currentState!.save();
                            hideKeyboard(context);

                            Map request = {
                              Users.username: nameCont.text.trim().validate(),
                              Users.password: passwordCont.text.trim().validate(),
                            };
                            login(req: request);
                          } else {
                            appStore.setLoading(false);
                          }
                        },
                      ).paddingSymmetric(horizontal: 16),
                      12.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Observer(
                            builder: (_) => Row(
                              children: [
                                Checkbox(
                                  shape: RoundedRectangleBorder(borderRadius: radius(2)),
                                  activeColor: context.primaryColor,
                                  value: appStore.doRemember,
                                  onChanged: (val) {
                                    appStore.setRemember(!appStore.doRemember);
                                    setState(() {});
                                  },
                                ),
                                Text(language.rememberMe, style: secondaryTextStyle()).onTap(() {
                                  appStore.setRemember(!appStore.doRemember);
                                  setState(() {});
                                }),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ForgetPasswordScreen().launch(context);
                            },
                            child: Text(
                              language.forgetPassword,
                              style: secondaryTextStyle(color: context.primaryColor, fontStyle: FontStyle.italic),
                            ),
                          ).paddingRight(8)
                        ],
                      ),
                      32.height,
                      appButton(
                        context: context,
                        text: language.login.capitalizeFirstLetter(),
                        onTap: () {
                          push(DashboardScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
                          // if (loginFormKey.currentState!.validate()) {
                          //   loginFormKey.currentState!.save();
                          //   hideKeyboard(context);
                          //
                          //   Map request = {
                          //     Users.username: nameCont.text.trim().validate(),
                          //     Users.password: passwordCont.text.trim().validate(),
                          //   };
                          //   login(req: request);
                          // } else {
                          //   appStore.setLoading(false);
                          // }
                        },
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(language.dHaveAnAccount, style: secondaryTextStyle()),
                          4.width,
                          Text(
                            language.signUp,
                            style: secondaryTextStyle(color: context.primaryColor, decoration: TextDecoration.underline),
                          ).onTap(() {
                            widget.callback?.call();
                          }, highlightColor: Colors.transparent, splashColor: Colors.transparent)
                        ],
                      ),
                      16.height,
                      Row(
                        children: [
                          AppButton(
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
                            onTap: () {
                              appStore.setLoading(true);
                              googleSignIn();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GoogleLogoWidget(size: 14),
                                6.width,
                                Text(language.signInWithGoogle, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                              ],
                            ).center(),
                            elevation: 1,
                            color: context.cardColor,
                          ).expand(),
                          16.width,
                          if (isIOS)
                            AppButton(
                              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
                              onTap: () {
                                appStore.setLoading(true);
                                appleSignIn();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.apple, color: context.iconColor, size: 22),
                                  6.width,
                                  Text(language.signInWithApple, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                                ],
                              ),
                              elevation: 1,
                              color: context.cardColor,
                            ).expand(),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      50.height,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
