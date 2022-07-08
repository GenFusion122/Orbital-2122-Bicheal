import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: false,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(),
  ),
  hintStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
  hintText: '.copywith(hintText: text)',
);

const textInputDecorationFormField = InputDecoration(
    filled: true,
    fillColor: Color(0xFFFFE0B2),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: const BorderRadius.all(const Radius.circular(10))),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: const BorderRadius.all(const Radius.circular(10))),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: const BorderRadius.all(const Radius.circular(10)),
    ));
