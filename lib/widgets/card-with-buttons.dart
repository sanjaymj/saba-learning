import 'package:flutter/material.dart';
import 'package:sabalearning/models/SabaWord.dart';

/* class CardWithButtons extends StatelessWidget {
  final SabaWord word;
  final Function favoriteWordCallback;
  final Function unknownWordCallback;

  CardWithButtons(
      this.word, this.favoriteWordCallback, this.unknownWordCallback);
  @override
  Widget build(BuildContext context) {
    this.word.isFavorite =
        this.word.isFavorite == null ? false : this.word.isFavorite;
    this.word.isUnknown =
        this.word.isUnknown == null ? false : this.word.isUnknown;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(Icons.album),
            title: new Text(this.word.originalWord),
            subtitle: Text(this.word.translatedWord),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.warning),
                color: this.word.isUnknown ? Colors.yellow[300] : Colors.black,
                onPressed: () {
                  this.unknownWordCallback(this.word.originalWord);
                },
              ),
              IconButton(
                icon: this.word.isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                color: this.word.isFavorite ? Colors.red[300] : Colors.black,
                onPressed: () {
                  this.favoriteWordCallback(this.word.originalWord);
                },
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
} */

class RandomColor {
  int r;
  int g;
  int b;
}

var colors = [
  Colors.purpleAccent[700],
  Colors.greenAccent[700],
  Colors.indigoAccent[700],
  Colors.blueGrey[700],
  Colors.lightGreenAccent[700],
  Colors.limeAccent[700],
  Colors.tealAccent[700],
];

class CardWithButtons extends StatefulWidget {
  final SabaWord word;
  final Function favoriteWordCallback;
  final Function unknownWordCallback;
  final Function moreInfoCallback;

  randomColorGenerator(s) {
    var codes = s.codeUnits;
    var sum = 0;
    codes.forEach((val) => {sum = sum + val});
    return colors[sum % colors.length];
  }

  CardWithButtons(this.word, this.favoriteWordCallback,
      this.unknownWordCallback, this.moreInfoCallback);
  @override
  _CardWithButtonsState createState() => _CardWithButtonsState();
}

class _CardWithButtonsState extends State<CardWithButtons> {
  @override
  Widget build(BuildContext context) {
    var color;
    if (widget.word.category.length == 0) {
      color = colors[0];
    } else {
      color = widget.randomColorGenerator(widget.word.category[0]);
    }
    widget.word.isFavorite =
        widget.word.isFavorite == null ? false : widget.word.isFavorite;
    widget.word.isUnknown =
        widget.word.isUnknown == null ? false : widget.word.isUnknown;
    return SingleChildScrollView(
      child: Container(
        child: Card(
          shadowColor: color,
          elevation: 5.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: Icon(Icons.album),
                title: new Text(widget.word.originalWord),
                subtitle: Text(widget.word.additionalInfo != null
                    ? widget.word.translatedWord +
                        "\n\n" +
                        widget.word.additionalInfo
                    : widget.word.translatedWord),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.black,
                    onPressed: () {
                      widget.unknownWordCallback(widget.word.originalWord);
                      setState(() {
                        widget.word.isUnknown = widget.word.isUnknown == null
                            ? true
                            : !widget.word.isUnknown;
                      });
                    },
                  ),
                  IconButton(
                    icon: widget.word.isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    color:
                        widget.word.isFavorite ? Colors.red[300] : Colors.black,
                    onPressed: () {
                      widget.favoriteWordCallback(widget.word.originalWord);
                      setState(() {
                        widget.word.isFavorite = widget.word.isFavorite == null
                            ? true
                            : !widget.word.isFavorite;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      widget.moreInfoCallback(widget.word);
                    },
                  ),
                  const SizedBox(width: 8),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
