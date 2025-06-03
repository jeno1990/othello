import 'package:get/get.dart';
import 'package:othello/controllers/board_controller.dart';

// ignore: constant_identifier_names
enum GameDifficulty { Easy, Medium, Hard }

class GameStateController extends GetxController {
  bool _isGameOver = false;
  bool _isTwoPlayerMode = false;
  GameDifficulty _gameDifficulty = GameDifficulty.Easy;
  bool _showMoves = true;

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
    final boardState = Get.find<BoardController>();
    _showMoves = !showMoves;
    update();
    if (!_showMoves) {
      boardState.clearMoves();
    } else {
      boardState.buildValidMoves(
        boardState.board.getAllValidMoves(boardState.currentTurn),
      );
    }
  }
}
