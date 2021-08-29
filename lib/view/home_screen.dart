import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapp/utils/network_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;

// For holding Co-ordinates as LatLng
  final List<LatLng> polyPoints = [];

//For holding instance of Polyline
  final Set<Polyline> polyLines = {};

// For holding instance of Marker
  final Set<Marker> markers = {};
  var data;

// Dummy Start and Destination Points
  // double startLat = 23.551904;
  // double startLng = 90.532171;
  // double endLat = 23.560625;
  // double endLng = 90.531813;

  double startLat = 8.982980649504471;
  double startLng = 38.69708436877231;
  double endLat = 8.980486871339163;
  double endLng = 38.698054125534924;

  //
  final mapinitlat = 8.981543522957814;
  final mapinitlong = 38.69750037991378;

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMarkers();
  }

  setMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(startLat, startLng),
        infoWindow: InfoWindow(
          title: "Home",
          snippet: "Home Sweet Home",
        ),
      ),
    );
    markers.add(Marker(
      markerId: MarkerId("Destination"),
      position: LatLng(endLat, endLng),
      infoWindow: InfoWindow(
        title: "Masjid",
        snippet: "5 star rated place",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(2.0),
    ));
    setState(() {});
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.black,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls = LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }
      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline Demo'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(mapinitlat, mapinitlong),
          zoom: 18,
        ),
        markers: markers,
        polylines: polyLines,
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
//https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248288c9ea0effe46fe8057b9c3a6aeb92d&start=8.681495,49.41461&end=8.687872,49.420318