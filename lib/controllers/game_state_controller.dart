import 'package:get/get.dart';

// ignore: constant_identifier_names
enum GameDifficulty { Easy, Medium, Hard }

class GameStateController extends GetxController {
  bool _isGameOver = false;
  bool _isTwoPlayerMode = false;
  GameDifficulty _gameDifficulty = GameDifficulty.Easy;
  bool _showMoves = false;

  bool get isGameOver => _isGameOver;
  bool get isTwoPlayerMode => _isTwoPlayerMode;
  GameDifficulty get gameDifficulty => _gameDifficulty;
  bool get showMoves => _showMoves;

  void setGameDifficulty(GameDifficulty difficulty) {
    _gameDifficulty = difficulty;
  }

  void setIsGameOver(bool isGameOver) {
    _isGameOver = isGameOver;
    update();
  }

  void setIsTwoPlayerMode(bool isTwoPlayerMode) {
    _isTwoPlayerMode = isTwoPlayerMode;
    update();
  }

  void setShowMoves() {
    _showMoves = !showMoves;
    update();
  }
}
