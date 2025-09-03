import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'screens/add_plant_page.dart';


void main() => runApp(const PlantApp());

class PlantApp extends StatelessWidget {
  const PlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '植物図鑑',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PlantListPage(),
    );
  }
}

class PlantListPage extends StatefulWidget {
  const PlantListPage({super.key});
  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  List plants = [];

  @override
  void initState() {
    super.initState();
    loadPlants();
  }

  Future<void> loadPlants() async {
    final jsonStr = await rootBundle.loadString('assets/plants.json');
    setState(() {
      plants = json.decode(jsonStr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('植物図鑑')),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return ListTile(
            leading: Image.asset(plant['image'], width: 50),
            title: Text(plant['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlantDetailPage(plant: plant),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(   // 👈 ここを追加！
        onPressed: () async {
          final newPlant = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPlantPage()),
          );

          if (newPlant != null) {
            setState(() {
              plants.add(newPlant); // とりあえずリストに追加
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PlantDetailPage extends StatelessWidget {
  final Map plant;
  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plant['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(plant['image']),
            const SizedBox(height: 16),
            Text(
              plant['description'],
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
