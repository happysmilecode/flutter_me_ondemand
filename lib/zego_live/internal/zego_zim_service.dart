import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'zego_service_define.dart';

class ZIMService {
  ZIMService._internal();
  factory ZIMService() => instance;
  static final ZIMService instance = ZIMService._internal();

  Future<void> init({required int appID, String? appSign}) async {
    initEventHandle();
    ZIM.create(
      ZIMAppConfig()
        ..appID = appID
        ..appSign = appSign ?? '',
    );
  }

  Future<void> uninit() async {
    uninitEventHandle();
    ZIM.getInstance()?.destroy();
  }

  Future<void> connectUser(String userID, String userName, {String? token}) async {
    ZIMUserInfo userInfo = ZIMUserInfo();
    userInfo.userID = userID;
    userInfo.userName = userName;
    zimUserInfo = userInfo;
    await ZIM.getInstance()!.login(userInfo, token);
  }

  Future<void> disconnectUser() async {
    ZIM.getInstance()!.logout();
  }

  String? currentRoomID;
  Future<ZegoRoomLoginResult> loginRoom(
    String roomID, {
    String? roomName,
    Map<String, String> roomAttributes = const {},
    int roomDestroyDelayTime = 0,
  }) async {
    currentRoomID = roomID;

    ZegoRoomLoginResult result = ZegoRoomLoginResult(0, {});

    await ZIM
        .getInstance()!
        .enterRoom(
            ZIMRoomInfo()
              ..roomID = roomID
              ..roomName = roomName ?? '',
            ZIMRoomAdvancedConfig()
              ..roomAttributes = roomAttributes
              ..roomDestroyDelayTime = roomDestroyDelayTime)
        .then((value) {
      result.errorCode = 0;
    }).catchError((error) {
      result.errorCode = int.tryParse(error.code) ?? -1;
      result.extendedData['errorMessage'] = error.message;
      result.extendedData['error'] = error;
    });
    return result;
  }

  Future<ZIMRoomLeftResult> logoutRoom() async {
    if (currentRoomID != null) {
      final ret = await ZIM.getInstance()!.leaveRoom(currentRoomID!);
      currentRoomID = null;
      return ret;
    } else {
      debugPrint('currentRoomID is null');
      return ZIMRoomLeftResult(roomID: '');
    }
  }

  Future<ZIMMessageSentResult> sendRoomCustomSignaling(String signaling) {
    return ZIM.getInstance()!.sendMessage(
          ZIMCommandMessage(message: Uint8List.fromList(utf8.encode(signaling))),
          currentRoomID!,
          ZIMConversationType.room,
          ZIMMessageSendConfig(),
        );
  }

  void initEventHandle() {
    ZIMEventHandler.onConnectionStateChanged = onConnectionStateChanged;
    ZIMEventHandler.onRoomStateChanged = onRoomStateChanged;
    ZIMEventHandler.onReceiveRoomMessage = onReceiveRoomMessage;
  }

  void onReceiveRoomMessage(_, List<ZIMMessage> messageList, String fromRoomID) {
    for (var element in messageList) {
      if (element is ZIMCommandMessage) {
        String signaling = utf8.decode(element.message);
        debugPrint('onReceiveRoomCustomSignaling: $signaling');
        receiveRoomCustomSignalingStreamCtrl.add(ZIMServiceReceiveRoomCustomSignalingEvent(
          signaling: signaling,
          senderUserID: element.senderUserID,
        ));
      } else if (element is ZIMTextMessage) {
        debugPrint('onReceiveRoomTextMessage: ${element.message}');
      }
    }
  }

  void onConnectionStateChanged(_, ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData) {
    connectionStateStreamCtrl.add(ZIMServiceConnectionStateChangedEvent(state, event, extendedData));
  }

  void onRoomStateChanged(_, ZIMRoomState state, ZIMRoomEvent event, Map extendedData, String roomID) {
    roomStateChangedStreamCtrl.add(ZIMServiceRoomStateChangedEvent(roomID, state, event, extendedData));
  }

  void uninitEventHandle() {
    ZIMEventHandler.onRoomStateChanged = null;
    ZIMEventHandler.onConnectionStateChanged = null;
  }

  ZIMUserInfo? zimUserInfo;

  final connectionStateStreamCtrl = StreamController<ZIMServiceConnectionStateChangedEvent>.broadcast();
  final roomStateChangedStreamCtrl = StreamController<ZIMServiceRoomStateChangedEvent>.broadcast();
  final receiveRoomCustomSignalingStreamCtrl = StreamController<ZIMServiceReceiveRoomCustomSignalingEvent>.broadcast();
}
