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

List<BoxShadow> normalShadow({Color color,Offset offset}) {
  return [
    BoxShadow(
        color: color != null ? color : Colors.grey[300],
        offset: offset!=null?offset:Offset(1.5, 1.5),
        blurRadius: 2,
        spreadRadius: 0.3)
  ];
}
