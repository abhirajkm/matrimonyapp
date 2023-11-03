import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final Color? color;
  final Color? borderColor;
  final double radius;
  final bool loading;
  final double height;
  final TextStyle? buttonStyle;
  const Button({Key? key, required this.title, this.onPressed, this.color=Colors.purple, this.borderColor, required this.radius, required this.loading, this.buttonStyle, this.height=50.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(
            color!
        )),
        onPressed: onPressed,
        child:  loading ? const SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1.5,
          ),
        ):Text(title, style:buttonStyle ?? Theme
            .of(context)
            .textTheme
            .button,),
      ),
    );
  }
}
