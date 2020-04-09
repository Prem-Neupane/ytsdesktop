import 'package:flutter/material.dart';

List<Shadow> textShadow({Color color}) {
  return [
    BoxShadow(
        color: color != null ? color : Colors.grey,
        offset: Offset(1, 1),
        blurRadius: 2,
        spreadRadius: 5)
  ];
}

List<BoxShadow> normalShadow({Color color}) {
  return [
    BoxShadow(
        color: color != null ? color : Colors.grey[300],
        offset: Offset(1, 1),
        blurRadius: 10,
        spreadRadius: 1.5)
  ];
}
