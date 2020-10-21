import 'dart:async';
import 'dart:io';
import 'package:boggle/Networking/GuestNetworking.dart';
import 'package:boggle/Networking/HostNetworking.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:boggle/Game/Game.dart';
import 'package:boggle/Position.dart';
import 'package:boggle/Tile.dart';
import 'package:boggle/Game/Scorer.dart';

void main() {
  runApp(MyApp());
}

var _test = 'This is testing 2';
var _test2 = 'This is testing 3';
var _test3 = 'Can I add this from android studio?';

Timer _timer;


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
                    child:RaisedButton(child: Text("Host a Game"), color: Color(0xfff6adc6), onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGamePage()),);}),
                  ),
                  SizedBox(height:20),
                  Container(
                    width: 300,
                    height: 50,
                    child:RaisedButton(child: Text("Join a Game"), color: Color(0xfff6adc6), onPressed: () {
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
                    child:RaisedButton(child: Text("Host Game"), color: Color(0xfff6adc6), onPressed: () {
                      HostNetworking network = HostNetworking(nameC.text);
                      network.setUpServer();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StartGamePage(title: "Start Game", host: true, size: sizes[sizeIndex-1], hNetwork: network,)),);}),
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
                    child:RaisedButton(child: Text("Join Game"), color: Color(0xfff6adc6), onPressed: () {
                      //onPressed need to try to create a GuestNetworking that connects to a valid host and if it work go to StartGamePage
                    }),
                  )
                ]

            )
        )
    );
  }
}

class StartGamePage extends StatefulWidget {
  StartGamePage({Key key, this.title, this.host, this.size, this.hNetwork, this.gNetwork}) : super(key: key);

  final String title;

  final bool host;

  final int size;

  final HostNetworking hNetwork;

  final GuestNetworking gNetwork;

  @override
  _StartGamePageState createState() => _StartGamePageState();
}

class _StartGamePageState extends State<StartGamePage> {

  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    bool host = widget.host;
    if (host){
      return hostBuild(context);
    }
    return guestBuild(context);
  }

  Widget hostBuild(BuildContext context) {
    InternetAddress _address = InternetAddress.anyIPv4;
    int seed = random.nextInt(99999);
    List<Widget> body = new List<Widget>();
    body.add(Text("Game Code:  $_address"));
    body.add(Container(
        width: 100,
        height: 50,
        child: playGameButton(seed)
    ));
    for (String name in widget.hNetwork.screenNamesInGame) {
      body.add(Text(name));
    }
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Participants"),
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

  Widget playGameButton(int seed) {
    return RaisedButton(
        child: Text("Start Game"),
        color: Color(0xfff6adc6),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlayGamePage(title: "Play Game", seed: seed, host: widget.host, size: widget.size, hNetwork: widget.hNetwork,)),);
        }
    );
  }

  Widget guestBuild(BuildContext context){
    String screenName = widget.gNetwork.screenName;
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Waiting for game to start..."),
        backgroundColor: Colors.pinkAccent,
      ), body: Center(
        child: Text("Screen Name:  $screenName")
    )
    );
  }

  // Not sure how to go to PlayGamePage as a guest when the seed and size are received

}

class PlayGamePage extends StatefulWidget {
  PlayGamePage({Key key, this.title, this.seed, this.host, this.size, this.hNetwork, this.gNetwork}) : super(key: key);

  final String title;

  final int seed;

  final bool host;

  final int size;

  final HostNetworking hNetwork;

  final GuestNetworking gNetwork;

  @override
  _PlayGamePageState createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {

  List<List<TilePainter>> tiles = new List<List<TilePainter>>();
  List<TilePainter> currentTiles = new List<TilePainter>();
  String currentWord = "";
  List<Position> currentPositions = new List<Position>();
  int _gametime = 45;
  int _gamemins = 3;
  int _gamesecs = 00;
  String gameSecsText = "00";
  Timer _timer;
  Map<String, Set> wordLists;
  bool started = false;
  Game game;

  void createGame() {
    if (!started) {
      started = true;
      if (widget.host) {
        widget.hNetwork.startGameAndAwaitResults(widget.seed, widget.size);
      }
      game = new Game(widget.size, widget.seed);
    }
  }


  void addToCurrentWord(TilePainter tile) {
    tile.select();
    currentWord += tile.getLetter();
    currentPositions.add(tile.getPosition());
    currentTiles.add(tile);
  }

  void resetCurrentWord(){
    for (TilePainter t in currentTiles) {
      t.reset();
    }
    currentTiles = new List<TilePainter>();
    currentWord = "";
    currentPositions = new List<Position>();
  }

  void _startTimer() {
    const second = const Duration(seconds: 1);
    if (_timer == null) {
      _timer = new Timer.periodic(second, (Timer timer) =>
          setState(() {
            if (_gametime < 1) {
              timer.cancel();
              if (widget.host) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScorePage(
                          title: "Game Scores",
                          host: widget.host,
                          hNetwork: widget.hNetwork,
                      )
                  ),
              );} else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScorePage(
                        title: "Game Scores",
                        host: widget.host,
                        gNetwork: widget.gNetwork,
                      )
                  ),
                );
              }
            } else {
              _gametime = _gametime - 1;
              _gamemins = _gametime ~/ 60;
              _gamesecs = _gametime - (_gamemins * 60);
              if (_gamesecs < 10) {
                gameSecsText = "0$_gamesecs";
              } else {
                gameSecsText = "$_gamesecs";
              }
            }
          }));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createGame();
    List<Widget> body = new List<Widget>();
    List<List<Widget>> rows = getRows();
    _startTimer();
    body.add(Text('$_gamemins' + ' : ' + gameSecsText));
    for (int i=0; i<widget.size; i++) {
      body.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: rows[i]));
    }
    body.add(Text("Selected Word:  $currentWord"));
    body.add(RaisedButton(child: Text("Enter Word"), color: Color(0xfff6adc6), onPressed: () {
      print(game.getSubmittedWords().length);
      bool b = game.isWordValid(currentPositions);
      print(game.getSubmittedWords().length);
      if (b) {
        for (TilePainter t in currentTiles) {
          t.changeColor(Colors.greenAccent);
        }
      } else {
        for (TilePainter t in currentTiles) {
          t.changeColor(Colors.redAccent);
        }
      }
      new Timer(const Duration(milliseconds: 300), () => resetCurrentWord());
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

  List<List<Widget>> getRows() {
    List<List<Widget>> rows = new List<List<Widget>>();
    for (int i=0; i<widget.size; i++) {
      tiles.add(new List<TilePainter>());
      rows.add(new List<Widget>());
      for (int j=0; j<widget.size; j++) {
        Position p =  Position(j,i);
        tiles[i].add(new  TilePainter(game.getLetterAtPosition(p), p));
        rows[i].add(
            GestureDetector( // figured this out at https://stackoverflow.com/questions/57100266/how-do-i-get-to-tap-on-a-custompaint-path-in-flutter-using-gesturedetect
              child: Container(
                  width: (MediaQuery.of(context).size.width - 20) / widget.size, // figured out how to get screen size at https://flutter.dev/docs/development/ui/layout/responsive
                  height: (MediaQuery.of(context).size.width - 20) / widget.size,
                  child: CustomPaint(painter: tiles[i][j])
              ),
              onTap: () {
                if (currentTiles.length == 0 || (p.isNeighbor(currentTiles.last.getPosition()) && !currentTiles.contains(tiles[i][j]))) {
                  addToCurrentWord(tiles[i][j]);
                }
              },
            )
        );
      }
    }
    return rows;
  }

}

class ScorePage extends StatefulWidget {
  ScorePage({Key key, this.title, this.host, this.hNetwork, this.gNetwork}) : super(key: key);

  final String title;

  final bool host;

  final HostNetworking hNetwork;

  final GuestNetworking gNetwork;

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage>{

  Scorer scorer;
  String name;
  int score;

  @override
  Widget build(BuildContext context) {
    //TODO
  }

  List<String> getOrder(Map<String, int> _scores) {
    List<String> order = new List<String>();
    List<String> names = _scores.keys;
    while (names.isNotEmpty) {
      int max = 0;
      for (int i = 0; i < names.length; i++) {
        if (_scores[names[max]] < _scores[names[i]]) {
          max = i;
        }
      }
      order.add(names[max]);
      names.removeAt(max);
    }
    return order;
  }
}
