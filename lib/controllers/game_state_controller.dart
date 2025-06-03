import 'package:get/get.dart';

// ignore: constant_identifier_names
enum GameDifficulty { Easy, Medium, Hard }

class GameStateController extends GetxController {
  bool _isGameOver = false;
  bool _isTwoPlayerMode = false;
  GameDifficulty _gameDifficulty = GameDifficulty.Easy;

  bool get isGameOver => _isGameOver;
  bool get isTwoPlayerMode => _isTwoPlayerMode;
  GameDifficulty get gameDifficulty => _gameDifficulty;

  void setGameDifficulty(GameDifficulty difficulty) {
    _gameDifficulty = difficulty;
  }

  void setIsGameOver(bool isGameOver) {
    _isGameOver = isGameOver;
  }

  void setIsTwoPlayerMode(bool isTwoPlayerMode) {
    _isTwoPlayerMode = isTwoPlayerMode;
  }
}
