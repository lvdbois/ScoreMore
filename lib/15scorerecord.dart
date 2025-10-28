import 'dart:ui';
import 'package:flutter/material.dart';

class FlutterScoreInputPage extends StatefulWidget {
  final String battingTeam;
  final String bowlingTeam;
  final bool isSecondInnings;
  final int? target;
  final String matchId;

  const FlutterScoreInputPage({
    super.key,
    required this.battingTeam,
    required this.bowlingTeam,
    this.isSecondInnings = false,
    this.target,
    required this.matchId,
  });

  @override
  _FlutterScoreInputPageState createState() => _FlutterScoreInputPageState();
}

class _FlutterScoreInputPageState extends State<FlutterScoreInputPage> {
  int totalScore = 0;
  int wickets = 0;
  int overs = 1;
  int balls = 0;
  bool isInningsEnded = false;
  String result = '';
  final int maxOvers = 20;

  List<Map<String, dynamic>> batsmen = [
    {
      "name": "Player1*",
      "runs": 1,
      "balls": 1,
      "fours": 0,
      "sixes": 0,
      "sr": 100,
    },
    {
      "name": "Player3",
      "runs": 16,
      "balls": 4,
      "fours": 2,
      "sixes": 1,
      "sr": 160,
    },
  ];
  Map<String, dynamic> bowler = {
    "name": "Player4",
    "overs": 1.0,
    "runs": 18,
    "wickets": 1,
    "econ": 18.0,
  };

  static const List<List<String>> buttonGrid = [
    ["DOT", "3", "OUT", "BYES"],
    ["1", "4", "WIDE", "LEG BYES"],
    ["2", "6", "NO BALL", "UNDO"],
  ];

  static const List<String> topCircles = ["1", "W", "4", "2", "6", "WD"];

  void buttonTap(String label) {
    setState(() {
      if (label == '1')
        totalScore += 1;
      else if (label == '2')
        totalScore += 2;
      else if (label == '3')
        totalScore += 3;
      else if (label == '4')
        totalScore += 4;
      else if (label == '6')
        totalScore += 6;
      else if (label == 'NO BALL')
        totalScore += 1;
      else if (label == 'WIDE')
        totalScore += 1;
      // Additional label logic as needed
    });
  }

  Widget glassContainer({
    required Widget child,
    double blur = 10,
    double opacity = 0.13,
    Color border = Colors.transparent,
    double borderRadius = 18,
    double borderWidth = 1.6,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            border: Border.all(color: border, width: borderWidth),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double crr = 0;
    double rrr = 7.8;
    int target = widget.target ?? 166;
    Color teal = Colors.tealAccent;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'scoremore',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(blurRadius: 20, color: Colors.black.withOpacity(0.8)),
            ],
            fontSize: 35,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          // Add a subtle frosted bg image or keep dark background for more glass effect
          Positioned.fill(
            child: Image.asset(
              'assets/crick.png',
              fit: BoxFit.cover,
              color: const Color.fromARGB(89, 0, 0, 0),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: 0,
                  ),
                  child: glassContainer(
                    border: const Color.fromARGB(90, 255, 255, 255),
                    borderRadius: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 7,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Team row, CRR/RRR/Target
                          Row(
                            children: [
                              Text(
                                "${widget.battingTeam}:",
                                style: TextStyle(
                                  color: teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "CRR:",
                                style: TextStyle(color: teal, fontSize: 17),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                crr.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // Text(
                              //      "RRR:",
                              //      style: TextStyle(color: teal, fontSize: 17),
                              // ),
                              const SizedBox(width: 5),
                              //  Text(
                              //    rrr.toString(),
                              //    style: TextStyle(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //      fontSize: 17,
                              //    ),
                              //      ),
                              const SizedBox(width: 13),
                              //  Text(
                              //    "Target:",
                              //    style: TextStyle(color: teal, fontSize: 17),
                              //  ),
                              const SizedBox(width: 5),
                              //  Text(
                              //    target.toString(),
                              //    style: TextStyle(
                              //      color: Colors.white,
                              //      fontWeight: FontWeight.bold,
                              //      fontSize: 17,
                              //    ),
                              //),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "$totalScore/$wickets",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 38,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${overs}.${balls} (20)",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   "${widget.battingTeam}  need ${target - totalScore} from ${120 - (overs * 6 + balls)} balls",
                          //   style: TextStyle(
                          //     color: teal,
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 15,
                          //   ),
                          // ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Batting Table Glass
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: 0,
                  ),
                  child: glassContainer(
                    border: const Color.fromARGB(90, 255, 255, 255),
                    opacity: 0.18,
                    borderRadius: 5,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Batter",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Runs",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Balls",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "4s",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "6s",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "SR",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        ...batsmen.map(
                          (player) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  player["name"] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "${player["runs"]}",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "${player["balls"]}",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "${player["fours"]}",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "${player["sixes"]}",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "${player["sr"]}",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bowler Table Glass
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: 0,
                  ),
                  child: glassContainer(
                    border: const Color.fromARGB(90, 255, 255, 255),
                    opacity: 0.18,
                    borderRadius: 5,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.23),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Bowler",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Overs",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Runs",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Wickets",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Economy",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                bowler["name"],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "${bowler["overs"]}",
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "${bowler["runs"]}",
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "${bowler["wickets"]}",
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "${bowler["econ"]}",
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Row of glass circular quick keys
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: topCircles.map((label) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  border: Border.all(color: teal, width: 2),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Keypad grid
                Expanded(
                  child: glassContainer(
                    border: const Color.fromARGB(
                      171,
                      255,
                      255,
                      255,
                    ).withOpacity(0.7),
                    borderRadius: 22,
                    opacity: 0.09,
                    blur: 15,
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      padding: const EdgeInsets.all(10),
                      children: buttonGrid.expand((row) => row).map((label) {
                        return GestureDetector(
                          onTap: () => buttonTap(label),
                          child: glassContainer(
                            blur: 12,
                            opacity: 0.10,
                            border: Colors.white.withOpacity(0.6),
                            borderRadius: 12,
                            borderWidth: 1.4,
                            child: Center(
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
