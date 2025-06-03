// import 'base_ai.dart';
// import '../models/coordinate.dart';
// import '../models/block_unit.dart';
// import '../game/board.dart';

// class MinimaxAI implements OthelloAI {
//   final Board board;

//   final int maxDepth = 2;

//   MinimaxAI({required this.board});

//   @override
//   Coordinate? selectMove(int player) {
//     List<Coordinate> validMoves = board.getAllValidMoves(player);
//     if (validMoves.isEmpty) return null;

//     int bestScore = -9999;
//     Coordinate? bestMove;

//     for (Coordinate move in validMoves) {
//       var copiedBoard = board.cloneBoard(board);
//       Board.placeAndFlip(copiedBoard, move.row, move.col, player);

//       int score = _minimax(copiedBoard, _opponent(player), 1, false, player);
//       if (score > bestScore) {
//         bestScore = score;
//         bestMove = move;
//       }
//     }

//     return bestMove;
//   }

//   int _minimax(List<List<BlockUnit>> board, int currentPlayer, int depth, bool maximizing, int aiPlayer) {
//     if (depth >= maxDepth) return Board.evaluateBoard(board, aiPlayer);

//     List<Coordinate> validMoves = Board.getAllValidMoves(board, currentPlayer);
//     if (validMoves.isEmpty) return Board.evaluateBoard(board, aiPlayer);

//     int bestScore = maximizing ? -9999 : 9999;

//     for (Coordinate move in validMoves) {
//       var copy = Board.cloneBoard(board);
//       Board.placeAndFlip(copy, move.row, move.col, currentPlayer);

//       int score = _minimax(copy, _opponent(currentPlayer), depth + 1, !maximizing, aiPlayer);
//       bestScore = maximizing
//           ? (score > bestScore ? score : bestScore)
//           : (score < bestScore ? score : bestScore);
//     }

//     return bestScore;
//   }

//   int _opponent(int player) => player == 1 ? 2 : 1;
// }
