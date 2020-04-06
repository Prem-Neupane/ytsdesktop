import 'package:flutter/material.dart';

class TopDownloadsProvider with ChangeNotifier {
  bool _init=false;
  get hasInit=>_init;
  set setInit(bool value){
    _init=value;
  }
  String _currentButton = '1';
  set setCurrentButton(String id) {
    _currentButton = id;
    notifyListeners();
  }

  Color getButtonColor(String id) =>
      _currentButton == id ? Colors.green[700] : Colors.white;
  Color getButtonTextColor(String id) =>
      _currentButton == id ? Colors.white : Colors.green[900];

  ///
  ///title
  List<String> _title = [];
  List<String> get title => _title;
  set setTitleList(List<String> titleList) {
    _title = titleList;
    notifyListeners();
  }

  ///
  ///description
  List<String> _description = [];
  List<String> get description => _description;
  set setDescriptionList(List<String> list) {
    _description = list;
    notifyListeners();
  }

  ///
  ///genre
  List<String> _genre = [];
  List<String> get genre => _genre;
  set setGenreList(List<String> list) {
    _genre = list;
    notifyListeners();
  }

  ///
  ///rating
  List<String> _rating = [];
  List<String> get rating => _rating;
  set setRatingList(List<String> list) {
    _title = list;
    notifyListeners();
  }
   ///
  ///image urls
  List<String> _urls = [];
  List<String> get urls => _urls;
  set setUrlList(List<String> list) {
    _urls = list;
    notifyListeners();
  }

  ///
  ///image
  Image _image;
  Image get image => _image;
  set setImage(String url) {
    _image = Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loaded) {
        if (loaded == null) return child;
        return loaded != null
            ? Center(
                child: CircularProgressIndicator(
                  value:
                      loaded.cumulativeBytesLoaded / loaded.expectedTotalBytes,
                ),
              )
            : null;
      },
    );
  }
}
