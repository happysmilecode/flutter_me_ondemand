import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/course_list_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/components/course_card_component.dart';
import 'package:socialv/screens/lms/components/empty_mycourse_component.dart';

import '../../../utils/app_constants.dart';

class CourseListScreen extends StatefulWidget {
  final bool myCourses;
  final int? categoryId;

  CourseListScreen({this.myCourses = false, this.categoryId});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List<CourseListModel> courseList = [];
  late Future<List<CourseListModel>> future;
  String status = '';
  int selectedValue = 1;

  int mPage = 1;
  bool mIsLastPage = false;

  bool isError = false;
  bool isEmpty = false;

  @override
  void initState() {
    future = getCourses();
    super.initState();
  }

  Future<List<CourseListModel>> getCourses() async {
    appStore.setLoading(true);

    if (widget.myCourses) {
      await getCourseList(page: mPage, myCourse: true, status: status).then((value) {
        if (mPage == 1) courseList.clear();
        mIsLastPage = value.length != PER_PAGE;
        courseList.addAll(value);
        setState(() {});

        appStore.setLoading(false);
      }).catchError((e) {
        isError = true;
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    } else {
      await getCourseList(page: mPage, categoryId: widget.categoryId).then((value) {
        if (mPage == 1) courseList.clear();
        mIsLastPage = value.length != PER_PAGE;
        courseList.addAll(value);
        setState(() {});

        appStore.setLoading(false);
      }).catchError((e) {
        isError = true;
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }

    return courseList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getCourses();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.myCourses ? language.myCourses : language.courses,
      onBack: () {
        finish(context);
      },
      actions: [
        if (widget.myCourses)
          Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: PopupMenuButton(
              enabled: !appStore.isLoading,
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
              onSelected: (val) async {
                if (val == 1) {
                  status = '';
                } else if (val == 2) {
                  status = CourseStatus.inProgress;
                } else if (val == 3) {
                  status = CourseStatus.passed;
                } else {
                  status = CourseStatus.failed;
                }

                if (selectedValue != val) {
                  onRefresh();
                } else {
                  //
                }

                selectedValue = val.toString().toInt();
              },
              icon: Icon(Icons.more_vert, color: context.iconColor),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 1,
                  child: Text(language.all, style: primaryTextStyle()),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(language.inProgress, style: primaryTextStyle()),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text(language.passed, style: primaryTextStyle()),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Text(language.failed, style: primaryTextStyle()),
                ),
              ],
            ),
          )
        else
          TextButton(
            onPressed: () {
              CourseListScreen(myCourses: true).launch(context);
            },
            child: Text(language.myCourses, style: primaryTextStyle(color: context.primaryColor)),
          ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: appColorPrimary,
        child: FutureBuilder<List<CourseListModel>>(
          future: future,
          builder: (ctx, snap) {
            if (snap.hasError) {
              return NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: isError ? language.somethingWentWrong : language.noDataFound,
                onRetry: () {
                  onRefresh();
                },
                retryText: '   ${language.clickToRefresh}   ',
              ).center();
            }

            if (snap.hasData) {
              if (snap.data.validate().isEmpty) {
                if (widget.myCourses) {
                  isEmpty = true;
                  return EmptyMyCourseComponent().center();
                } else {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      onRefresh();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center();
                }
              } else {
                return AnimatedListView(
                  slideConfiguration: SlideConfiguration(
                    delay: 80.milliseconds,
                    verticalOffset: 300,
                  ),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                  itemCount: courseList.length,
                  itemBuilder: (context, index) {
                    CourseListModel data = courseList[index];
                    return CourseCardComponent(course: data).paddingSymmetric(vertical: 8);
                  },
                  onNextPage: () {
                    if (!mIsLastPage) {
                      mPage++;
                      future = getCourses();
                    }
                  },
                );
              }
            }
            return Offstage();
          },
        ),
      ),
    );
  }
}
