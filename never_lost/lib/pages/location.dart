import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:never_lost/auth/database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:never_lost/components/loading.dart';
import 'package:never_lost/components/marker.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationPage extends StatefulWidget {
  final currentUser, friendUser;
  const LocationPage(
      {Key? key, required this.currentUser, required this.friendUser})
      : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isloading = true;
  double lat = 0;
  double long = 0;
  double friendlat = 0;
  double friendlong = 0;
  double zoom = 15;
  late Stream userStream, friendStream;
  String adddress = '';
  String friendAdddress = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
    getUserStream();
  }

  void getUserStream() async {
    await DatabaseMethods()
        .getUserSnapshots(widget.friendUser['uid'])
        .listen((event) async {
      setState(() {
        friendlat = event.data()!['latitude'];
        friendlong = event.data()!['longitude'];
      });
      _getAddress(friendlat, friendlong).then((value) {
        setState(() {
          friendAdddress = value;
        });
      });
    });
  }

  void getlocation() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.onLocationChanged.listen((event) async {
      setState(() {
        lat = event.latitude!;
        long = event.longitude!;
      });
    });
    setState(() {
      lat = _locationData.latitude!;
      long = _locationData.longitude!;
      isloading = false;
    });

    await DatabaseMethods()
        .updateUserLocation(widget.currentUser['uid'], lat, long);
    List<geo.Placemark> add = await geo.placemarkFromCoordinates(lat, long);
    Map data = add[0].toJson();
    String address = data['name'] +
        ',' +
        data['locality'] +
        ',' +
        data['subAdministrativeArea'] +
        ',' +
        data['administrativeArea'] +
        ',' +
        data['postalCode'];
    setState(() {
      adddress = address;
    });
  }

  _getAddress(double lat, double long) async {
    List<geo.Placemark> add = await geo.placemarkFromCoordinates(lat, long);
    Map data = add[0].toJson();
    print(data);
    String address = data['name'] +
        ',' +
        data['locality'] +
        ',' +
        data['subAdministrativeArea'] +
        ',' +
        data['administrativeArea'] +
        ',' +
        data['postalCode'];
    print(address);
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Loading()
        : Scaffold(
            body: FlutterMap(
              options: MapOptions(
                interactiveFlags: InteractiveFlag.all,
                center: LatLng(friendlat, friendlong),
                zoom: zoom,
              ),
              layers: [
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      height: 40,
                      width: 40,
                      point: LatLng(lat, long),
                      builder: (ctx) => LocationMarker(
                        user: widget.currentUser,
                        address: adddress,
                      ),
                    ),
                  ],
                ),
              ],
              children: <Widget>[
                TileLayerWidget(
                    options: TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'])),
                MarkerLayerWidget(
                    options: MarkerLayerOptions(
                  markers: [
                    Marker(
                      height: 40,
                      width: 40,
                      point: LatLng(friendlat, friendlong),
                      builder: (ctx) => LocationMarker(
                        user: widget.friendUser,
                        address: friendAdddress,
                      ),
                    ),
                  ],
                )),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _getAddress(lat, long);
              },
              child: const Icon(CupertinoIcons.restart),
            ),
          );
  }
}
