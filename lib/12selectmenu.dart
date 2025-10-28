import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChecklistSelectPlayersPage extends StatefulWidget {
  final String teamName;
  final String matchId; // Pass the Firestore doc id for the match
  final String teamKey; // "teamA" or "teamB"
  final List<String>? exclude;

  const ChecklistSelectPlayersPage({
    super.key,
    required this.teamName,
    required this.matchId,
    required this.teamKey,
    this.exclude,
  });

  @override
  State<ChecklistSelectPlayersPage> createState() =>
      _ChecklistSelectPlayersPageState();
}

class _ChecklistSelectPlayersPageState
    extends State<ChecklistSelectPlayersPage> {
  List<bool> checked = [];
  bool isSaving = false;

  Widget glassButton(String text, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                borderRadius: BorderRadius.circular(36.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 22,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isSaving
                  ? const CircularProgressIndicator(color: Colors.tealAccent)
                  : Text(
                      text,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTeamPlayersToFirestore(List<String> selectedPlayers) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final matchDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('match') // 🔹 Changed from 'matches' to 'match'
          .doc(widget.matchId);

      // Update teamA or teamB as object with name and player array
      await matchDocRef.update({
        widget.teamKey: {'name': widget.teamName, 'players': selectedPlayers},
      });

      debugPrint("✅ ${widget.teamKey} players updated successfully!");
    } catch (e) {
      debugPrint("❌ Error saving team players: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving players: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.22),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${widget.teamName} Players',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 18, color: Colors.black54)],
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('players')
            .orderBy('name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading players'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.tealAccent),
            );
          }

          final docs = snapshot.data!.docs;
          List<String> allPlayers = docs
              .map((doc) => doc['name'] as String)
              .toList();

          // Exclude already selected players if provided
          if (widget.exclude != null) {
            allPlayers = allPlayers
                .where((p) => !widget.exclude!.contains(p))
                .toList();
          }

          // Initialize checkboxes
          if (checked.length != allPlayers.length) {
            checked = List.generate(allPlayers.length, (_) => false);
          }

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/crick.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: allPlayers.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 6.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.24),
                                width: 1.5,
                              ),
                            ),
                            child: CheckboxListTile(
                              value: checked[i],
                              onChanged: (val) {
                                setState(() {
                                  checked[i] = val ?? false;
                                });
                              },
                              title: Text(
                                allPlayers[i],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.tealAccent,
                              checkColor: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: glassButton(
                      "Done",
                      onTap: () async {
                        setState(() => isSaving = true);

                        final selected = <String>[];
                        for (int i = 0; i < allPlayers.length; i++) {
                          if (checked[i]) selected.add(allPlayers[i]);
                        }

                        await _saveTeamPlayersToFirestore(selected);

                        if (mounted) {
                          setState(() => isSaving = false);
                          Navigator.pop(context, selected);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.teamKey} players saved successfully!',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
