import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CEP List',
          style: TextStyle(fontSize: 26),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.search, size: 30),
      ),
      body: const Center(
        child: Text(
          'Nenhum Registro',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
