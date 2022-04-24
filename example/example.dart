import 'package:flutter/material.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/pin_plus_keyboard.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  PinInputController pinInputController = PinInputController(length: 6);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(),
        // ignore: sized_box_for_whitespace
        body: Container(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                PinPlusKeyBoardPackage(
                  spacing: size.height * 0.06,
                  pinInputController: pinInputController,
                  onSubmit: () {
                    // ignore: avoid_print
                    print("Text is : " + pinInputController.text);
                  },
                ),
              ],
            )));
  }
}
