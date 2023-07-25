import 'package:flutter/material.dart';

import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'package:socialv/zego_live/pk/cancel_pk_battle_request_button.dart';
import 'package:socialv/zego_live/pk/mute_another_host_button.dart';
import 'package:socialv/zego_live/pk/send_pk_battle_request_button.dart';
import 'package:socialv/zego_live/pk/stop_pk_battle_button.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final String localUserID;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    required this.localUserID,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  ZegoUIKitPrebuiltLiveStreamingController? liveController;
  ValueNotifier<ZegoLiveStreamingState> liveStreamingState =
  ValueNotifier(ZegoLiveStreamingState.idle);

  @override
  void initState() {
    super.initState();

    liveController = ZegoUIKitPrebuiltLiveStreamingController();
  }

  @override
  void dispose() {
    super.dispose();

    liveController = null;
  }

  @override
  Widget build(BuildContext context) {
    late ZegoUIKitPrebuiltLiveStreamingConfig config;
    if (widget.isHost) {
      config = ZegoUIKitPrebuiltLiveStreamingConfig.host(
        plugins: [ZegoUIKitSignalingPlugin()],
      );
      config.audioVideoViewConfig.foregroundBuilder = pkBattleForegroundBuilder;
    } else {
      config = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    }

    config
      ..onLiveStreamingStateUpdate = (state) {
        liveStreamingState.value = state;
      }


    /// support minimizing
      ..topMenuBarConfig.buttons = [ZegoMenuBarButtonName.minimizingButton];

    if (widget.isHost) {
      config.foreground = pkBattleButton();
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ZegoUIKitPrebuiltLiveStreaming(
              appID: 1042980941 /*input your AppID*/,
              appSign:
              'dc8835adba6c173a0e90e27f55d61487ae055ee1ea5950fea2ea5149c1339402' /*input your AppSign*/,
              userID: widget.localUserID,
              userName: 'user_${widget.localUserID}',
              liveID: widget.liveID,
              config: config,
              controller: liveController,
            ),
          ],
        ),
      ),
    );
  }

  Widget pkBattleButton() {
    return ValueListenableBuilder(
      valueListenable: liveStreamingState,
      builder: (context, value, Widget? child) {
        if ((value == ZegoLiveStreamingState.idle) ||
            (value == ZegoLiveStreamingState.ended)) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 80,
          right: 10,
          child: ValueListenableBuilder(
            valueListenable:
            ZegoUIKitPrebuiltLiveStreamingPKService().pkBattleState,
            builder:
                (context, ZegoLiveStreamingPKBattleState pkBattleState, _) {
              switch (pkBattleState) {
                case ZegoLiveStreamingPKBattleState.idle:
                  return const SendPKBattleRequestButton();
                case ZegoLiveStreamingPKBattleState.waitingAnotherHostResponse:
                  return const CancelPKBattleRequestButton();
                case ZegoLiveStreamingPKBattleState.waitingMyResponse:
                case ZegoLiveStreamingPKBattleState.loading:
                  return const CircularProgressIndicator();
                case ZegoLiveStreamingPKBattleState.inPKBattle:
                  return const StopPKBattleButton();
              }
            },
          ),
        );
      },
    );
  }

  Widget pkBattleForegroundBuilder(context, size, ZegoUIKitUser? user, _) {
    if (user != null && user.id != widget.localUserID) {
      return const Positioned(
        top: 5,
        left: 5,
        child: SizedBox(
          width: 40,
          height: 40,
          child: MuteAnotherHostButton(),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}