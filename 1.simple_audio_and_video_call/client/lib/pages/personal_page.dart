import 'dart:convert';
import 'package:client/config.dart';
import 'package:client/pages/room.dart';
import 'package:client/store/global_controller_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grpc/grpc.dart';

import 'package:client/generated_grpc/call_service.pb.dart';
import 'package:client/generated_grpc/call_service.pbgrpc.dart' as call_service;

class PersonalPage extends StatefulWidget {
  //
  final String email;

  const PersonalPage({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  BuildContext? the_context;
  TextEditingController target_email_inputbox_controller =
      TextEditingController();

  Future<ClientChannel> get_a_temprary_channel() async {
    final grpc_call_service_key =
        await rootBundle.load('resources/keys/grpc_call_service.crt');

    return ClientChannel(
      GrpcConfig.host_ip_address,
      port: GrpcConfig.call_service_port_number,
      options: ChannelOptions(
          credentials: ChannelCredentials.secure(
              certificates: grpc_call_service_key.buffer.asUint8List(),
              authority: GrpcConfig.host_ip_address,
              onBadCertificate: (certificate, host) {
                return true;
                // return host ==
                //     '${GrpcConfig.host_ip_address}:${GrpcConfig.call_service_port_number}';
              })),
    );
  }

  @override
  void initState() {
    super.initState();
    (() async {
      final livekit_url = variable_controller.livekit_url;
      final email = variable_controller.user_email;

      final temprary_channel = await get_a_temprary_channel();
      final call_service_client =
          call_service.CallServiceClient(temprary_channel);

      while (true) {
        final response =
            await call_service_client.iAmOnline(OnlineRequest(email: email));

        if (response.callComing == true &&
            response.token.isNotEmpty &&
            the_context != null) {
          //create new room
          final room = Room();

          //Create a Listener before connecting
          final listener = room.createListener();

          //Try to connect to the room
          //This will throw an Exception if it fails for any reason.
          await room.connect(
            livekit_url,
            response.token,
            roomOptions: RoomOptions(
              adaptiveStream: true,
              dynacast: true,
              defaultVideoPublishOptions: VideoPublishOptions(
                simulcast: true,
              ),
              defaultScreenShareCaptureOptions: const ScreenShareCaptureOptions(
                  useiOSBroadcastExtension: true),
            ),
            fastConnectOptions: true
                ? FastConnectOptions(
                    microphone: const TrackOption(enabled: true),
                    camera: const TrackOption(enabled: true),
                  )
                : null,
          );

          await Navigator.push<void>(
            the_context!,
            MaterialPageRoute(builder: (_) => RoomPage(room, listener)),
          );

          variable_controller.pause_i_am_online_loop = true;
          while (variable_controller.pause_i_am_online_loop == true) {
            await Future.delayed(const Duration(milliseconds: 1000), () {});
          }
        }

        await Future.delayed(const Duration(milliseconds: 1000), () {});
      }
    })();
  }

  @override
  void dispose() {
    // always dispose listener
    (() async {})();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    the_context = context;
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 0.1.sh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.email),
                    const Text("Waiting for another user to call you."),
                  ],
                ),
              ),
              SizedBox(
                height: 0.09.sh,
              ),
              SizedBox(
                width: 0.6.sw,
                child: TextButton(
                  child: const Text("Call others"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepOrange[50])),
                  onPressed: () async {
                    await Alert(
                        context: context,
                        title: "Who you wanna call?",
                        content: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.email),
                                labelText: 'email',
                              ),
                              style: TextStyle(color: Colors.black),
                              controller: target_email_inputbox_controller,
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "call",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();

                    final livekit_url = variable_controller.livekit_url;
                    final email = variable_controller.user_email;

                    final temprary_channel = await get_a_temprary_channel();
                    final call_service_client =
                        call_service.CallServiceClient(temprary_channel);

                    final response = await call_service_client.makeACall(
                        CallRequest(
                            email: email,
                            targetEmail:
                                target_email_inputbox_controller.text));

                    if (response.token.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "The other side refuse to answer the call.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }

                    //create new room
                    final room = Room();

                    //Create a Listener before connecting
                    final listener = room.createListener();

                    //Try to connect to the room
                    //This will throw an Exception if it fails for any reason.
                    await room.connect(
                      livekit_url,
                      response.token,
                      roomOptions: RoomOptions(
                        adaptiveStream: true,
                        dynacast: true,
                        defaultVideoPublishOptions: VideoPublishOptions(
                          simulcast: true,
                        ),
                        defaultScreenShareCaptureOptions:
                            const ScreenShareCaptureOptions(
                                useiOSBroadcastExtension: true),
                      ),
                      fastConnectOptions: true
                          ? FastConnectOptions(
                              microphone: const TrackOption(enabled: true),
                              camera: const TrackOption(enabled: true),
                            )
                          : null,
                    );

                    await Navigator.push<void>(
                      the_context!,
                      MaterialPageRoute(
                          builder: (_) => RoomPage(room, listener)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
