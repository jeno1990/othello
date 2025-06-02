import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';

abstract class OthelloAI {
  Coordinate? selectMove(int player);
}
