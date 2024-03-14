import 'package:flutter/material.dart';

InputDecoration decorationTextField(
    {required String hintText,
    required String labelText,
     Widget? prefixIcon}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: prefixIcon,
    hintText: hintText,
    filled: true,
    fillColor: Colors.white,
    // focusColor: Colors.red,

    labelStyle: const TextStyle(
        color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w300),
    hintStyle: const TextStyle(color: Colors.black45, fontSize: 13),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

InputDecoration decorationTextFieldUnderLine(
    {required String hintText}) {
  const color = Color(0xFF5F3113);
  return InputDecoration(
    // labelText: labelText,
    hintText: hintText,
    focusColor: Colors.red,
    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    labelStyle: const TextStyle(
        color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w300),
    hintStyle: const TextStyle(color: Colors.black45, fontSize: 15),
    // contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    enabledBorder:  UnderlineInputBorder(
     borderSide: BorderSide(color: color.withOpacity(.5)),
    ),
    focusedBorder:  UnderlineInputBorder(
      borderSide: BorderSide(color: color.withOpacity(.5)),
    ),
    border:  UnderlineInputBorder(
      borderSide: BorderSide(color: color.withOpacity(.5)),
    ),
    errorBorder:  UnderlineInputBorder(
       borderSide: BorderSide(color: color.withOpacity(.5)),
    ),
  );
}
