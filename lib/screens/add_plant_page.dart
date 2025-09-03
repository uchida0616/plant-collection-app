import 'package:flutter/material.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("植物を登録")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "植物名"),
                validator: (value) =>
                    value!.isEmpty ? "植物名を入力してください" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "説明"),
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "画像パス"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final plant = {
                      "name": _nameController.text,
                      "description": _descController.text,
                      "image": _imageController.text,
                    };
                    Navigator.pop(context, plant);
                  }
                },
                child: const Text("登録"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
