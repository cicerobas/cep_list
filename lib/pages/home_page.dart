import 'package:cep_list/models/cep_model.dart';
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
  var cepModel = CEPModel();
  List<CEPModel> savedCepData = [];

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
        body: savedCepData.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum Registro',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: savedCepData.length,
                  itemBuilder: (context, index) {
                    var cepData = savedCepData[index];
                    return Card(
                        child: ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      childrenPadding: const EdgeInsets.all(10),
                      expandedAlignment: Alignment.centerLeft,
                      //expandedAlignment: Alignment.bottomLeft,
                      title: Text(
                        cepData.cep!,
                        style: _cepDataTextStyle().copyWith(fontSize: 20),
                      ),
                      subtitle: Text(
                        cepData.logradouro!,
                        style: _cepDataTextStyle().copyWith(fontSize: 16),
                      ),
                      children: [
                        Text(
                          'Complemento: ${cepData.complemento!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Text(
                          'Bairro: ${cepData.bairro!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Text(
                          'Localidade: ${cepData.localidade!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Text(
                          'UF: ${cepData.uf!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Text(
                          'IBGE: ${cepData.ibge!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Text(
                          'GIA: ${cepData.gia!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Text(
                          'DDD: ${cepData.ddd!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Text(
                          'SIAFI: ${cepData.siafi!}',
                          style: _cepDataTextStyle(),
                        ),
                        const Divider(),
                        Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {},
                                child: const Icon(Icons.delete),
                              ),
                            )),
                      ],
                    ));
                  },
                ),
              ));
  }

  TextStyle _cepDataTextStyle() {
    return const TextStyle(
        fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.5);
  }

  void _displayCepDialog(BuildContext context) async {
    bool isLoading = false, isLoaded = false;
    return showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              title: const Text('Busca CEP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  )),
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
                      isLoaded = false;
                      if (value.length == 8) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          isLoading = !isLoading;
                        });
                        var response = await _loadCepData(value);
                        setState(() {
                          cepModel = response;
                          isLoading = !isLoading;
                          isLoaded = true;
                        });
                      }
                    },
                  ),
                  Visibility(
                      visible: isLoading,
                      child: const Center(child: CircularProgressIndicator())),
                  Visibility(
                      visible: isLoaded,
                      child: cepModel.cep == null
                          ? Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Não encontrado',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.red[700]),
                              ),
                            )
                          : ListTile(
                              title: Text(cepModel.cep!),
                              subtitle: Text(
                                  '${cepModel.logradouro}\n${cepModel.localidade} / ${cepModel.uf}'),
                              isThreeLine: true,
                              trailing: IconButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    _saveCepData();
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.save)),
                            ))
                ],
              ),
            );
          });
        });
  }

  Future _loadCepData(String value) async {
    await Future.delayed(const Duration(seconds: 1)); //TIRAR DEPOIS
    return await cepRepository.getCepData(value);
  }

  _saveCepData() async {
    setState(() {
      savedCepData.add(cepModel);
    });
    var status = await cepRepository.saveCepData(cepModel);
    debugPrint('STATUS: $status');
  }
}
