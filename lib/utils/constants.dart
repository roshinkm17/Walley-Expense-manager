import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

//Colors
const darkYellow = Color(0xffbf9800);
const darkRed = Color(0xfff05454);
const lightYellow = Color(0xffffeead);
const black = Color(0xff3f3f3f);
const darkGreen = Color(0xff557c55);
const lightBlack = Color(0xffa0a0a0);

//SnackBar
showSnackBar(String title, String message) {
  return Get.snackbar(
    title,
    message,
    animationDuration: Duration(milliseconds: 500),
    borderRadius: 5,
    icon: Icon(Icons.error, color: Colors.red),
    backgroundColor: Colors.white,
    // borderColor: darkRed,
  );
}

const List<String> accountEmojis = [
  "👛",
  "🐖",
  "🏦",
  "🤑",
  "💰",
  "💴",
  "💵",
  "💶",
  "💳",
  "🔐",
  "👩🏼‍🤝‍👨🏻",
  "🌄",
  "🎯",
  "⚖️",
  "⚔️",
  "♀️",
  "♂️",
  "⚧️",
  "🚬",
  "🏷️",
  "📈",
  "🍽️",
  "🍺",
  "⛔",
  "🚫",
  "❗",
  "♻️"
];
