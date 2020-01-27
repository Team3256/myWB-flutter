import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mywb_flutter/utils/theme.dart';

class ScoutingPage extends StatefulWidget {
  @override
  _ScoutingPageState createState() => _ScoutingPageState();
}

class _ScoutingPageState extends State<ScoutingPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        new CupertinoSliverNavigationBar(
          backgroundColor: mainColor,
          largeTitle: new Text("Scouting", style: TextStyle(color: Colors.white),),
          actionsForegroundColor: Colors.white,
        ),
        new SliverList(
          delegate: new SliverChildListDelegate([
            new Container(
              padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
              child: new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: new Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 16,
                  child: new GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(48.431541, -123.360401),
                        zoom: 11.0
                    ),
                    compassEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    markers: Set<Marker>.from([
                      Marker(
                          markerId: MarkerId("2020bcvi"),
                          position: LatLng(48.431541, -123.360401),
                          infoWindow: InfoWindow(title: "Canada Pacific Regional")
                      )
                    ]),
                  ),
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: new Center(
                  child: new Text(
                    "It doesn't look like you are currently at a regional\nPlease check back later for scouting",
                    textAlign: TextAlign.center,
                  ),
                ),
            ),
          ]),
        )
      ],
    );
  }
}
