import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytsdesktop/screens/home/top_downloads/top_downloads_provider.dart';
import 'package:ytsdesktop/utils/custom_shadows.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';

class TopDownloads extends StatelessWidget {
  final ScreenDimension _dimension = ScreenDimension.instance;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TopDownloadsProvider(),
      child: Builder(
        builder: (context) {
          TopDownloadsProvider _topDownloadsProvider =
              Provider.of<TopDownloadsProvider>(context);
          return Container(
            decoration: BoxDecoration(color: Colors.green[700]),
            child: Stack(
              children: [
                //popular downloads Text
                Positioned(
                  top: 20,
                  left: _dimension.percent(value: 25, isHeight: null),
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      width: _dimension.percent(value: 50, isHeight: false),
                      child: _popularDownloads()),
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
                )
              ],
            ),
          );
        },
      ),
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
            if (value == true) {
              
            }
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
          },
        ),
      ),
    );
  }

  ///returns poppular downloads text
  Text _popularDownloads() {
    return Text('Popular Downloads',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
            shadows: textShadow(color: Colors.black)));
  }
}
