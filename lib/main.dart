import 'package:flutter/material.dart';
import 'dart:math';
import 'package:boggle/Game/Game.dart';
import 'package:boggle/Position.dart';
import 'package:boggle/Tile.dart';

void main() {
  runApp(MyApp());
}



var _test = 'This is testing 2';
var _test2 = 'This is testing 3';
var _test3 = 'Can I add this from android studio?';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boggle',
      theme: ThemeData(
        primarySwatch: Colors.pink,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Boggle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Boggle"),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 50,
                    child:RaisedButton(child: Text("Host a Game"), color: Colors.pinkAccent, onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGamePage()),);}),
                  ),
                  SizedBox(height:20),
                  Container(
                    width: 300,
                    height: 50,
                    child:RaisedButton(child: Text("Join a Game"), color: Colors.pinkAccent, onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => JoinGamePage()),);}),
                  )
                ]
            )
        )
    );
  }
}

class CreateGamePage extends StatefulWidget {
  CreateGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateGamePageState createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  int boardSize;
  Random random = new Random();
  int gameCode;
  TextEditingController nameC = new TextEditingController();
  List<int> sizes = [4, 5, 6];
  int sizeIndex = 1;

  @override Widget build(BuildContext context) {
    gameCode = random.nextInt(99999);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Host a Game"),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Text("Screen Name:   "),
                        SizedBox(width: 200, child: TextField(controller: nameC, keyboardType: TextInputType.text))
                      ]
                  ),
                  Row(
                      children: <Widget>[
                        Text("Board Size:   "),
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButton(
                                value: sizeIndex,
                                items: [
                                  DropdownMenuItem(
                                      child: Text("4X4"),
                                      value: 1
                                  ),
                                  DropdownMenuItem(
                                      child: Text("5X5"),
                                      value: 2
                                  ),
                                  DropdownMenuItem(
                                      child: Text("6X6"),
                                      value: 3
                                  )
                                ],
                                onChanged: (newValue) {
                                  setState(() {
                                    sizeIndex = newValue;
                                  });
                                }
                            )
                        )
                      ]
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    child:RaisedButton(child: Text("Host Game"), color: Colors.pinkAccent, onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StartGamePage(title: "Start Game", host: true, gameCode: gameCode, size: sizes[sizeIndex])),);}),
                  )
                ]
            )
        )
    );
  }
}

class JoinGamePage extends StatefulWidget {
  JoinGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {
  TextEditingController nameC = new TextEditingController();
  TextEditingController gameCodeC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Join a Game"),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Text("Screen Name:   "),
                        SizedBox(width: 200, child: TextField(controller: nameC, keyboardType: TextInputType.text))
                      ]
                  ),
                  Row(
                      children: <Widget>[
                        Text("Game Code:   "),
                        SizedBox(width: 200, child: TextField(controller: gameCodeC, keyboardType: TextInputType.number))
                      ]
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    child:RaisedButton(child: Text("Join Game"), color: Colors.pinkAccent, onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StartGamePage(title: "Start Game", host: false, gameCode: int.parse(gameCodeC.text.toString()), name: nameC.text)),);}),
                  )
                ]

            )
        )
    );
  }
}

class StartGamePage extends StatefulWidget {
  StartGamePage({Key key, this.title, this.host, this.gameCode, this.size, this.name}) : super(key: key);

  final String title;

  final bool host;

  final int gameCode;

  final int size;

  final String name;

  @override
  _StartGamePageState createState() => _StartGamePageState();
}

class _StartGamePageState extends State<StartGamePage> {

  @override
  Widget build(BuildContext context) {
    bool host = widget.host;
    if (host){
      return hostBuild(context);
    }
    return notHostBuild(context);
  }

  Widget hostBuild(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Participants"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 50,
              child:RaisedButton(child: Text("Start Game"), color: Colors.pinkAccent, onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayGamePage(title: "Play Game", gameCode: widget.gameCode, size: widget.size, name: widget.name)),);}),
            ),

          ]
        )
      )
    );
  }

  Widget notHostBuild(BuildContext context){
    // TODO: implement build
    throw UnimplementedError();
  }

}

class PlayGamePage extends StatefulWidget {
  PlayGamePage({Key key, this.title, this.gameCode, this.size, this.name}) : super(key: key);

  final String title;

  final int gameCode;

  final int size;

  final String name;

  @override
  _PlayGamePageState createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {

  Game game;
  List<List<TilePainter>> boardRows = new List<List<TilePainter>>();
  List<TilePainter> currentTiles = new List<TilePainter>();
  String currentWord = "";
  List<Position> currentPositions = new List<Position>();

  void addToCurrentTiles(TilePainter tile) {
    tile.select();
    currentWord += tile.getLetter();
    currentPositions.add(tile.getPosition());
    currentTiles.add(tile);
  }

  @override
  Widget build(BuildContext context) {
    game = new Game(widget.size, widget.gameCode);
    List<Characters> letters = game.getBoardString() as List<Characters>;
    for (int i=0; i<widget.size; i++) {
      boardRows.add(new List<TilePainter>());
      for (int j=0; j<widget.size; j++) {
        boardRows[i].add(new  TilePainter(letters.removeAt(0), Position(j,i)));
      }
    }
    List<Widget> body = new List<Widget>();
    List<List<Widget>> UIBoardRows = new List<List<Widget>>();
    for (int i=0; i<widget.size; i++) {
      UIBoardRows.add(new List<Widget>());
      for (int j=0; j<widget.size; j++) {
        UIBoardRows[i].add(
            LayoutBuilder(
                builder: (_, constraints) => Container(
                    width: (constraints.widthConstraints().maxWidth - 20) / widget.size,
                    height: (constraints.widthConstraints().maxWidth - 20) / widget.size,
                    child: GestureDetector( // figured this out at https://stackoverflow.com/questions/57100266/how-do-i-get-to-tap-on-a-custompaint-path-in-flutter-using-gesturedetect
                      child: CustomPaint(painter: boardRows[i][j]),
                      onTap: () {
                        if (boardRows[i][j].getPosition().isNeighbor(currentTiles.last.getPosition()) && !currentTiles.contains(boardRows[i][j])) {
                          addToCurrentTiles(boardRows[i][j]);
                        }
                      },
                    )
            )
        ));
      }
    }
    // add timer to body
    for (int i=0; i<widget.size; i++) {
      body.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: UIBoardRows[i]));
    }
    body.add(Text("Selected Word:  $currentWord"));
    body.add(RaisedButton(child: Text("Enter Word"), onPressed: () {
      if (game.isWordValid(currentPositions)) {
        for (TilePainter t in currentTiles) {
          t.changeColor(Colors.greenAccent);
        }
      } else {
        for (TilePainter t in currentTiles) {
          t.changeColor(Colors.redAccent);
        }
      }
      // here make the program wait half a second
      for (TilePainter t in currentTiles) {
        t.reset();
      }
    }
    ));

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Play Game"),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: body
            )
        )
    );
  }

}

class ScorePage extends StatefulWidget {
  ScorePage({Key key, this.title, this.gameCode, this.score, this.name}) : super(key: key);

  final String title;

  final int gameCode;

  final int score;

  final String name;

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
