import 'package:othello/ai/base_ai.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/utils/constants.dart';

class HardAI implements OthelloAI {
  final Board board;
  final int maxDepth;
  HardAI({required this.board, this.maxDepth = 4});

  @override
  Coordinate? selectMove(int player) {
    List<Coordinate> validMoves = board.getAllValidMoves(player);
    if (validMoves.isEmpty) return null;

    int bestScore = -999999;
    Coordinate? bestMove;

    for (Coordinate move in validMoves) {
      Board simulatedBoard = board.clone();
      simulatedBoard.applyMove(move, player);

      int score = _minimax(
        state: simulatedBoard,
        depth: maxDepth - 1,
        currentPlayer: _opposite(player),
        alpha: -999999,
        beta: 999999,
        rootPlayer: player,
      );
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove;
  }

  int _minimax({
    required Board state,
    required int depth,
    required int currentPlayer,
    required int alpha,
    required int beta,
    required int rootPlayer,
  }) {
    // Terminal or depth‐0 check
    if (depth == 0 || _isGameOver(state)) {
      return _evaluate(state, rootPlayer);
    }

    List<Coordinate> validMoves = state.getAllValidMoves(currentPlayer);

    // If no moves, must pass to opponent
    if (validMoves.isEmpty) {
      return _minimax(
        state: state,
        depth: depth - 1,
        currentPlayer: _opposite(currentPlayer),
        alpha: alpha,
        beta: beta,
        rootPlayer: rootPlayer,
      );
    }

    // Maximizing when currentPlayer == rootPlayer
    if (currentPlayer == rootPlayer) {
      int maxEval = -1000000;
      for (Coordinate move in validMoves) {
        Board nextState = state.clone();
        nextState.applyMove(move, currentPlayer);

        int eval = _minimax(
          state: nextState,
          depth: depth - 1,
          currentPlayer: _opposite(currentPlayer),
          alpha: alpha,
          beta: beta,
          rootPlayer: rootPlayer,
        );
        maxEval = eval > maxEval ? eval : maxEval;
        alpha = eval > alpha ? eval : alpha;
        if (alpha >= beta) {
          break; // β‐cutoff
        }
      }
      return maxEval;
    }
    // Minimizing when currentPlayer != rootPlayer
    else {
      int minEval = 1000000;
      for (Coordinate move in validMoves) {
        Board nextState = state.clone();
        nextState.applyMove(move, currentPlayer);

        int eval = _minimax(
          state: nextState,
          depth: depth - 1,
          currentPlayer: _opposite(currentPlayer),
          alpha: alpha,
          beta: beta,
          rootPlayer: rootPlayer,
        );
        minEval = eval < minEval ? eval : minEval;
        beta = eval < beta ? eval : beta;
        if (alpha >= beta) {
          break; // α‐cutoff
        }
      }
      return minEval;
    }
  }

  int _evaluate(Board state, int rootPlayer) {
    final int opponent = _opposite(rootPlayer);

    // 1. Material (disc count)
    int myDiscs = 0, oppDiscs = 0;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        int v = state.table[r][c].value;
        if (v == rootPlayer)
          myDiscs++;
        else if (v == opponent)
          oppDiscs++;
      }
    }
    int scoreMaterial = myDiscs - oppDiscs;

    // 2. Mobility
    int myMoves = state.getAllValidMoves(rootPlayer).length;
    int oppMoves = state.getAllValidMoves(opponent).length;
    int scoreMobility = myMoves - oppMoves;

    // 3. Corner occupancy
    final List<Coordinate> corners = [
      Coordinate(row: 0, col: 0),
      Coordinate(row: 0, col: 7),
      Coordinate(row: 7, col: 0),
      Coordinate(row: 7, col: 7),
    ];
    int myCorners = 0, oppCorners = 0;
    for (var corner in corners) {
      int v = state.table[corner.row][corner.col].value;
      if (v == rootPlayer)
        myCorners++;
      else if (v == opponent)
        oppCorners++;
    }
    int scoreCorners = myCorners - oppCorners;

    // Weights (tweak as needed)
    const int wMaterial = 1;
    const int wMobility = 2;
    const int wCorner = 25;

    return (wMaterial * scoreMaterial) +
        (wMobility * scoreMobility) +
        (wCorner * scoreCorners);
  }

  bool _isGameOver(Board state) {
    // Game over if neither player has any valid move
    bool noRootMoves =
        state.getAllValidMoves(ITEM_WHITE).isEmpty &&
        state.getAllValidMoves(ITEM_BLACK).isEmpty;
    return noRootMoves;
  }

  int _opposite(int player) {
    return (player == ITEM_WHITE) ? ITEM_BLACK : ITEM_WHITE;
  }
}
