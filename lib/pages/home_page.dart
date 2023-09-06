import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CEP List',
          style: TextStyle(fontSize: 26),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cepController.text = '';
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Busca CEP', textAlign: TextAlign.center),
                  content: TextField(
                    controller: cepController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: ' Apenas números',
                    ),
                    onChanged: (String value) {
                      if (value.length == 8) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                  ),
                );
              });
        },
        child: const Icon(Icons.search, size: 30),
      ),
      body: const Center(
        child: Text(
          'Nenhum Registro',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
