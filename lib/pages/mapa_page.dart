import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  final LatLng? latLng;
  const MapaPage({super.key, this.latLng});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  // ignore: unused_field
  GoogleMapController? _controller;
  Set<Marker> markers = {};
  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  adicionarMarcador(LatLng latlng, String markerId) {
    final marker = Marker(
        infoWindow: InfoWindow(title: markerId),
        markerId: MarkerId(markerId),
        position: latlng);
    setState(() => markers.add(marker));
  }

  Future<String> recuperarEndereco(LatLng latlng) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    final lugar = placeMarks[0];
    return "${lugar.street},${lugar.subLocality},${lugar.subAdministrativeArea},${lugar.administrativeArea}";
  }

  adicionarFirebase(String endereco, LatLng latlng) async {
    await FirebaseFirestore.instance.collection("locais").add(
      {
        "endereço": endereco,
        "latitude": latlng.latitude,
        "longitude": latlng.longitude,
      },
    );
  }

  adicionarLocal(LatLng latlng) async {
    String endereco = await recuperarEndereco(latlng);
    adicionarMarcador(latlng, endereco);
    adicionarFirebase(endereco, latlng);
  }

  recuperarMarcadores() async {
    Set<Marker> localMarkers = {};
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("locais").get();
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final localMarker = Marker(
        infoWindow: InfoWindow(title: data["endereço"]),
        markerId: MarkerId(data["endereço"]),
        position: LatLng(data["latitude"], data["longitude"]),
      );
      localMarkers.add(localMarker);
    }
    setState(() {
      markers = localMarkers;
    });
  }

  @override
  void initState() {
    super.initState();
    recuperarMarcadores();
  }

  @override
  Widget build(BuildContext context) {
    LatLng initalPosition =
        widget.latLng ?? const LatLng(-2.904737, -41.776547);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mapa",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initalPosition,
          zoom: widget.latLng != null ? 17 : 15,
        ),
        onTap: adicionarLocal,
        onMapCreated: onCreated,
        markers: markers,
      ),
    );
  }
}
