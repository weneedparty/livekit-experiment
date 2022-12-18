import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  @override
  void initState() {
    super.initState();
    (() async {})();
  }

  @override
  void dispose() {
    // always dispose listener
    (() async {})();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
