import 'package:flutter/material.dart';

class AuthTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  const AuthTextInput(
      {Key? key,
      required this.controller,
      this.hintText,
      this.validator,
      this.keyboardType,
      this.obscureText = false})
      : super(key: key);

  @override
  State<AuthTextInput> createState() => _AuthTextInputState();
}

class _AuthTextInputState extends State<AuthTextInput> {
  bool _passwordvisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey, width: .75)),

      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(
        ),
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 9,height: .3),
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle( fontSize: 13),
          contentPadding: const EdgeInsets.only(left: 20,top: 12),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordvisible = !_passwordvisible;
                    });
                  },
                  icon: Icon(
                    _passwordvisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText ? !_passwordvisible : false,
      ),
    );
  }
}
