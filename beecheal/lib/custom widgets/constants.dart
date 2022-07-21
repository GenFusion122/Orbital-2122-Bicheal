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
    counterText: "",
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

const underlineInputBorderDecoration = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: const BorderRadius.all(const Radius.circular(10)));

const textFormFieldStyle = TextStyle(
    fontSize: 20.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const cardHeaderStyle = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const cardContentStyleBig =
    TextStyle(fontSize: 50, fontWeight: FontWeight.w900);

const cardContentStyleSmall = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis);

const buttonTextStyle = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const tileButtonTextStyle = TextStyle(
    fontSize: 15.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const viewHeaderTextStyle = TextStyle(
    fontSize: 15.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const viewBodyTextStyle = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const viewDateTextStyle = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const tileTitleStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w900,
    overflow: TextOverflow.ellipsis,
    color: Color(0xff000000));

const tileDescriptionStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w900,
    overflow: TextOverflow.ellipsis);

const tileDateStyle = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w900, color: Color(0xff000000));

const popupTextStyle = TextStyle(
    fontSize: 12.0, fontWeight: FontWeight.w900, color: Color(0xff000000));
