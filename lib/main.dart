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
  final String word = "AYITI"; 
  final String hint = "non premye repiblik nwa endepandan"; 

  int attempts = 5;
  String currentInput = "";
  late List<String> hiddenWord;
  bool gameOver = false;

  String lastResult = ""; 

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
        lastResult = "OU PÈDI ";

        if (attempts == 0) {
          gameOver = true;
        } else {
         
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
  
    });
  }

  // ===== KLAVYE QWERTY 2 LIY =====
  Widget buildKeyboard() {
    return Column(
      children: [
        buildRow("QWERTYUIOPASD"), 
        buildRow("FGHJKLZXCVBN"),   
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
            
            Text(
              hint,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            
            Text(
              hiddenWord.join(' '),
              style: TextStyle(fontSize: 32, letterSpacing: 2),
            ),
            SizedBox(height: 30),
            
            buildKeyboard(),
            SizedBox(height: 20),
            
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