import 'package:flutter/material.dart';

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // A tabok száma
      child: Scaffold(
        appBar: AppBar(        
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.history), text: 'Generation'),
              Tab(icon: Icon(Icons.filter_list), text: 'Type'),
           
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // A tabok tartalma
            Center(child: Text('Generation Tab Content')),
            Center(child: Text('Type Tab Content')),
          
          ],
        ),
      ),
    );
  }
}
