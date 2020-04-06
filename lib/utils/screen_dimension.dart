
import 'package:flutter/foundation.dart';

class ScreenDimension {
  ScreenDimension.privateConstructor();
  static final ScreenDimension instance = ScreenDimension.privateConstructor();
  bool _hasInitialized = false;
  double _height, _width;
  init(double height, double width) {
    if(this._hasInitialized==false){
    _height = height;
    _width = width;}
    else{
      print("Dimension Already Initialized!!!");
    }
  }

  double percent({@required double value, @required bool isHeight}) =>
      isHeight==true ? _height * value / 100 : _width * value / 100;
  ///returns full height
  get height=>_height;
  /// returns full width
  get width=>_width;
}
