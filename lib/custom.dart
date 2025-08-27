import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Appbar")
      ),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    // the first child
                  ],
                ),
                SizedBox(
                  width:  300,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.ice_skating),
                        title: Text("Starred folders"),
                      ),
                      ListTile(
                        leading: Icon(Icons.safety_check),
                        title: Text("Recent folders"),
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Home"),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.plus_one),
                  title: Text("Other Locations"),
                )
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.folder),
                  title: Text("Directory Name"),
                ),
                // ListView(
                //      )

              ],
            ),
          )
        ],
      ),

    );
  }
}

