import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytsdesktop/utils/custom_shadows.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';

class AfterClickSearch extends StatefulWidget {
  @override
  _AfterClickSearchState createState() => _AfterClickSearchState();
}

class _AfterClickSearchState extends State<AfterClickSearch> {
  ScreenDimension _dimension = ScreenDimension.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AfterClickSearchProvider>(
      create: (context) => AfterClickSearchProvider(),
      child: Builder(
        builder: (context) {
          AfterClickSearchProvider _provider =
              Provider.of<AfterClickSearchProvider>(context);
          return Container(
            width: _dimension.percent(value: 50, isHeight: null),
            height: _dimension.percent(value: 50, isHeight: true),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: normalShadow(),
                color: Colors.white),
            child: Column(
              children: [
                ///for text field
                ///
                Container(
                  width: _dimension.percent(value: 50, isHeight: null),
                  height: _dimension.percent(value: 10, isHeight: true),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (val) {
                          if (val == '') {
                            _provider.setSearchBodyList = [Container()];
                          } else {
                            print(val);
                            _provider.setSearchBodyList = [
                              Center(child: CircularProgressIndicator())
                            ];
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter movie name.',
                          border: UnderlineInputBorder(),
                        ),
                      )),
                ),

                ///for result
                Container(
                  width: _dimension.percent(value: 50, isHeight: null),
                  height: _dimension.percent(value: 40, isHeight: true),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: _provider.searchBody,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

///provider
///
class AfterClickSearchProvider with ChangeNotifier {
  List<Widget> _searchBody = [Container()];
  List<Widget> get searchBody => _searchBody;
  set setSearchBodyList(List<Widget> list) {
    this._searchBody = list;
    notifyListeners();
  }
}
