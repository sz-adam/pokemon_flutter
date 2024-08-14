import 'package:flutter/material.dart';
import 'package:flutter_pokemon/navigation/tab_navigation.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {

  

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: TabScreen()
    );
  }
}