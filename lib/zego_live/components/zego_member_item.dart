import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socialv/zego_live/define.dart';
import 'package:socialv/zego_live/internal/zego_express_service.dart';
import 'package:socialv/zego_live/zego_sdk_manager.dart';

class ZegoMemberItem extends StatefulWidget {
  const ZegoMemberItem({required this.userInfo, required this.applyCohostList, super.key});

  final ZegoUserInfo userInfo;
  final ValueNotifier<List<String>> applyCohostList;

  @override
  State<ZegoMemberItem> createState() => _ZegoMemberItemState();
}

class _ZegoMemberItemState extends State<ZegoMemberItem> {
  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder(valueListenable: widget.userInfo, builder: builder)
    return ValueListenableBuilder<List<String>>(
        valueListenable: widget.applyCohostList,
        builder: (context, applyCohosts, _) {
          if (applyCohosts.contains(widget.userInfo.userID)) {
            return Row(
              children: [
                Text(widget.userInfo.userName),
                const SizedBox(
                  width: 40,
                ),
                OutlinedButton(
                    onPressed: () {
                      final signaling = jsonEncode({
                        'type': CustomSignalingType.hostRefuseAudienceCoHostApply,
                        'senderID': ZEGOSDKManager.instance.localUser!.userID,
                        'receiverID': widget.userInfo.userID,
                      });
                      ZEGOSDKManager.instance.zimService.sendRoomCustomSignaling(signaling);
                      widget.applyCohostList.value.removeWhere((element) {
                        return element == widget.userInfo.userID;
                      });
                    },
                    child: const Text('Disagree')),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    onPressed: () {
                      final signaling = jsonEncode({
                        'type': CustomSignalingType.hostAcceptAudienceCoHostApply,
                        'senderID': ZEGOSDKManager.instance.localUser!.userID,
                        'receiverID': widget.userInfo.userID,
                      });
                      ZEGOSDKManager.instance.zimService.sendRoomCustomSignaling(signaling);
                      widget.applyCohostList.value.removeWhere((element) {
                        return element == widget.userInfo.userID;
                      });
                    },
                    child: const Text('Agree')),
              ],
            );
          } else {
            return Text(widget.userInfo.userName);
          }
        });
  }
}
