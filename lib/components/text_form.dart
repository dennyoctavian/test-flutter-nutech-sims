import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormCustom extends StatefulWidget {
  final bool isObscure;
  final String placeholder;
  final TextEditingController controller;
  final Icon prefixIcon;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChange;
  final List<TextInputFormatter>? formatters;
  final TextInputType keyboardType;
  final bool readOnly;
  const TextFormCustom(this.placeholder, this.controller, this.prefixIcon,
      {super.key,
      this.isObscure = false,
      this.validator,
      this.formatters,
      this.keyboardType = TextInputType.text,
      this.onChange,
      this.readOnly = false});

  @override
  State<TextFormCustom> createState() => _TextFormCustomState();
}

class _TextFormCustomState extends State<TextFormCustom> {
  bool isHide = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      controller: widget.controller,
      obscureText: widget.isObscure ? isHide : false,
      validator: widget.validator,
      onChanged: widget.onChange,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: widget.formatters,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.placeholder,
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isObscure
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isHide = !isHide;
                  });
                },
                child: isHide
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.remove_red_eye_outlined),
              )
            : null,
      ),
    );
  }
}
