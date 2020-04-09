import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ytsdesktop/screens/detailed_page/detailed_page_provider.dart';
import 'package:ytsdesktop/utils/custom_shadows.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';

class DetailedPage extends StatelessWidget {
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
  final String imageUrl, titleShort, descriptionFull;
  final double rating;
  final int runtime, year;
  final List torrents, genres;
  DetailedPage(
      {@required this.imageUrl,
      @required this.titleShort,
      @required this.descriptionFull,
      @required this.rating,
      @required this.runtime,
      @required this.year,
      @required this.torrents,
      @required this.genres});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailedPageProvider(),
      child: Builder(
        builder: (context) {
          DetailedPageProvider _detailedPageProvider =
              Provider.of<DetailedPageProvider>(context);

          return Scaffold(
            backgroundColor: Colors.green[800],
            body: Container(
              height: _dimension.percent(value: 100, isHeight: true),
              width: _dimension.percent(value: 100, isHeight: null),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.white,
                          Colors.green,
                          Colors.green[800]
                        ],
                            stops: [
                          0,
                          0.3,
                          0.9
                        ],
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter)),
                    height: _dimension.percent(value: 80, isHeight: true) + 10,
                    width: _dimension.percent(value: 100, isHeight: null),
                    child: Stack(
                      children: [
                        ///for bakc button
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            height:
                                _dimension.percent(value: 5, isHeight: true),
                            child: BackButton(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        ///movie image and year at left top
                        Positioned(
                          top: _dimension.percent(value: 10, isHeight: true),
                          left: 0,
                          child: _movieImage(provider: _detailedPageProvider),
                        ),

                        ///for extra info
                        Positioned(
                            top: _dimension.percent(value: 10, isHeight: true),
                            left: _dimension.percent(value: 30, isHeight: null),
                            child: _extraInfo(provider: _detailedPageProvider)),
                      ],
                    ),
                  ),

                  ///for movie suggestions and comments and reviews
                  Container(
                    height: _dimension.percent(value: 70, isHeight: true),
                    width: _dimension.percent(value: 100, isHeight: null),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///returns extra info like descriptions and other
  Widget _extraInfo({@required DetailedPageProvider provider}) {
    return Container(
      width: _dimension.percent(value: 70, isHeight: null),
      height: _dimension.percent(value: 70, isHeight: true),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //for movie title
            Text(
              titleShort,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.underline,
                  shadows: textShadow(color: Colors.black)),
            ),
            //for movie description
            Container(
              padding: EdgeInsets.only(top: 20),
              width: _dimension.percent(value: 70, isHeight: null),
              height: _dimension.percent(value: 40, isHeight: true),
              alignment: Alignment.topLeft,
              color: Colors.transparent,
              child: Text(
                descriptionFull,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: textShadow(color: Colors.black)),
              ),
            ),

            ///for genre
            Container(
              height: _dimension.percent(
                value: 6,
                isHeight: true,
              ),
              color: Colors.transparent,
              width: _dimension.percent(value: 70, isHeight: null),
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < genres.length; i++)
                    _genreChip(colorList[i], genres[i])
                ],
              ),
            ),
            //for ratings and download options
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///for rating and runtime
                Container(
                  width: _dimension.percent(value: 30, isHeight: null),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //rating
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.blue,
                              size: 20,
                            ),
                            RichText(
                                text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'Rating: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: rating.toString(),
                                  style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                      ),
                      //runtime
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              color: Colors.blue,
                              size: 20,
                            ),
                            RichText(
                                text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'Runtime: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '$runtime min',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                      )
                    ],
                  ),
                ),

                ///for download section
                _downloadSection(provider: provider),
              ],
            )
          ],
        ),
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

  ///returns download sections
  Widget _downloadSection({@required DetailedPageProvider provider}) {
    Map<String, dynamic> map720 = Map();
    Map<String, dynamic> map1080 = Map();
    Map<String, dynamic> map2160 = Map();
    Map<String, dynamic> map3d = Map();

    ///filter torrents
    for (Map<String, dynamic> each in torrents) {
      if (each['quality'] == '720p') {
        map720['size'] = each['size'];
        map720['torrent_url'] = each['url'];
      } else if (each['quality'] == '1080p') {
        map1080['size'] = each['size'];
        map1080['torrent_url'] = each['url'];
      } else if (each['quality'] == '3D') {
        map3d['size'] = each['size'];
        map3d['torrent_url'] = each['url'];
      } else {
        map2160['size'] = each['size'];
        map2160['torrent_url'] = each['url'];
      }
    }

    return Container(
      width: _dimension.percent(value: 40, isHeight: null) - 16,
      child: Row(
        children: [
          ///for 720p
          _eachCategory(
              quality: '720p',
              size: map720['size'],
              torrentUrl: map720['torrent_url']),

          ///for 1080p
          _eachCategory(
              quality: '1080p',
              size: map1080['size'],
              torrentUrl: map1080['torrent_url']),

          ///for 720p
          _eachCategory(
              quality: '2160p',
              size: map2160['size'],
              torrentUrl: map2160['torrent_url']),

          ///for 3d
          _eachCategory(
              quality: '3D',
              size: map3d['size'],
              torrentUrl: map3d['torrent_url']),
        ],
      ),
    );
  }

  ///each item download button
  Widget _eachCategory({String quality, String size, String torrentUrl}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      width: _dimension.percent(value: 9, isHeight: false),
      padding: EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            quality + ' ($size)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 10,
          ),
          Builder(
            builder: (context) => MaterialButton(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(
                Icons.file_download,
                color: Colors.green,
              ),
              onPressed: () {
                _fileDownload(
                    url: torrentUrl, quality: quality, context: context);
              },
            ),
          )
        ],
      ),
    );
  }

  ///file downloader
  _fileDownload({String url, String quality, BuildContext context}) async {
    Uint8List _torrentFile;

    await http.Client().get(Uri.parse(url)).then((response) {
      _torrentFile = response.bodyBytes;
    });

    File _file = File('../' + '$titleShort' + '_$quality' + '.torrent');
    _file..writeAsBytesSync(_torrentFile);
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              children: [
                Row(
                  children: [
                    Text('Download Complete',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 30,
                    )
                  ],
                ),
              ],
            ));
  }

  ///returns movie image and year at left
  Widget _movieImage({@required DetailedPageProvider provider}) {
    return Container(
      width: _dimension.percent(value: 30, isHeight: null),
      height: _dimension.percent(value: 70, isHeight: true),
      color: Colors.transparent,
      child: Column(
        children: [
          ///for image
          Container(
            // width: _dimension.percent(value: 30, isHeight: null),
            height: _dimension.percent(value: 66, isHeight: true),
            decoration: BoxDecoration(boxShadow: normalShadow(color: Colors.green[900],offset: Offset(3,3))),
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

          ///for year
          RichText(
            text: TextSpan(children: <InlineSpan>[
              TextSpan(
                text: 'Year: ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: textShadow(color: Colors.black)),
              ),
              TextSpan(
                text: year.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: textShadow(color: Colors.black)),
              )
            ]),
          )
        ],
      ),
    );
  }
}
