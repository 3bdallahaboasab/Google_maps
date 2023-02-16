import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'My title';

    return MaterialApp(
      home: Scaffold(
          body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // title: Text("Dddd"),

            scrolledUnderElevation: 0,
            snap: false,

            pinned: true,
            floating: false,
            // automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("$title",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ) //TextStyle
                    ), //Text
                background: Image.network(
                  "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg",
                  fit: BoxFit.cover,
                ) //Images.network
                ), //FlexibleSpaceBar
            expandedHeight: 230,
            backgroundColor: Colors.orangeAccent[400],
            leading: IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () {},
            ), //IconButton
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.comment),
                tooltip: 'Comment Icon',
                onPressed: () {},
              ), //IconButton
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Setting Icon',
                onPressed: () {},
              ), //IconButton
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light, //<Widget>[]
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return listItem(Colors.primaries[Random().nextInt(5)],
                    "Sliver Grid item:\n$index");
              }),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  childAspectRatio: 15)), //SliverAppBar
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                tileColor: (index % 2 == 1) ? Colors.white : Colors.orange[50],
                title: Center(
                  child: Text('$index',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 50,
                          color: Colors.orangeAccent[400]) //TextStyle
                      ), //Text
                ), //Center
              ), //ListTile
              childCount: 51,
            ), //SliverChildBuildDelegate
          ),
        ], //<Widget>[]
      ) //CustonScrollView
          ), //Scaffold
      debugShowCheckedModeBanner: false,
    ); //MaterialApp
  }

  Widget listItem(Color color, String title) => Container(
        height: 100.0,
        color: color,
        child: Center(
          child: Text(
            "$title",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
