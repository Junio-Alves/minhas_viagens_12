import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locais {
  final String id;
  final String endereco;
  final LatLng latLng;
  Locais({
    required this.id,
    required this.endereco,
    required this.latLng,
  });
}
