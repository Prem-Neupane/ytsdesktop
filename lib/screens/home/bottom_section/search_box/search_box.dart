import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytsdesktop/screens/home/bottom_section/search_box/after_click_search.dart';
import 'package:ytsdesktop/screens/home/bottom_section/search_box/search_box_provider.dart';
import 'package:ytsdesktop/utils/custom_shadows.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool initShowSearch = false;
  ScreenDimension _dimension = ScreenDimension.instance;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchBoxProvider>(
      create: (context) => SearchBoxProvider(),
      child: Builder(
        builder: (context) {
          SearchBoxProvider _searchBoxProvider =
              Provider.of<SearchBoxProvider>(context);
          if (initShowSearch == false) {
            initShowSearch = true;
            Future.delayed(Duration(seconds: 1)).then((_) {
              _searchBoxProvider.setSearchWidget = InkWell(
                  onTap: () {
                    _searchBoxProvider.setSearchWidget =
                      AfterClickSearch(_searchBoxProvider);
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: _showOnlySearch());
            });
          }
          return _searchBoxProvider.searchWidget;
        },
      ),
    );
  }

  ///show only search box
  ///containing white box with search icon
  Widget _showOnlySearch() {
    return Container(
      alignment: Alignment.center,
      height: _dimension.percent(value: 8, isHeight: true),
      width: _dimension.percent(value: 50, isHeight: null),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: normalShadow()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              'Click to search for movies',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: Icon(
              Icons.search,
              color: Colors.green,
              size: 35,
            ),
          )
        ],
      ),
    );
  }

  
}
