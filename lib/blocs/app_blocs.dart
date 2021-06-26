import 'package:flutter/material.dart';
import 'package:foodwithfriends/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';

class AppBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();

  //variables
  Position currentLocation;

  AppBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}
