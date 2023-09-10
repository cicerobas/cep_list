import 'dart:convert';
import 'package:cep_list/models/saved_ceps_model.dart';
import 'package:cep_list/services/custom_dio.dart';
import 'package:http/http.dart' as http;

import 'package:cep_list/models/cep_model.dart';

class CEPRepository {
  final _customDio = CustomDio();

  Future<(CEPModel, bool)> getCepData(String cep) async {
    var formatedCep = '${cep.substring(0, 5)}-${cep.substring(5, 8)}';
    var response = await _customDio.dio.get('?where={"cep":"$formatedCep"}');
    var result = SavedCepsModel.fromJson(response.data);
    if (result.results.isEmpty) {
      return (await _getCepFromApi(cep), false);
    }
    return (result.results[0], true);
  }

  Future<CEPModel> _getCepFromApi(String cep) async {
    var response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.body.contains('erro')) {
      return CEPModel.empty();
    }
    return CEPModel.fromJson(jsonDecode(response.body));
  }

  Future<SavedCepsModel> getSavedCepList() async {
    var response = await _customDio.dio.get('');
    return SavedCepsModel.fromJson(response.data);
  }

  saveCepData(CEPModel cepModel) async {
    await _customDio.dio.post('', data: jsonEncode(cepModel.toJson()));
  }

  deleteCepData(String id) async {
    await _customDio.dio.delete('/$id');
  }
}
