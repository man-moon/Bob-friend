import 'package:bobfriend/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '로그아웃',
              style: TextStyle(color: Palette.textColor1),
            ),
            IconButton(
                onPressed: () {
                  _authentication.signOut();
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: Palette.textColor1,
                )
            ),
          ]
      ),
    );
  }



  // final double _initFabHeight = 120.0;
  // double _fabHeight = 0;
  // double _panelHeightOpen = 0;
  // double _panelHeightClosed = 95.0;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _fabHeight = _initFabHeight;
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   _panelHeightOpen = MediaQuery.of(context).size.height * .80;
  //
  //   return Material(
  //     child: Stack(
  //       alignment: Alignment.topCenter,
  //       children: <Widget>[
  //         SlidingUpPanel(
  //           maxHeight: _panelHeightOpen,
  //           minHeight: _panelHeightClosed,
  //           parallaxEnabled: true,
  //           parallaxOffset: .5,
  //           body: _body(),
  //           panelBuilder: (sc) => _panel(sc),
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(18.0),
  //               topRight: Radius.circular(18.0)),
  //           onPanelSlide: (double pos) => setState(() {
  //             _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
  //                 _initFabHeight;
  //           }),
  //         ),
  //
  //         // the fab
  //         Positioned(
  //           right: 20.0,
  //           bottom: _fabHeight,
  //           child: FloatingActionButton(
  //             child: Icon(
  //               Icons.gps_fixed,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //             onPressed: () {},
  //             backgroundColor: Colors.white,
  //           ),
  //         ),
  //
  //         Positioned(
  //             top: 0,
  //             child: ClipRRect(
  //                 child: BackdropFilter(
  //                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //                     child: Container(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: MediaQuery.of(context).padding.top,
  //                       color: Colors.transparent,
  //                     )))),
  //
  //         //the SlidingUpPanel Title
  //         Positioned(
  //           top: 52.0,
  //           child: Container(
  //             padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 18.0),
  //             child: Text(
  //               "SlidingUpPanel Example",
  //               style: TextStyle(fontWeight: FontWeight.w500),
  //             ),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(24.0),
  //               boxShadow: [
  //                 BoxShadow(
  //                     color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _panel(ScrollController sc) {
  //   return MediaQuery.removePadding(
  //       context: context,
  //       removeTop: true,
  //       child: ListView(
  //         controller: sc,
  //         children: <Widget>[
  //           SizedBox(
  //             height: 12.0,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Container(
  //                 width: 30,
  //                 height: 5,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.all(Radius.circular(12.0))),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 18.0,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Text(
  //                 "Explore Pittsburgh",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.normal,
  //                   fontSize: 24.0,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 36.0,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               _button("Popular", Icons.favorite, Colors.blue),
  //               _button("Food", Icons.restaurant, Colors.red),
  //               _button("Events", Icons.event, Colors.amber),
  //               _button("More", Icons.more_horiz, Colors.green),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 36.0,
  //           ),
  //           Container(
  //             padding: const EdgeInsets.only(left: 24.0, right: 24.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Text("Images",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                     )),
  //                 SizedBox(
  //                   height: 12.0,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     CachedNetworkImage(
  //                       imageUrl:
  //                       "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
  //                       height: 120.0,
  //                       width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
  //                       fit: BoxFit.cover,
  //                     ),
  //                     CachedNetworkImage(
  //                       imageUrl:
  //                       "https://cdn.pixabay.com/photo/2016/08/11/23/48/pnc-park-1587285_1280.jpg",
  //                       width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
  //                       height: 120.0,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 36.0,
  //           ),
  //           Container(
  //             padding: const EdgeInsets.only(left: 24.0, right: 24.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Text("About",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                     )),
  //                 SizedBox(
  //                   height: 12.0,
  //                 ),
  //                 Text(
  //                   'Hello',
  //                   softWrap: true,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 24,
  //           ),
  //         ],
  //       ));
  // }
  //
  // Widget _button(String label, IconData icon, Color color) {
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Icon(
  //           icon,
  //           color: Colors.white,
  //         ),
  //         decoration:
  //         BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
  //           BoxShadow(
  //             color: Color.fromRGBO(0, 0, 0, 0.15),
  //             blurRadius: 8.0,
  //           )
  //         ]),
  //       ),
  //       SizedBox(
  //         height: 12.0,
  //       ),
  //       Text(label),
  //     ],
  //   );
  // }
  //
  // Widget _body() {
  //   return FlutterMap(
  //     options: MapOptions(
  //       center: LatLng(40.441589, -80.010948),
  //       zoom: 13,
  //       maxZoom: 15,
  //     ),
  //     layers: [
  //       TileLayerOptions(
  //           urlTemplate: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png"),
  //       MarkerLayerOptions(markers: [
  //         Marker(
  //             point: LatLng(40.441753, -80.011476),
  //             builder: (ctx) => Icon(
  //               Icons.location_on,
  //               color: Colors.blue,
  //               size: 48.0,
  //             ),
  //             height: 60),
  //       ]),
  //     ],
  //   );
  // }
}
