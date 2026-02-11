import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final String word = "LALIN"; // Mo kache
  final String hint = "Li klere lannwit, li pa solèy"; // Devinette pou LALIN

  int attempts = 5;
  String currentInput = "";
  late List<String> hiddenWord;
  bool gameOver = false;

  String lastResult = ""; // Mesaj pou dènye jwèt la

  @override
  void initState() {
    super.initState();
    hiddenWord = List.filled(word.length, '*');
  }

  void pressLetter(String letter) {
    if (gameOver) return;
    if (currentInput.length >= word.length) return;

    setState(() {
      currentInput += letter;
      hiddenWord[currentInput.length - 1] = letter;

      if (currentInput.length == word.length) {
        checkWord();
      }
    });
  }

  void checkWord() {
    if (currentInput == word) {
      setState(() {
        lastResult = "OU GENYEN 🎉";
        gameOver = true;
      });
    } else {
      setState(() {
        attempts--;
        lastResult = "OU PÈDI ❌";

        if (attempts == 0) {
          gameOver = true;
        } else {
          // rekòmanse mo a pou itilizatè ka re-ekri
          currentInput = "";
          hiddenWord = List.filled(word.length, '*');
        }
      });
    }
  }

  void restartGame() {
    setState(() {
      attempts = 5;
      currentInput = "";
      hiddenWord = List.filled(word.length, '*');
      gameOver = false;
      // lastResult rete la pou montre si li te pèdi anvan
    });
  }

  // ===== KLAVYE QWERTY 2 LIY =====
  Widget buildKeyboard() {
    return Column(
      children: [
        buildRow("QWERTYUIOPASD"),  // Liy 1
        buildRow("FGHJKLZXCVBN"),   // Liy 2
      ],
    );
  }

  Widget buildRow(String letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.split('').map((letter) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: gameOver ? null : () => pressLetter(letter),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(42, 48),
            ),
            child: Text(
              letter,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
  // ============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chans ki rete : $attempts"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mesaj dènye jwèt
            if (lastResult.isNotEmpty)
              Text(
                lastResult,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: lastResult.contains("PÈDI") ? Colors.red : Colors.green,
                ),
              ),
            SizedBox(height: 10),
            // Devinette
            Text(
              hint,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Asteriks pou mo kache
            Text(
              hiddenWord.join(' '),
              style: TextStyle(fontSize: 32, letterSpacing: 2),
            ),
            SizedBox(height: 30),
            // Klavye 2 liy
            buildKeyboard(),
            SizedBox(height: 20),
            // Bouton Rejwe
            if (gameOver)
              ElevatedButton(
                onPressed: restartGame,
                child: Text("Rejwe"),
              ),
          ],
        ),
      ),
    );
  }
}