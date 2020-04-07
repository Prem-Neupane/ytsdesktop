import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytsdesktop/screens/home/bottom_section/bottom_section.dart';
import 'package:ytsdesktop/screens/home/home_provider.dart';
import 'package:ytsdesktop/screens/home/top_downloads/top_downloads.dart';
import 'package:ytsdesktop/utils/screen_dimension.dart';

class Home extends StatelessWidget {
  final ScreenDimension _dimension = ScreenDimension.instance;
  @override
  Widget build(BuildContext context) {
    _dimension.init(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      child: Builder(
        builder: (context) {
          HomeProvider _homeProvider = Provider.of<HomeProvider>(context);
          return Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                height: _dimension.height,
                width: _dimension.width,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ///top downloads
                    SizedBox(
                      height: _dimension.percent(value: 70, isHeight: true),
                      width: _dimension.width,
                      child: TopDownloads(),
                    ),
                    SizedBox(
                        // height: _dimension.percent(value: 70, isHeight: true),
                        width: _dimension.width,
                        child: BottomSection())
                  ],
                ),
              ));
        },
      ),
    );
  }
}
