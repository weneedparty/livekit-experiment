import 'dart:io';

import 'package:client/store/global_controller_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:client/pages/personal_page.dart';
import 'package:client/widgets/text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import '../exts.dart';
import 'room.dart';

class ConnectPage extends StatefulWidget {
  //
  const ConnectPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  //
  static const _storeKeyUri = 'uri';
  static const _store_email_key = 'email';
  static const _storeKeySimulcast = 'simulcast';
  static const _storeKeyAdaptiveStream = 'adaptive-stream';
  static const _storeKeyDynacast = 'dynacast';
  static const _storeKeyFastConnect = 'fast-connect';

  final _uriCtrl = TextEditingController();
  final _email_input_controller = TextEditingController();
  bool _simulcast = true;
  bool _adaptiveStream = true;
  bool _dynacast = true;
  bool _busy = false;
  bool _fastConnect = false;

  @override
  void initState() {
    super.initState();
    _readPrefs();

    () async {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
        // Permission.bluetooth,
      ].request();
      if (statuses.values.any((status) => status != PermissionStatus.granted)) {
        await Alert(
          context: context,
          title: 'Permission denied',
          desc: 'Please grant the required permissions to use this app.',
          buttons: [
            DialogButton(
              child: const Text('OK'),
              onPressed: () => exit(0),
            ),
          ],
        ).show();
      }
    }();
  }

  @override
  void dispose() {
    _uriCtrl.dispose();
    _email_input_controller.dispose();
    super.dispose();
  }

  // Read saved URL and EMAIL
  Future<void> _readPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _uriCtrl.text = variable_controller.livekit_url;
    _email_input_controller.text = variable_controller.user_email;

    setState(() {
      _simulcast = prefs.getBool(_storeKeySimulcast) ?? true;
      _adaptiveStream = prefs.getBool(_storeKeyAdaptiveStream) ?? true;
      _dynacast = prefs.getBool(_storeKeyDynacast) ?? true;
      _fastConnect = prefs.getBool(_storeKeyFastConnect) ?? false;
    });
  }

  // Save URL and Email
  Future<void> _writePrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await variable_controller.save_livekit_url(_uriCtrl.text);
    await variable_controller.save_user_email(_email_input_controller.text);

    await prefs.setBool(_storeKeySimulcast, _simulcast);
    await prefs.setBool(_storeKeyAdaptiveStream, _adaptiveStream);
    await prefs.setBool(_storeKeyDynacast, _dynacast);
    await prefs.setBool(_storeKeyFastConnect, _fastConnect);
  }

  Future<void> _connect(BuildContext ctx) async {
    //
    try {
      setState(() {
        _busy = true;
      });

      // Save URL and EMAIL for convenience
      await _writePrefs();

      print('Connecting with url: ${_uriCtrl.text}, '
          'email: ${_email_input_controller.text}...');

      //create new room
      // final room = Room();

      // Create a Listener before connecting
      // final listener = room.createListener();

      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      // await room.connect(
      //   _uriCtrl.text,
      //   _email_input_controller.text,
      //   roomOptions: RoomOptions(
      //     adaptiveStream: _adaptiveStream,
      //     dynacast: _dynacast,
      //     defaultVideoPublishOptions: VideoPublishOptions(
      //       simulcast: _simulcast,
      //     ),
      //     defaultScreenShareCaptureOptions:
      //         const ScreenShareCaptureOptions(useiOSBroadcastExtension: true),
      //   ),
      //   fastConnectOptions: _fastConnect
      //       ? FastConnectOptions(
      //           microphone: const TrackOption(enabled: true),
      //           camera: const TrackOption(enabled: true),
      //         )
      //       : null,
      // );

      // await Navigator.push<void>(
      //   ctx,
      //   MaterialPageRoute(builder: (_) => RoomPage(room, listener)),
      // );

      await Navigator.push<void>(
        ctx,
        MaterialPageRoute(
            builder: (_) => PersonalPage(email: _email_input_controller.text)),
      );
    } catch (error) {
      print('Could not connect $error');
      await ctx.showErrorDialog(error);
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  void _setSimulcast(bool? value) async {
    if (value == null || _simulcast == value) return;
    setState(() {
      _simulcast = value;
    });
  }

  void _setAdaptiveStream(bool? value) async {
    if (value == null || _adaptiveStream == value) return;
    setState(() {
      _adaptiveStream = value;
    });
  }

  void _setDynacast(bool? value) async {
    if (value == null || _dynacast == value) return;
    setState(() {
      _dynacast = value;
    });
  }

  void _setFastConnect(bool? value) async {
    if (value == null || _fastConnect == value) return;
    setState(() {
      _fastConnect = value;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: SvgPicture.asset(
                      'resources/images/logo-dark.svg',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: LKTextField(
                      label: 'Server URL',
                      ctrl: _uriCtrl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: LKTextField(
                      label: 'Email',
                      ctrl: _email_input_controller,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Simulcast'),
                        Switch(
                          value: _simulcast,
                          onChanged: (value) => _setSimulcast(value),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Adaptive Stream'),
                        Switch(
                          value: _adaptiveStream,
                          onChanged: (value) => _setAdaptiveStream(value),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Fast Connect'),
                        Switch(
                          value: _fastConnect,
                          onChanged: (value) => _setFastConnect(value),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dynacast'),
                        Switch(
                          value: _dynacast,
                          onChanged: (value) => _setDynacast(value),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _busy ? null : () => _connect(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_busy)
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        const Text('CONNECT'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
