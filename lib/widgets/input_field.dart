import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;

  final Function(String) onChanged;
  //final TextEditingController controller;

  const InputField({
    super.key,
    required this.icon,
    required this.hint,
    required this.obscure,
    required this.stream,
    required this.onChanged
    //required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: stream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            //controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              //contentPadding: const EdgeInsets.fromLTRB(5, 30, 30, 30),
              hintText: hint,
              icon: Icon(icon),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pinkAccent),
              ),
            ),
            style: const TextStyle(color: Colors.black),
            obscureText: obscure,
          ),
        );
      },
    );
  }
}
