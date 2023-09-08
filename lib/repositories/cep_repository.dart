import 'dart:convert';
import 'package:cep_list/services/custom_dio.dart';
import 'package:http/http.dart' as http;

import 'package:cep_list/models/cep_model.dart';

class CEPRepository {
  final _customDio = CustomDio();

  Future<CEPModel> getCepData(String cep) async {
    var response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.body.contains('erro')) {
      return CEPModel.empty();
    }
    return CEPModel.fromJson(jsonDecode(response.body));
  }

  saveCepData(CEPModel cepModel) async {
    var response =
        await _customDio.dio.post('', data: jsonEncode(cepModel.toJson()));
    return response.statusCode;
  }
}
