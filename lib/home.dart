import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Theme.of(context).accentColor,
              height: Constants.headerHeight + statusBarHeight,
            ),
          ),
          Positioned(
              right: -45,
              top: -30,
              child: ClipOval(
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                    height: 220,
                    width: 220,
                  ),
              ),
          ),

          // BODY
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              children: <Widget>[
                // Header - Greetings and Avatar
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Good Morning,\nPatient",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Colors.white
                          ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 26.0,
                      backgroundImage: AssetImage('assets/user.jpg')
                    )
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }
}
