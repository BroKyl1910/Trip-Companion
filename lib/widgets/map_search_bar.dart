import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color.fromARGB(120, 0, 0, 0), offset: Offset(0.0, 2.0), blurRadius: 6.0)],
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            iconSize: 20.0,
            onPressed: (){},
          ),
          SizedBox(width: 15.0,),
          Container(
            width: 200.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
  
}