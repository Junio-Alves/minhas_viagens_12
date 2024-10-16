import 'package:flutter/material.dart';

class UnkownPage extends StatelessWidget {
  const UnkownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Pagina não encontrada"),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Voltar"))
          ],
        ),
      ),
    );
  }
}
