import 'package:get/get.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/utils/constants.dart';

class BoardController extends GetxController {
  final Board _board = Board();
  int _currentTurn = ITEM_BLACK;
  int _countItemWhite = 0;
  int _countItemBlack = 0;
  bool? _isWithBot;

  Board get board => _board;

  bool? get isWithBot => _isWithBot;
  set isWithBot(bool? value) {
    _isWithBot = value;
    update();
  }

  int get currentTurn => _currentTurn;
  set currentTurn(int value) {
    _currentTurn = value;
    update();
  }

  int get countItemWhite => _countItemWhite;
  set countItemWhite(int value) {
    _countItemWhite = value;
    update();
  }

  int get countItemBlack => _countItemBlack;
  set countItemBlack(int value) {
    _countItemBlack = value;
    update();
  }

  void clearMoves() {
    List<List<BlockUnit>> table = _board.getTable();
    for (var row = 0; row < 8; row++) {
      for (var col = 0; col < 8; col++) {
        if (table[row][col].value == ITEM_VALID_MOVE) {
          table[row][col].value = ITEM_EMPTY;
        }
      }
    }
    update();
  }

  void buildValidMoves(List<Coordinate> list) {
    List<List<BlockUnit>> table = _board.getTable();
    for (Coordinate c in list) {
      table[c.row][c.col].value = ITEM_VALID_MOVE;
    }
    update();
  }

  int inverseItem(int item) {
    if (item == ITEM_WHITE) return ITEM_BLACK;
    if (item == ITEM_BLACK) return ITEM_WHITE;
    return item;
  }

  void restart() {
    countItemWhite = 0;
    countItemBlack = 0;
    currentTurn = ITEM_BLACK;
    board.initTable();
    board.initTableItems();
    update();
  }

  bool pasteItemToTable(int row, int col, int item) {
    final table = board.getTable();
    if (table[row][col].value == ITEM_EMPTY) {
      List<Coordinate> listCoordinate = [];
      listCoordinate.addAll(board.checkRight(row, col, item));
      listCoordinate.addAll(board.checkDown(row, col, item));
      listCoordinate.addAll(board.checkLeft(row, col, item));
      listCoordinate.addAll(board.checkUp(row, col, item));
      listCoordinate.addAll(board.checkUpLeft(row, col, item));
      listCoordinate.addAll(board.checkUpRight(row, col, item));
      listCoordinate.addAll(board.checkDownLeft(row, col, item));
      listCoordinate.addAll(board.checkDownRight(row, col, item));

      if (listCoordinate.isNotEmpty) {
        board.getTable()[row][col].value = item;
        _inverseItemFromList(listCoordinate);
        currentTurn = inverseItem(currentTurn);

        // Recount pieces
        var (blackCount, whiteCount) = board.countItems();
        countItemWhite = whiteCount;
        countItemBlack = blackCount;
        return true;
      }
    }
    return false;
  }

  void _inverseItemFromList(List<Coordinate> list) {
    List<List<BlockUnit>> table = board.getTable();
    for (Coordinate c in list) {
      table[c.row][c.col].value = inverseItem(table[c.row][c.col].value);
    }
  }
}
