import 'dart:async';

import 'package:flutter_sandbox/api/planet_api.dart';

import 'main.dart';

class PlanetController {
  PlanetApi _api = PlanetApi();
  StreamController<List<Planet>> _controller = StreamController.broadcast();

  List<Planet> _planets = [];

  int _page = 1;

  Stream<List<Planet>> get planetStream => _controller.stream;

  Future<void> initialFetchPlanets() async {
    if (_planets.isNotEmpty) {
      return;
    }

    final planets = await _api.fetchPlanets(page: _page);
    _page++;

    _addPlanets(planets);
  }

  Future<void> fetchMorePlanets() async {
    final planets = await _api.fetchPlanets(page: _page);
    _page++;

    _addPlanets(planets);
  }

  void _addPlanets(List<Planet> planets) {
    _planets.addAll(planets);
    _controller.add(_planets);
  }

  void dispose() {
    _controller.close();
  }
}

final _fakePlanets = [
  Planet("A planet", 132),
  Planet("A planet", 132),
  Planet("B planet", 13278),
  Planet("B planet", 13278),
  Planet("A planet", 132),
  Planet("B planet", 13278),
  Planet("B planet", 13278),
];
