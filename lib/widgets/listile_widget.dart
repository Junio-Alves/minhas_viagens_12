import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minhas_viagens_12/model/locais.dart';

class ListileWidget extends StatelessWidget {
  final void Function(String) deletarViagem;
  final void Function(LatLng?) abrirMapa;
  final Locais local;
  const ListileWidget({
    super.key,
    required this.abrirMapa,
    required this.deletarViagem,
    required this.local,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () => abrirMapa(local.latLng),
        title: Text(local.endereco),
        trailing: IconButton(
            onPressed: () => deletarViagem(local.id),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            )),
      ),
    );
  }
}
