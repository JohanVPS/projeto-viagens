import 'package:flutter/material.dart';
import 'package:viagens/widgets/cores.dart';

InputDecoration inputDec(
  String label, 
  IconData? icone, {
  bool isPassword = false,
  VoidCallback? toggleVisibility,
  bool isPasswordVisible = false,
}) {
  return InputDecoration(
    prefixIcon: Icon(icone, color: Colors.grey.shade400),
    labelText: label,
    labelStyle: TextStyle(color: Colors.grey.shade400),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 2.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 2.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: corBranca(),
        width: 3.0,
      ),
    ),
    suffixIcon: isPassword
        ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: corCinzaClaro(),
            ),
            onPressed: toggleVisibility,
          )
        : null,
  );
}