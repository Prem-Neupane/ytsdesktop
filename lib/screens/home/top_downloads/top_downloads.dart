import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytsdesktop/api/accepted_parameter_types.dart';
import 'package:ytsdesktop/api/endpoints.dart';
import 'package:ytsdesktop/screens/detailed_page/detailed_page.dart';
import 'package:ytsdesktop/screens/home/top_downloads/top_downloads_provider.dart';
import 'package:ytsdesktop/utils/custom_shadows.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';

class TopDownloads extends StatelessWidget {
  final List<Color> colorList = [
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.green,
    Colors.deepOrange,
    Colors.cyan,
    Colors.indigo,
    Colors.amber[900],
    Colors.pink,
    Colors.yellow,
    Colors.deepPurpleAccent
  ];
  final ScreenDimension _dimension = ScreenDimension.instance;

  ///api call
  _apiCall(TopDownloadsProvider provider) async {
    Random rnd = Random();
    http.Response response = await EndPoint.moviesList(
        limit: 5,
        page: rnd.nextInt(200),
        sortBy: AcceptedParameters.sortbydownloadcount);
    if (response.statusCode == 200) {
      Map<String, dynamic> _decoded = convert.jsonDecode(response.body);
      List<String> images = [];
      List<String> title = [];
      List<List<dynamic>> genres = [];
      List<String> description = [];
      provider.setMovieList = _decoded['data']['movies'];
      for (var each in _decoded['data']['movies']) {
        images.add(each['medium_cover_image']);
        title.add(each['title_long']);
        description.add(each['description_full']);
        genres.add(each['genres']);
      }
      //fill providers
      provider.setUrlList = images;
      provider.setTitleList = title;
      provider.setDescriptionList = description;
      provider.setGenreList = genres;

      ///
      ///
      provider.setImage = provider.urls[0];
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TopDownloadsProvider(),
      child: Builder(
        builder: (context) {
          TopDownloadsProvider _topDownloadsProvider =
              Provider.of<TopDownloadsProvider>(context);

          if (_topDownloadsProvider.hasInit == false) {
            _topDownloadsProvider.setInit = true;
            // _apiCall(_topDownloadsProvider);
          }
          return Stack(
            children: [
              ///for movie image in background

              Container(
                  width: _dimension.percent(value: 100, isHeight: null),
                  height: _dimension.percent(value: 70, isHeight: true),
                  child: _topDownloadsProvider.image),

              //popular downloads Text
              Positioned(
                top: 0,
                left: _dimension.percent(value: 25, isHeight: null),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black,
                              Colors.transparent
                            ],
                            stops: [
                              0.1,
                              0.5,
                              0.9
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    width: _dimension.percent(value: 50, isHeight: false),
                    child: _popularDownloads()),
              ),

              ///transparent layer below movie details
              Positioned(
                bottom: 0,
                left: 0,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: _dimension.percent(value: 45, isHeight: true),
                    width: _dimension.percent(value: 40, isHeight: false),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 5,
                              color: Colors.black,
                              offset: Offset(10, -10))
                        ],
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20))),
                  ),
                ),
              ),

              ///
              ///for movie details
              Positioned(
                child: _movieDetails(
                    provider: _topDownloadsProvider, context: context),
                left: 0,
                bottom: 0,
              ),

              ///for page buttons
              Positioned(
                bottom: 10,
                left: _dimension.percent(value: 25, isHeight: null),
                child: Container(
                  alignment: Alignment.center,
                  width: _dimension.percent(value: 50, isHeight: false),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 1; i < 6; i++)
                        _eachMovieButton(
                            provider: _topDownloadsProvider,
                            buttonId: i.toString())

                      ///each button to choose movie
                    ],
                  ),
                ),
              ),

              ///for refresh button
              Positioned(
                right: 0,
                top: 0,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  hoverColor: Colors.green,
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _apiCall(_topDownloadsProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ///
  ///returns movie details like description
  ///title genre etc
  Widget _movieDetails(
      {@required TopDownloadsProvider provider, BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10),
      height: _dimension.percent(value: 45, isHeight: true),
      width: _dimension.percent(value: 40, isHeight: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///for title
          InkWell(
            onTap: () {
              Map<String, dynamic> _currentMap =
                  provider.movieList[int.parse(provider.currentButton) - 1];
              //goto detailed page to download the movie
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailedPage(
                            titleShort: _currentMap['title'],
                            descriptionFull: _currentMap['description_full'],
                            rating:
                                double.parse(_currentMap['rating'].toString()),
                            runtime: _currentMap['runtime'],
                            year: _currentMap['year'],
                            torrents: _currentMap['torrents'],
                            imageUrl: _currentMap['medium_cover_image'],
                            genres: _currentMap['genres'],
                          )));
            },
            child: SizedBox(
              height: _dimension.percent(value: 10, isHeight: true),
              child: Text(
                provider.title[int.parse(provider.currentButton) - 1],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    shadows: textShadow(color: Colors.green)),
              ),
            ),
          ),

          ///for list of genre
          SizedBox(
            height: _dimension.percent(value: 5, isHeight: true),
            width: _dimension.percent(value: 50, isHeight: null),
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0;
                    i <
                        provider.genre[int.parse(provider.currentButton) - 1]
                            .length;
                    i++)
                  _genreChip(colorList[i],
                      provider.genre[int.parse(provider.currentButton) - 1][i])
              ],
            ),
          ),

          ///for description
          SizedBox(
            width: _dimension.percent(value: 40, isHeight: null),
            height: _dimension.percent(value: 25, isHeight: true),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                provider.description[int.parse(provider.currentButton) - 1],
                overflow: TextOverflow.fade,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: textShadow(color: Colors.black)),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///returns genre
  Widget _genreChip(Color color, String label) {
    return Container(
      padding: EdgeInsets.only(right: 5),
      child: Chip(
          backgroundColor: color,
          label: Text(
            label,
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          )),
    );
  }

  ///returns each movie button at bottom
  Widget _eachMovieButton({
    @required TopDownloadsProvider provider,
    @required String buttonId,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: provider.getButtonColor(buttonId),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: InkWell(
          onHover: (value) {
            if (value == true) {}
          },
          borderRadius: BorderRadius.circular(100),
          hoverColor: Colors.green[700],
          child: Container(
            alignment: Alignment.center,
            width: _dimension.percent(value: 5, isHeight: null),
            height: _dimension.percent(value: 5, isHeight: null),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Text(
              buttonId,
              style: TextStyle(
                  color: provider.getButtonTextColor(buttonId),
                  fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () {
            provider.setCurrentButton = buttonId;
            provider.setImage = provider.urls[int.parse(buttonId) - 1];
          },
        ),
      ),
    );
  }

  ///returns poppular downloads text
  Text _popularDownloads() {
    return Text('Top Downloads',
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 40,
            shadows: textShadow(color: Colors.grey[200])));
  }
}
