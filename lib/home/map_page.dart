import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final lat;
  final lng;

  const MapPage({Key? key, this.lat, this.lng}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    if (widget.lat != null && widget.lng != null) {
      double? lat = double.tryParse(widget.lng);
      double? lng = double.tryParse(widget.lat);

      if (lat != null && lng != null) {
        _currentLocation = LatLng(lat, lng);
        print('Current LatLng position is: $_currentLocation');
      } else {
        print('Error: Invalid latitude and longitude format');
        //use default location if parsing fails
        _currentLocation = LatLng(lat!, lng!);
      }
    } else {
      print('Lat are Lng are null. Using default location.');
      _currentLocation = LatLng(37.4223, -122.0848);
    }
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentLocation,
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: MarkerId('currentLocation'),
          icon: BitmapDescriptor.defaultMarker,
          position: _currentLocation,
        ),
      },
    ),
  );
}}
