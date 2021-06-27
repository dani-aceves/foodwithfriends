import 'dart:async';
import 'dart:collection';
import 'package:foodwithfriends/blocs/app_blocs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/place.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);
  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();

  Completer<GoogleMapController> _mapController = Completer();

  // void _onMapCreated(GoogleMapController controller) {
  //   _mapController = controller;
  //   setState(() {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId("D"),
  //         position: LatLng(40.7128, 74.0060),
  //         infoWindow: InfoWindow(
  //           title: "San Francisco",
  //           snippet: "A cool City",
  //         ),
  //       ),
  //     );
  //     _setMapStyle();
  //   });
  // }

  // void _setMapStyle() async {
  //   String style = await DefaultAssetBundle.of(context)
  //       .loadString('assets/map_style.json');
  //   _mapController.setMapStyle(style);
  // }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      body: (applicationBloc.currentLocation == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for Food',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => applicationBloc.searchPlaces(value),
                    )),
                Stack(
                  children: [
                    Container(
                      height: 400.0,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              applicationBloc.currentLocation.latitude,
                              applicationBloc.currentLocation.longitude),
                          zoom: 14,
                        ),
                      ),
                    ),
                    if (applicationBloc.searchResults != null &&
                        applicationBloc.searchResults.length != 0)
                      Container(
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.darken,
                          color: Colors.black.withOpacity(.6),
                        ),
                      ),
                    if (applicationBloc.searchResults != null &&
                        applicationBloc.searchResults.length != 0)
                      Container(
                        height: 400.0,
                        child: ListView.builder(
                          itemCount: applicationBloc.searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                applicationBloc
                                    .searchResults[index].description,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      )
                  ],
                )
              ],
            ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(place.geometry.location.lat, place.geometry.location.lng),
          zoom: 14.0,
        ),
      ),
    );
  }
}
