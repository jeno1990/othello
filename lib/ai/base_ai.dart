import 'package:othello/models/coordinate.dart';

abstract class OthelloAI {
  Coordinate? selectMove(int player);
}
