import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_sandbox/api/model.dart';

import '../main.dart';

class PlanetApi {
  final Dio httpClient = Dio(
    BaseOptions(baseUrl: 'https://swapi.dev/api'),
  );

  Future<List<Planet>> fetchPlanets({required int page}) async {
    Response response = await httpClient.get('/planets', queryParameters: {
      'page': page,
    });

    final json = response.data;

    // final json = jsonDecode(data);
    final results = json['results'] as List<dynamic>;
    final dtos = results.map((e) => PlanetDto.fromJson(e));

    return dtos
        .map((dto) => Planet(
              dto.name,
              int.tryParse(dto.diameter) ?? 0,
            ))
        .toList();
  }
}
