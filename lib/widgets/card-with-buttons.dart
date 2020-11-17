import 'package:flutter/material.dart';

class CardWithButtons extends StatelessWidget {
  final String title;
  final String subtitle;

  CardWithButtons(this.title, this.subtitle);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(Icons.album),
            title: new Text(this.title),
            subtitle: Text(this.subtitle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.warning),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more),
                onPressed: () {
                  print("pressed more ");
                },
              ),
              const SizedBox(width: 8),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
