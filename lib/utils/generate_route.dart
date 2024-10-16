import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minhas_viagens_12/pages/home_page.dart';
import 'package:minhas_viagens_12/pages/mapa_page.dart';
import 'package:minhas_viagens_12/pages/unkown_page.dart';

class RouterGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case "/Mapas":
        return MaterialPageRoute(
          builder: (context) => MapaPage(
            latLng: settings.arguments != null
                ? settings.arguments as LatLng
                : null,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const UnkownPage(),
        );
    }
  }
}
