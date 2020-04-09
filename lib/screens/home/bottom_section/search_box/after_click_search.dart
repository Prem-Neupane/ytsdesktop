import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytsdesktop/api/endpoints.dart';
import 'package:ytsdesktop/screens/detailed_page/detailed_page.dart';
import 'package:ytsdesktop/screens/home/bottom_section/search_box/search_box_provider.dart';
import 'package:ytsdesktop/utils/custom_shadows.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AfterClickSearch extends StatefulWidget {
  final SearchBoxProvider provider;
  AfterClickSearch(this.provider);
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
            height: _dimension.percent(value: 70, isHeight: true),
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
                        cursorColor: Colors.green,
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        autofocus: true,
                        onChanged: (val) {
                          if (val == '') {
                            _provider.setSearchBodyList = [Container()];
                          } else {
                            ///show loading until results are ready
                            ///
                            _provider.setSearchBodyList = [
                              Center(child: CircularProgressIndicator())
                            ];

                            ///
                            ///

                            ///call api
                            apiCall(queryTerm: val, provider: _provider);
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_up,
                              size: 30,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              widget.provider.setSearchWidget = InkWell(
                                  onTap: () {
                                    widget.provider.setSearchWidget =
                                        AfterClickSearch(widget.provider);
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: _showOnlySearch());
                            },
                          ),
                          hintText: 'Enter Movie Name',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                        ),
                      )),
                ),

                ///for result
                Container(
                  width: _dimension.percent(value: 50, isHeight: null),
                  height: _dimension.percent(value: 60, isHeight: true),
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

  void apiCall(
      {@required String queryTerm, AfterClickSearchProvider provider}) async {
    http.Response response =
        await EndPoint.moviesList(queryTerm: queryTerm, limit: 50);

    /// if successful
    ///
    if (response.statusCode == 200) {
      Map<String, dynamic> _decoded = convert.jsonDecode(response.body);
      List<Widget> _tempList = List();
      if (_decoded['data']['movie_count'] > 0) {
        for (var each in _decoded['data']['movies']) {
          _tempList.add(_eachSuggestion(
              imageUrl: each['medium_cover_image'],
              titleShort: each['title'],
              descriptionFull: each['description_full'],
              rating: double.parse(each['rating'].toString()),
              runtime: each['runtime'],
              year: each['year'],
              torrents: each['torrents'],
              genres: each['genres']));
        }
      } else {
        _tempList = [
          Center(
            child: Text(
              'No results!!!',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ];
      }
      provider.setSearchBodyList = _tempList;
    }
  }

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

  ///this is single widget for suggestion.
  ///contains movie name and is clickable
  Widget _eachSuggestion(
      {@required String imageUrl,
      @required String titleShort,
      @required String descriptionFull,
      @required double rating,
      @required int runtime,
      @required int year,
      @required List<dynamic> torrents,
      @required List<dynamic> genres}) {
    return Container(
      child: InkWell(
        onTap: () {
          //goto detailed page to download the movie
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedPage(
                        imageUrl: imageUrl,
                        titleShort: titleShort,
                        descriptionFull: descriptionFull,
                        rating: rating,
                        runtime: runtime,
                        year: year,
                        torrents: torrents,
                        genres: genres,
                      )));
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Row(
              children: <Widget>[
                ///for image
                ///
                SizedBox(
                  width: _dimension.percent(value: 10, isHeight: null),
                  height: _dimension.percent(value: 20, isHeight: true),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loaded) {
                      if (loaded == null) {
                        return child;
                      }
                      return loaded != null
                          ? Center(
                              child: CircularProgressIndicator(
                                value: loaded.cumulativeBytesLoaded /
                                    loaded.expectedTotalBytes,
                              ),
                            )
                          : null;
                    },
                  ),
                ),

                ///
                ///
                ///for title
                Text(
                  titleShort,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
        ),
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

  ///each typed letter on search box will
  ///call and endpoint. this trigger is to
  ///ctrl if fetched list of suggestion should
  ///be added to list or not
  bool _shouldRefreshSuggestion = false;
  bool get shouldRefreshSuggestion => _shouldRefreshSuggestion;
  set setShouldRefreshSuggestion(bool val) {
    this._shouldRefreshSuggestion = val;
  }
}
