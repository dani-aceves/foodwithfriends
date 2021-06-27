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
  StreamSubscription locationSubscription;

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
  void initState() {
    final applicationBloc = Provider.of<AppBloc>(context, listen: false);
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc = Provider.of<AppBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

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
                          onMapCreated: (GoogleMapController controller) {
                            _mapController.complete(controller);
                          }),
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
                              onTap: () {
                                applicationBloc.setSelectedLocation(
                                    applicationBloc
                                        .searchResults[index].placeId);
                              },
                            );
                          },
                        ),
                      )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Filter Nearest',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: [
                      FilterChip(
                        label: Text('Campground'),
                        onSelected: (val) =>
                            applicationBloc.togglePlaceType('campground', val),
                        selected: applicationBloc.placeType == 'campground',
                        selectedColor: Colors.red,
                      ),
                      FilterChip(
                        label: Text('Restaurant'),
                        onSelected: (val) =>
                            applicationBloc.togglePlaceType('restaurant', val),
                        selected: applicationBloc.placeType == 'restaurant',
                        selectedColor: Colors.orange,
                      ),
                      FilterChip(
                        label: Text('Bar'),
                        onSelected: (val) =>
                            applicationBloc.togglePlaceType('bar', val),
                        selected: applicationBloc.placeType == 'bar',
                        selectedColor: Colors.yellow,
                      ),
                      FilterChip(
                        label: Text('Cafe'),
                        onSelected: (val) =>
                            applicationBloc.togglePlaceType('cafe', val),
                        selected: applicationBloc.placeType == 'cafe',
                        selectedColor: Colors.green,
                      ),
                      FilterChip(
                        label: Text('Delivery'),
                        onSelected: (val) => applicationBloc.togglePlaceType(
                            'meal_delivery', val),
                        selected: applicationBloc.placeType == 'meal_delivery',
                        selectedColor: Colors.blue,
                      ),
                      FilterChip(
                        label: Text('Takeout'),
                        onSelected: (val) => applicationBloc.togglePlaceType(
                            'meal_takeaway', val),
                        selected: applicationBloc.placeType == 'meal_takeaway',
                        selectedColor: Colors.purple,
                      ),
                    ],
                  ),
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
