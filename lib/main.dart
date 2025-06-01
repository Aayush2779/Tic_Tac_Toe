import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool oTurn = true;
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  List<int> winningIndices = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Player 1',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        xScore.toString(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Player 2',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        oScore.toString(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      bool isWinningCell = winningIndices.contains(index);
                      return GestureDetector(
                        onTap: () {
                          _tapped(index);
                        },
                        child: Transform.scale(
                          scale: isWinningCell ? 1.1 : 1.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: isWinningCell
                                  ? Colors.amberAccent.withOpacity(0.7)
                                  : Colors.white,
                              border: Border.all(
                                color: isWinningCell ? Colors.red : Colors.black,
                                width: isWinningCell ? 4 : 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                displayElement[index],
                                style: TextStyle(
                                  fontSize: 35.sp,
                                  color: displayElement[index] == 'O'
                                      ? Colors.redAccent
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: _clearScoreBoard,
              child: const Text("Clear Score Board"),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (displayElement[index] == '') {
        displayElement[index] = oTurn ? 'O' : 'X';
        filledBoxes++;
        oTurn = !oTurn;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combo in winningCombinations) {
      String a = displayElement[combo[0]];
      String b = displayElement[combo[1]];
      String c = displayElement[combo[2]];

      if (a == b && b == c && a != '') {
        setState(() {
          winningIndices = combo;
        });
        showWinSnackBar(a);
        return;
      }
    }

    if (filledBoxes == 9) {
      showDrawSnackBar();
    }
  }

  void showWinSnackBar(String winner) {
    if (winner == 'O') {
      oScore++;
    } else {
      xScore++;
    }

    String playerText = winner == 'O' ? 'Player 2' : 'Player 1';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 20),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 75),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "\"$playerText\" is Winner!!!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _clearBoard();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDrawSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 20),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 75),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Draw",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _clearBoard();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayElement[i] = '';
      }
      filledBoxes = 0;
      winningIndices.clear();
    });
  }

  void _clearScoreBoard() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _clearBoard();
    });
  }
}
