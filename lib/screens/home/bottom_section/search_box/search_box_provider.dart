import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';

class SearchBoxProvider with ChangeNotifier {
  static ScreenDimension _dimension = ScreenDimension.instance;

  Widget _searchWidget = Container();
  Widget get searchWidget => _searchWidget;
  set setSearchWidget(Widget wd) {
    this._searchWidget = wd;
    notifyListeners();
  }

 
}
