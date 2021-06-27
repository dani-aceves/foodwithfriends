import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodwithfriends/models/geometry.dart';
import 'package:foodwithfriends/models/location.dart';
import 'package:foodwithfriends/models/place.dart';
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
  StreamController<Place> selectedLocation = StreamController<Place>();
  Place selectedLocationStatic;
  String placeType;

  AppBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
          lat: currentLocation.latitude,
          lng: currentLocation.longitude,
        ),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng,
          placeType);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }
}
