import 'package:cep_list/models/cep_model.dart';

class SavedCepsModel {
  List<CEPModel> results = [];

  SavedCepsModel(this.results);

  SavedCepsModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <CEPModel>[];
      json['results'].forEach((v) {
        results.add(CEPModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}
