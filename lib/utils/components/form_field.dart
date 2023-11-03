import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    Key? key,
    required TextEditingController controller,
    required this.titleHint,
    this.enabled = true,
    required this.hint,
    required this.formatter,
    this.validator,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final String titleHint;
  final String hint;
  final bool enabled;
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleHint,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          controller: _controller,
          inputFormatters: [formatter],
          validator: validator ?? (value) {},
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: enabled,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}