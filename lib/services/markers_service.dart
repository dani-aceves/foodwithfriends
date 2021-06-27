import 'package:foodwithfriends/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerService {
  LatLngBounds bounds(Set<Marker> markers) {
    if (markers == null || markers.isEmpty) return null;
    return createBounds(markers.map((mark) => mark.position).toList());
  }

  LatLngBounds createBounds(List<LatLng> positions) {
    final swlat = positions
        .map((pos) => pos.latitude)
        .reduce((value, elem) => value < elem ? value : elem); //smallest
    final swlng = positions
        .map((pos) => pos.longitude)
        .reduce((value, elem) => value < elem ? value : elem);
    final nelat = positions
        .map((pos) => pos.latitude)
        .reduce((value, elem) => value > elem ? value : elem); //largest
    final nelng = positions
        .map((pos) => pos.longitude)
        .reduce((value, elem) => value > elem ? value : elem);
    return LatLngBounds(
      southwest: LatLng(
        swlat,
        swlng,
      ),
      northeast: LatLng(
        nelat,
        nelng,
      ),
    );
  }

  Marker createMarkerFromPlace(Place place, bool center) {
    var markerId = place.name;

    if (center) markerId = 'center';
    return Marker(
      markerId: MarkerId(markerId),
      draggable: false,
      infoWindow: InfoWindow(
        title: markerId,
        snippet: place.vicinity,
      ),
      position: LatLng(
        place.geometry.location.lat,
        place.geometry.location.lng,
      ),
    );
  }
}
