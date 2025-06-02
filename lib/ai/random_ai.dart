import 'dart:math';

import 'package:othello/ai/base_ai.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/utils/constants.dart';

class RandomAI extends OthelloAI {
  final Board board;

  RandomAI({required this.board});

  @override
  Coordinate? selectMove(int player) {
    List<Coordinate> moves = board.getAllValidMoves(player);
    if (moves.isEmpty) return null;
    Coordinate move = moves[Random().nextInt(moves.length)];
    return move;
  }
}
