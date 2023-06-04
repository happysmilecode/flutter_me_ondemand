import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_zim/zego_zim.dart';

export 'zego_express_service.dart';
export 'zego_user_info.dart';

export 'package:zego_express_engine/zego_express_engine.dart';
export 'package:zego_zim/zego_zim.dart';

class ZegoRoomUserListUpdateEvent {
  final String roomID;
  final ZegoUpdateType updateType;
  final List<ZegoUser> userList;

  ZegoRoomUserListUpdateEvent(
    this.roomID,
    this.updateType,
    this.userList,
  );

  @override
  String toString() {
    return 'ZegoRoomUserListUpdateEvent{roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => '${e.userID}(${e.userName}),')}}';
  }
}

class ZegoRoomStreamListUpdateEvent {
  final String roomID;
  final ZegoUpdateType updateType;
  final List<ZegoStream> streamList;
  final Map<String, dynamic> extendedData;

  ZegoRoomStreamListUpdateEvent(this.roomID, this.updateType, this.streamList, this.extendedData);

  @override
  String toString() {
    return 'ZegoRoomStreamListUpdateEvent{roomID: $roomID, updateType: ${updateType.name}, streamList: ${streamList.map((e) => '${e.streamID}(${e.extraInfo}),')}';
  }
}

class ZegoRoomStreamExtraInfoEvent {
  final String roomID;
  final List<ZegoStream> streamList;

  ZegoRoomStreamExtraInfoEvent(this.roomID, this.streamList);

  @override
  String toString() {
    return 'ZegoRoomStreamExtraInfoEvent{roomID: $roomID, streamList: ${streamList.map((e) => '${e.streamID}(${e.extraInfo}),')}}';
  }
}

class ZegoRoomStateEvent {
  final String roomID;
  final ZegoRoomStateChangedReason reason;
  final int errorCode;
  final Map<String, dynamic> extendedData;

  ZegoRoomStateEvent(this.roomID, this.reason, this.errorCode, this.extendedData);

  @override
  String toString() {
    return 'ZegoRoomStateEvent{roomID: $roomID, reason: ${reason.name}, errorCode: $errorCode, extendedData: $extendedData}';
  }
}

class ZIMServiceConnectionStateChangedEvent {
  final ZIMConnectionState state;
  final ZIMConnectionEvent event;
  final Map extendedData;

  ZIMServiceConnectionStateChangedEvent(this.state, this.event, this.extendedData);
  @override
  String toString() {
    return 'ZIMServiceConnectionStateChangedEvent{state: ${state.name}, event: ${event.name}, extendedData: $extendedData}';
  }
}

class ZIMServiceRoomStateChangedEvent {
  final String roomID;
  final ZIMRoomState state;
  final ZIMRoomEvent event;
  final Map extendedData;

  ZIMServiceRoomStateChangedEvent(this.roomID, this.state, this.event, this.extendedData);

  @override
  String toString() {
    return 'ZIMServiceRoomStateChangedEvent{roomID: $roomID, state: ${state.name}, event: ${event.name}, extendedData: $extendedData}';
  }
}

class ZIMServiceReceiveRoomCustomSignalingEvent {
  final String signaling;
  final String senderUserID;
  ZIMServiceReceiveRoomCustomSignalingEvent({required this.signaling, required this.senderUserID});

  @override
  String toString() {
    return 'ZIMServiceReceiveRoomCustomSignalingEvent{signaling: $signaling, senderUserID: $senderUserID}';
  }
}
