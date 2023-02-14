// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps/location.dart';
import 'package:google_maps/polyline_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_webservice/places.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(31.908137980134477, 35.92299565556362),
    zoom: 16.4746,
  );
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  BitmapDescriptor? _locationIcon;
  LatLng currentLocation = _initialCameraPosition.target;
  MapType maptype = MapType.normal;
  bool isSelected = false;

  @override
  void initState() {
    _buildMarkerFromAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            _setMarker(currentLocation);
          },
          child: Icon(Icons.add_location_alt_outlined)),
      appBar: AppBar(elevation: 0, actions: [
        Image.network(
          "https://www.adster.ca/wp-content/uploads/2013/04/google-maps.jpg",
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          width: 200,
        ),
        IconButton(
            onPressed: () {
              searchPlaces();
            },
            icon: Icon(Icons.search))
      ]),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              polylines: _polylines,
              indoorViewEnabled: true,
              zoomControlsEnabled: false,
              markers: _markers,
              // myLocationButtonEnabled: true,
              compassEnabled: true,
              buildingsEnabled: true,
              mapToolbarEnabled: true,
              mapType: maptype,
              onCameraMove: (e) => currentLocation = e.target,
              trafficEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/marker.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              isSelected ? Colors.blue : Colors.white)),
                      onPressed: () {
                        changeMapType();
                      },
                      child: Icon(
                        Icons.map_outlined,
                        color: isSelected ? Colors.white : Colors.blue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              myLocation = await LocationServices().getLocation();
              _drawPolyline(
                  LatLng(myLocation!.latitude!, myLocation!.longitude!),
                  currentLocation);
            },
            child: Icon(Icons.settings_ethernet_rounded),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: getMyLocation,
            child: Icon(Icons.my_location_rounded),
            tooltip: "Get my location ",
          ),
        ],
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  Future<void> searchPlaces() async {
    var p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyBLHghArJPOu5Pb9aAlCky_wqEd0FAFOBI",
      language: "ar",
      mode: Mode.overlay,
      region: "en",
      types: ["bank"],
      // decoration: InputDecoration(
      //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      overlayBorderRadius: BorderRadius.circular(20),
      components: [
        Component(Component.country, 'JO'),

        // Component(Component.country, 'SA')
      ],
      strictbounds: false,
    );

    _getLocationFromPlaceId(p!.placeId!);
  }

  LocationData? myLocation;
  Future<void> getMyLocation() async {
    myLocation = await LocationServices().getLocation();
    animateCamera2(myLocation!);
  }

  Future<void> animateCamera2(LocationData location) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPos = CameraPosition(
        target: LatLng(location.latitude!, location.longitude!), zoom: 18);
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPos));
  }

  Future<void> _buildMarkerFromAssets() async {
    if (_locationIcon == null) {
      _locationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'assets/images/location_icon.png');
      setState(() {});
    }
  }

  void _setMarker(LatLng _location) {
    Marker newMarker = Marker(
      markerId: MarkerId(_location.toString()),
      icon: BitmapDescriptor.defaultMarker,
      // icon: _locationIcon,
      position: _location,
      infoWindow: InfoWindow(
          title: "${_location}",
          snippet: "${currentLocation.latitude}, ${currentLocation.longitude}"),
    );
    _markers.add(newMarker);
    setState(() {});
  }

  Future<void> _getLocationFromPlaceId(String placeId) async {
    final GoogleMapController controller = await _controller.future;

    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: "AIzaSyBLHghArJPOu5Pb9aAlCky_wqEd0FAFOBI",
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);

    _animateCamera(LatLng(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng));

    print(
        "${detail.result.geometry!.location.lat + detail.result.geometry!.location.lng}");
  }

  Future<void> _animateCamera(LatLng _location) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
      target: _location,
      zoom: 18.4746,
    );
    print(
        "animating camera to (lat: ${_location.latitude}, long: ${_location.longitude}");
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void changeMapType() {
    setState(() {
      maptype = maptype == MapType.normal ? MapType.satellite : MapType.normal;
      isSelected = !isSelected;
    });
  }

  Future<void> _drawPolyline(LatLng from, LatLng to) async {
    Polyline polyline = await PolylineService().drawPolyline(from, to);

    _polylines.add(polyline);

    setState(() {});
  }
}
