import 'package:http/http.dart' as http;

import 'package:cep_list/models/cep_model.dart';

class CEPRepository {
  Future<String> getCepData(String cep) async {
    var response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    return response.body;
  }
}
