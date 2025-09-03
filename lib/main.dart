import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'screens/add_plant_page.dart';
import 'database/plant_database.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


void main() {
  // Webの場合だけ databaseFactory を差し替える
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(const PlantApp());
}

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
    final data = await PlantDatabase.getPlants();
    setState(() {
      plants = data;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPlant = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPlantPage()),
          );

        if (newPlant != null) {
              setState(() {
                plants.add(newPlant); // アプリ起動中だけ保持
              });
            }
        // 実機確認時に以下に変更する
        // if (newPlant != null) {
        //   await PlantDatabase.insertPlant(newPlant); // DBに保存
        //   loadPlants(); // 保存後に一覧を再読み込み
        // }
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
