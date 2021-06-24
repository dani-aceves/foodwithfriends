import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);
  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("D"),
          position: LatLng(37.77483, -122.41942),
          infoWindow: InfoWindow(
            title: "San Francisco",
            snippet: "A cool City",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.77483, -122.41942),
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }
}
