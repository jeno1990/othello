import 'package:othello/ai/base_ai.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/utils/constants.dart';

class GreedyAI implements OthelloAI {
  final Board board;
  GreedyAI({required this.board});
  @override
  Coordinate? selectMove(int player) {
    List<Coordinate> validMoves = board.getAllValidMoves(player);
    if (validMoves.isEmpty) return null;

    int maxFlips = -1;
    Coordinate? greedyMove;

    for (Coordinate move in validMoves) {
      List<Coordinate> listCoordinate = [];
      int row = move.row;
      int col = move.col;
      int item = ITEM_WHITE;
      listCoordinate.addAll(board.checkRight(row, col, item));
      listCoordinate.addAll(board.checkDown(row, col, item));
      listCoordinate.addAll(board.checkLeft(row, col, item));
      listCoordinate.addAll(board.checkUp(row, col, item));
      listCoordinate.addAll(board.checkUpLeft(row, col, item));
      listCoordinate.addAll(board.checkUpRight(row, col, item));
      listCoordinate.addAll(board.checkDownLeft(row, col, item));
      listCoordinate.addAll(board.checkDownRight(row, col, item));
      if (listCoordinate.length > maxFlips) {
        maxFlips = listCoordinate.length;
        greedyMove = move;
      }
    }
    return greedyMove;
  }
}
