import 'dart:ui';
import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  int score = 0, wickets = 0, balls = 0;
  int player1Runs = 0, player1Balls = 0, player1Fours = 0, player1Sixes = 0;
  int player2Runs = 0, player2Balls = 0, player2Fours = 0, player2Sixes = 0;
  int bowlerRuns = 0, bowlerBalls = 0, bowlerWickets = 0;

  bool strikeOnPlayer1 = true;

  void addRun(int run, {bool isExtra = false}) {
    setState(() {
      score += run;
      bowlerRuns += run;

      if (!isExtra) {
        balls++;
        bowlerBalls++;

        if (strikeOnPlayer1) {
          player1Runs += run;
          player1Balls++;
          if (run == 4) player1Fours++;
          if (run == 6) player1Sixes++;
        } else {
          player2Runs += run;
          player2Balls++;
          if (run == 4) player2Fours++;
          if (run == 6) player2Sixes++;
        }

        if (run % 2 == 1) strikeOnPlayer1 = !strikeOnPlayer1;
      }
    });
  }

  void addWicket() {
    setState(() {
      wickets++;
      balls++;
      bowlerBalls++;
    });
  }

  double get overs => bowlerBalls ~/ 6 + (bowlerBalls % 6) / 10.0;
  double get runRate => balls > 0 ? score / (balls / 6) : 0;
  double get player1SR =>
      player1Balls > 0 ? (player1Runs / player1Balls) * 100 : 0;
  double get player2SR =>
      player2Balls > 0 ? (player2Runs / player2Balls) * 100 : 0;
  double get economy => bowlerBalls > 0 ? (bowlerRuns / (bowlerBalls / 6)) : 0;

  Widget glassBox({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade900,
      body: SafeArea(
        child: Column(
          children: [
            // 🏏 Score Panel
            glassBox(
              child: Column(
                children: [
                  Text(
                    "TEAM1: $score/$wickets",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Overs: ${balls ~/ 6}.${balls % 6} | CRR: ${runRate.toStringAsFixed(2)} | Target: 166",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Batter Stats
            glassBox(
              child: Column(
                children: [
                  Text(
                    "Batters",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          "Name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text("R", style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text("B", style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text(
                          "4s",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "6s",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "SR",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              "Player1${strikeOnPlayer1 ? "*" : ""}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player1Runs",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player1Balls",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player1Fours",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player1Sixes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              player1SR.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              "Player2${!strikeOnPlayer1 ? "*" : ""}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player2Runs",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player2Balls",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player2Fours",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$player2Sixes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              player2SR.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Bowler Stats
            glassBox(
              child: Column(
                children: [
                  Text(
                    "Bowler",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          "Name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text("O", style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text("R", style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text("W", style: TextStyle(color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text(
                          "Eco",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              "Player4",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              overs.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$bowlerRuns",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              "$bowlerWickets",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              economy.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),

            // Button Panel
            glassBox(
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 2,
                children: [
                  scoreButton("0", () => addRun(0)),
                  scoreButton("1", () => addRun(1)),
                  scoreButton("2", () => addRun(2)),
                  scoreButton("3", () => addRun(3)),
                  scoreButton("4", () => addRun(4)),
                  scoreButton("6", () => addRun(6)),
                  scoreButton("W", addWicket),
                  scoreButton("Wide", () => addRun(1, isExtra: true)),
                  scoreButton("No Ball", () => addRun(1, isExtra: true)),
                  scoreButton("Dot", () => addRun(0)),
                  scoreButton("Bye", () {}),
                  scoreButton("Undo", () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scoreButton(String text, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.tealAccent.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
