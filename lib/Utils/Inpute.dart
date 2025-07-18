import 'package:flutter/material.dart';

InputDecoration customInputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
  );
}
