import 'package:flutter/material.dart';
import 'package:foodwithfriends/models/place_search.dart';
import 'package:foodwithfriends/services/geolocator_service.dart';
import 'package:foodwithfriends/services/places_service.dart';
import 'package:geolocator/geolocator.dart';

class AppBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();

  //variables
  Position currentLocation;
  List<PlaceSearch> searchResults;

  AppBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}
