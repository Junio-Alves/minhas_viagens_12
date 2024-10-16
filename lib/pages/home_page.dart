import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minhas_viagens_12/model/locais.dart';
import 'package:minhas_viagens_12/widgets/listile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firebaseInstace = FirebaseFirestore.instance;
  void deletarViagem(String id) {
    firebaseInstace.collection("locais").doc(id).delete();
  }

  abrirMapa(LatLng? latLng) {
    Navigator.pushNamed(context, "/Mapas", arguments: latLng);
  }

  CollectionReference recuperarLocaisStream() {
    return firebaseInstace.collection("locais");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Minhas Viagens",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () => abrirMapa(null),
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: StreamBuilder<QuerySnapshot>(
        stream: recuperarLocaisStream().snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                List<Locais> viagens = [];
                for (final doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final local = Locais(
                    id: doc.id,
                    endereco: data["endereço"],
                    latLng: LatLng(data["latitude"], data["longitude"]),
                  );
                  viagens.add(local);
                }
                return ListView.builder(
                  itemCount: viagens.length,
                  itemBuilder: (context, index) {
                    return ListileWidget(
                      abrirMapa: abrirMapa,
                      local: viagens[index],
                      deletarViagem: deletarViagem,
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
