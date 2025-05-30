import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/utils/constants.dart';

abstract class Board {
  List<Coordinate> checkRight(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
  List<Coordinate> checkLeft(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
  List<Coordinate> checkUp(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
  List<Coordinate> checkDown(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
  List<Coordinate> checkUpLeft(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
  List<Coordinate> checkUpRight(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
  List<Coordinate> checkDownLeft(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
  List<Coordinate> checkDownRight(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  );
}

class BoardImplementation implements Board {
  @override
  List<Coordinate> checkRight(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (col + 1 < 8) {
      for (int c = col + 1; c < 8; c++) {
        if (table[row][c].value == item) {
          return list;
        } else if (table[row][c].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return [];
  }

  @override
  List<Coordinate> checkLeft(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (col - 1 >= 0) {
      for (int c = col - 1; c >= 0; c--) {
        if (table[row][c].value == item) {
          return list;
        } else if (table[row][c].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return [];
  }

  @override
  List<Coordinate> checkDown(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (row + 1 < 8) {
      for (int r = row + 1; r < 8; r++) {
        if (table[r][col].value == item) {
          return list;
        } else if (table[r][col].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return [];
  }

  @override
  List<Coordinate> checkUp(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (row - 1 >= 0) {
      for (int r = row - 1; r >= 0; r--) {
        if (table[r][col].value == item) {
          return list;
        } else if (table[r][col].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return [];
  }

  @override
  List<Coordinate> checkUpLeft(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (row - 1 >= 0 && col - 1 >= 0) {
      int r = row - 1;
      int c = col - 1;
      while (r >= 0 && c >= 0) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c--;
      }
    }
    return [];
  }

  @override
  List<Coordinate> checkUpRight(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (row - 1 >= 0 && col + 1 < 8) {
      int r = row - 1;
      int c = col + 1;
      while (r >= 0 && c < 8) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c++;
      }
    }
    return [];
  }

  @override
  List<Coordinate> checkDownLeft(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (row + 1 < 8 && col - 1 >= 0) {
      int r = row + 1;
      int c = col - 1;
      while (r < 8 && c >= 0) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c--;
      }
    }
    return [];
  }

  @override
  List<Coordinate> checkDownRight(
    int row,
    int col,
    int item,
    List<List<BlockUnit>> table,
  ) {
    List<Coordinate> list = [];
    if (row + 1 < 8 && col + 1 < 8) {
      int r = row + 1;
      int c = col + 1;
      while (r < 8 && c < 8) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c++;
      }
    }
    return [];
  }
}
