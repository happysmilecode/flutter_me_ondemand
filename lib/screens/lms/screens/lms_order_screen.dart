import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/lms_order_model.dart';
import 'package:socialv/utils/app_constants.dart';

class LmsOrderScreen extends StatelessWidget {
  final LmsOrderModel orderDetail;

  LmsOrderScreen({required this.orderDetail});

  @override
  Widget build(BuildContext context) {
    /// todo: export invoice

    return AppScaffold(
      appBarTitle: language.orderDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${language.orderId}: ${orderDetail.orderNumber}', style: boldTextStyle()),
          16.height,
          Text('${language.payVia}: ${orderDetail.orderMethod}', style: primaryTextStyle()),
          16.height,
          Container(
            width: context.width(),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.orderDetails, style: boldTextStyle(size: 18)),
                Divider(height: 20),
                12.height,
                Text('${language.dateCreated}: ${orderDetail.orderDate}', style: primaryTextStyle()),
                12.height,
                Text('${language.status}: ${orderDetail.orderStatus}', style: primaryTextStyle()),
                12.height,
                Text('${language.customer}: ${appStore.loginFullName}', style: primaryTextStyle()),
                12.height,
                Text('${language.email}: ${appStore.loginEmail}', style: primaryTextStyle()),
                12.height,
                Text('${language.orderKey}: ${orderDetail.orderKey}', style: primaryTextStyle()),
              ],
            ),
          ),
          16.height,
          Text(language.orderItems, style: boldTextStyle(size: 18)),
          16.height,
          ListView.builder(
            itemCount: orderDetail.orderItems.validate().length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              OrderItem item = orderDetail.orderItems.validate()[index];
              return Container(
                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name.validate(), style: boldTextStyle()),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${language.cost}: ${item.regularPrice}', style: secondaryTextStyle()),
                        Text('${language.quantity}: *${item.quantity.validate()}', style: secondaryTextStyle()),
                      ],
                    ),
                    10.height,
                    Text('${language.total}: ${item.regularPrice}', style: primaryTextStyle(color: context.primaryColor)),
                  ],
                ),
              );
            },
          ),
        ],
      ).paddingAll(16),
    );
  }
}
