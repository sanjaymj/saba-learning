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

class CardWithButtons extends StatefulWidget {
  final SabaWord word;
  final Function favoriteWordCallback;
  final Function unknownWordCallback;

  CardWithButtons(
      this.word, this.favoriteWordCallback, this.unknownWordCallback);
  @override
  _CardWithButtonsState createState() => _CardWithButtonsState();
}

class _CardWithButtonsState extends State<CardWithButtons> {
  @override
  Widget build(BuildContext context) {
    widget.word.isFavorite =
        widget.word.isFavorite == null ? false : widget.word.isFavorite;
    widget.word.isUnknown =
        widget.word.isUnknown == null ? false : widget.word.isUnknown;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(Icons.album),
            title: new Text(widget.word.originalWord),
            subtitle: Text(widget.word.translatedWord),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.warning),
                color:
                    widget.word.isUnknown ? Colors.yellow[300] : Colors.black,
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
                color: widget.word.isFavorite ? Colors.red[300] : Colors.black,
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
