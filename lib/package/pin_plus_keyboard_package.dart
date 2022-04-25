import 'package:flutter/material.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';

enum KeyboardButtonShape { circlar, rounded, defaultShape }
enum InputShape { circlar, rounded, defaultShape }

class PinPlusKeyBoardPackage extends StatefulWidget {
  final KeyboardButtonShape keyboardButtonShape;
  final InputShape inputShape;
  final double keyboardMaxWidth;
  final double keyboardVerticalSpacing;
  final double spacing;
  final Color? buttonFillColor;
  final Color? buttonBorderColor;
  final Color? btnTextColor;
  final bool btnHasBorder;
  final double? btnBorderThickness;
  final double? btnElevation;
  final Color? btnShadowColor;
  final double? inputSize;
  final bool isInputHidden;
  final Color inputHiddenColor;
  final double inputsMaxWidth;
  final PinInputController pinInputController;
  final Function() onSubmit;
  final Color? inputFillColor;
  final Color? inputBorderColor;
  final Color? inputTextColor;
  final bool inputHasBorder;
  final double? inputBorderThickness;
  final double? inputElevation;
  final Color? inputShadowColor;
  final Color errorColor;

  const PinPlusKeyBoardPackage(
      {Key? key,
      this.keyboardButtonShape = KeyboardButtonShape.defaultShape,
      this.inputShape = InputShape.defaultShape,
      this.keyboardMaxWidth = 80,
      this.keyboardVerticalSpacing = 8,
      required this.spacing,
      this.buttonFillColor,
      this.buttonBorderColor,
      this.btnHasBorder = true,
      this.btnTextColor,
      this.btnBorderThickness,
      this.btnElevation,
      this.btnShadowColor,
      this.inputSize,
      this.isInputHidden = false,
      this.inputHiddenColor = Colors.black,
      this.inputsMaxWidth = 70,
      required this.pinInputController,
      required this.onSubmit,
      this.inputFillColor,
      this.inputBorderColor,
      this.inputTextColor,
      this.inputHasBorder = true,
      this.inputBorderThickness,
      this.inputElevation,
      this.inputShadowColor,
      this.errorColor = Colors.red})
      : super(key: key);

  @override
  State<PinPlusKeyBoardPackage> createState() => _PinPlusKeyBoardPackageState();
}

class _PinPlusKeyBoardPackageState extends State<PinPlusKeyBoardPackage> {
  List<int> inputNumbers = [];
  String res = "";
  String errorText = '';
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pinInputController.length; i++) {
      inputNumbers.add(i);
    }
    widget.pinInputController.addListener(() {
      inputNumbers.clear();
      for (int i = 0; i < widget.pinInputController.length; i++) {
        inputNumbers.add(i);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: size.width * (widget.inputsMaxWidth / 100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: inputNumbers.map((e) => inputWidget(e)).toList(),
          ),
        ),
        errorText.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorText,
                  style: TextStyle(color: widget.errorColor),
                ),
              )
            : Container(),
        SizedBox(
          height: widget.spacing,
        ),
        customKeyboard(size: size),
      ],
    );
  }

  Widget keyboardButtons(String number) {
    double _sizeW = MediaQuery.of(context).size.width;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: widget.keyboardVerticalSpacing,
            horizontal: _sizeW * 0.01),
        child: GestureDetector(
          onTap: () {
            btnClicked(number);
          },
          child: Container(
            alignment: Alignment.center,
            width: widget.keyboardButtonShape == KeyboardButtonShape.circlar
                ? _sizeW * 0.13
                : _sizeW * 0.1,
            height: widget.keyboardButtonShape == KeyboardButtonShape.circlar
                ? _sizeW * 0.13
                : _sizeW * 0.1,
            decoration: BoxDecoration(
                color: widget.buttonFillColor ?? Colors.transparent,
                border: widget.btnHasBorder == true
                    ? Border.all(
                        color: widget.buttonBorderColor ?? Colors.black,
                        width: widget.btnBorderThickness ?? 1,
                      )
                    : null,
                borderRadius:
                    widget.keyboardButtonShape == KeyboardButtonShape.rounded
                        ? BorderRadius.circular(_sizeW)
                        : null,
                boxShadow: [
                  BoxShadow(
                    color: widget.btnElevation == null
                        ? Colors.transparent
                        : widget.btnShadowColor?.withOpacity(0.6) ??
                            widget.buttonFillColor?.withOpacity(0.6) ??
                            Colors.black.withOpacity(0.6),
                    spreadRadius: 3,
                    blurRadius: 9,
                    offset: Offset(0,
                        widget.btnElevation ?? 0), // changes position of shadow
                  ),
                ],
                shape: widget.keyboardButtonShape == KeyboardButtonShape.circlar
                    ? BoxShape.circle
                    : BoxShape.rectangle),
            child: Text(
              number,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.btnTextColor ?? Colors.black,
                  fontSize: _sizeW * 0.05),
            ),
          ),
        ),
      ),
    );
  }

  void btnClicked(String btnText) {
    if (res.length < widget.pinInputController.length) {
      setState(() {
        res = res + btnText;
        widget.pinInputController.changeText(res);
        // textToDisplay = res;
      });
    }
    if (res.length >= widget.pinInputController.length) {
      widget.onSubmit();
      setState(() {
        errorText = '';
      });
    }
  }

  Widget inputWidget(int position) {
    try {
      return Container(
        height: widget.inputSize ?? MediaQuery.of(context).size.width * 0.1,
        width: widget.inputSize ?? MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
            border: widget.inputHasBorder == false
                ? null
                : Border.all(
                    color: widget.inputBorderColor ?? Colors.black,
                    width: widget.inputBorderThickness ?? 0),
            color: widget.isInputHidden == true
                ? widget.inputHiddenColor
                : Colors.transparent,
            borderRadius: widget.inputShape == InputShape.rounded
                ? const BorderRadius.all(Radius.circular(100))
                : null,
            boxShadow: [
              BoxShadow(
                color: widget.inputElevation == null
                    ? Colors.transparent
                    : widget.inputShadowColor?.withOpacity(0.6) ??
                        widget.inputFillColor?.withOpacity(0.6) ??
                        Colors.black.withOpacity(0.6),
                spreadRadius: 3,
                blurRadius: 9,
                offset: Offset(0,
                    widget.inputElevation ?? 0), // changes position of shadow
              ),
            ],
            shape: widget.inputShape == InputShape.circlar
                ? BoxShape.circle
                : BoxShape.rectangle),
        child: Center(
            child: Text(
          res[position],
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: widget.isInputHidden == true
                ? widget.inputHiddenColor
                : widget.inputTextColor ?? Colors.black,
          ),
        )),
      );
    } catch (e) {
      return Container(
        height: widget.inputSize ?? MediaQuery.of(context).size.width * 0.1,
        width: widget.inputSize ?? MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
            color: widget.inputFillColor ?? Colors.transparent,
            border: widget.inputHasBorder == false
                ? null
                : Border.all(
                    color: widget.inputBorderColor ?? Colors.black,
                    width: widget.inputBorderThickness ?? 0),
            borderRadius: widget.inputShape == InputShape.rounded
                ? const BorderRadius.all(Radius.circular(100))
                : null,
            boxShadow: [
              BoxShadow(
                color: widget.inputElevation == null
                    ? Colors.transparent
                    : widget.inputShadowColor?.withOpacity(0.6) ??
                        widget.inputFillColor?.withOpacity(0.6) ??
                        Colors.black.withOpacity(0.6),
                spreadRadius: 3,
                blurRadius: 9,
                offset: Offset(0,
                    widget.inputElevation ?? 0), // changes position of shadow
              ),
            ],
            shape: widget.inputShape == InputShape.circlar
                ? BoxShape.circle
                : BoxShape.rectangle),
      );
    }
  }

  Widget customKeyboard({required Size size}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: size.width * (widget.keyboardMaxWidth / 100),
      ),

      // width: _sizeW * 0.6,
      // height: _sizeH * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              keyboardButtons("1"),
              keyboardButtons("2"),
              keyboardButtons("3"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              keyboardButtons("4"),
              keyboardButtons("5"),
              keyboardButtons("6"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              keyboardButtons("7"),
              keyboardButtons("8"),
              keyboardButtons("9"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    if (res.length >= widget.pinInputController.length) {
                      widget.onSubmit();
                      setState(() {
                        errorText = '';
                      });
                    } else {
                      setState(() {
                        errorText = 'Please fill all fields';
                      });
                    }
                  },
                  // ignore: prefer_const_constructors
                  icon: Icon(
                    Icons.done,
                    color: Colors.black,
                  ),
                ),
              ),
              keyboardButtons("0"),
              //  keyboardButtons("X"),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    // ignore: prefer_is_empty
                    if (res.length > 0) {
                      setState(() {
                        res = res.substring(0, res.length - 1);
                        widget.pinInputController.changeText(res);
                      });
                    }
                  },
                  // ignore: prefer_const_constructors
                  icon: Icon(
                    Icons.backspace,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
