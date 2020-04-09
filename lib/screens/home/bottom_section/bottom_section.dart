import 'package:flutter/material.dart';
import 'package:ytsdesktop/screens/home/bottom_section/search_box/search_box.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';

class BottomSection extends StatelessWidget {
  final ScreenDimension _dimension = ScreenDimension.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Container(
               height: _dimension.height,
               width: _dimension.width,
               color: Colors.white,
             )
             
            ],
          ),

          ///for search box
          Positioned(
            top: 20,
            left: _dimension.percent(value: 25, isHeight: null),
            child: SearchBox(),
          )
        ],
      ),
    );
  }
}
