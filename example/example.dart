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

        /// ignore: sized_box_for_whitespace
        body: Container(
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enter Passcode",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: size.width * 0.05),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                PinPlusKeyBoardPackage(
                  spacing: size.height * 0.06,
                  pinInputController: pinInputController,
                  onSubmit: () {
                    /// ignore: avoid_print
                    print("Text is : " + pinInputController.text);
                  },
                  keyboardFontFamily: '',
                ),
              ],
            )));
  }
}
