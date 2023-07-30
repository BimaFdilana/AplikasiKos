import 'package:flutter/material.dart';

class LayananPage extends StatefulWidget {
  const LayananPage({super.key});

  @override
  State<LayananPage> createState() => LayananPageState();
}

class LayananPageState extends State<LayananPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
          body: Center(
            child: Text('Layanan Page'),
          ),
    );
  }
}