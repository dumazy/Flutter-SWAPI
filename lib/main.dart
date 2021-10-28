import 'package:flutter/material.dart';
import 'package:flutter_sandbox/planet_controller.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PlanetController>(
      create: (_) => PlanetController(),
      dispose: (_, controller) => controller.dispose(),
      child: MaterialApp(
        title: 'Flutter Sandbox',
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyAppBarTitle(),
      ),
      body: PlanetList(),
    );
  }
}

class MyAppBarTitle extends StatelessWidget {
  const MyAppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Planet>>(
      stream: Provider.of<PlanetController>(context).planetStream,
      builder: (_, snapshot) {
        String title = 'SWAPI';
        if (snapshot.hasData) {
          int numberOfPlanets = snapshot.requireData.length;
          title = 'SWAPI: # planets $numberOfPlanets';
        }
        return Text(title);
      },
    );
  }
}

class PlanetList extends StatefulWidget {
  const PlanetList({Key? key}) : super(key: key);

  @override
  State<PlanetList> createState() => _PlanetListState();
}

class _PlanetListState extends State<PlanetList> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<PlanetController>(context).initialFetchPlanets();
  }

  @override
  Widget build(BuildContext context) {
    final _planetController = Provider.of<PlanetController>(context);
    return StreamBuilder<List<Planet>>(
        stream: _planetController.planetStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final planets = snapshot.requireData;
          return ListView.builder(
            itemCount: planets.length + 1,
            itemBuilder: (_, index) {
              if (index > planets.length - 1) {
                _planetController.fetchMorePlanets();
                return LoadingItem();
              }
              final planet = planets[index];
              return PlanetView(planet: planet);
            },
          );
        });
  }
}

class PlanetView extends StatelessWidget {
  final Planet planet;
  const PlanetView({
    Key? key,
    required this.planet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListTile(
            leading: Icon(
              Icons.map,
              size: 60,
            ),
            title: Text(planet.name),
            subtitle: Text('Diameter: ${planet.diameter}'),
          ),
        ),
      ),
    );
  }
}

class LoadingItem extends StatelessWidget {
  const LoadingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Planet {
  final String name;
  final int diameter;

  Planet(this.name, this.diameter);
}
