import 'package:cep_list/repositories/cep_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cepController = TextEditingController();
  final cepRepository = CEPRepository();

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
          _displayCepDialog(context);
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

  void _displayCepDialog(BuildContext context) async {
    bool isLoading = false;
    return showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              title: const Text('Busca CEP', textAlign: TextAlign.center),
              content: Wrap(
                children: [
                  TextField(
                    controller: cepController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: ' Apenas números',
                    ),
                    onChanged: (String value) async {
                      if (value.length == 8) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() => isLoading = !isLoading);
                        var resp = await cepRepository.getCepData(value);
                        await Future.delayed(const Duration(seconds: 1));
                        debugPrint(resp);
                        setState(() => isLoading = !isLoading);
                      }
                    },
                  ),
                  Visibility(
                      visible: isLoading,
                      child: const Center(child: CircularProgressIndicator())),
                ],
              ),
            );
          });
        });
  }
}
