import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:never_lost/components/loading.dart';

class MAp extends StatefulWidget {
  const MAp({Key? key}) : super(key: key);

  @override
  State<MAp> createState() => _MApState();
}

class _MApState extends State<MAp> {
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isloading = true;
  double lat = 0;
  double long = 0;
  double zoom = 15;
  @override
  void initState() {
    super.initState();
    getlocation();
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
    setState(() {
      lat = _locationData.latitude!;
      long = _locationData.longitude!;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Loading()
        : Scaffold(
            body: FlutterMap(
              options: MapOptions(
                center: LatLng(lat, long),
                zoom: zoom,
              ),
              layers: [
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(lat, long),
                      builder: (ctx) => Container(
                        child: const Icon(CupertinoIcons.location_circle),
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
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(lat + 0.005, long + 0.005),
                      builder: (ctx) => Container(
                        height: 20,
                        width: 20,
                        child: const Icon(Icons.location_on),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                getlocation();
              },
              child: const Icon(CupertinoIcons.restart),
            ),
          );
  }
}
