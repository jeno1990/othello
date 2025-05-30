import 'dart:math';

import 'package:flutter/material.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/utils/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Board board = BoardImplementation();
  late List<List<BlockUnit>> table;
  int currentTurn = ITEM_BLACK;
  int countItemWhite = 0;
  int countItemBlack = 0;

  @override
  void initState() {
    initTable();
    initTableItems();
    super.initState();
  }

  void initTable() {
    table = [];
    for (int row = 0; row < 8; row++) {
      List<BlockUnit> list = [];
      for (int col = 0; col < 8; col++) {
        list.add(BlockUnit(value: ITEM_EMPTY));
      }
      table.add(list);
    }
  }

  void initTableItems() {
    table[3][3].value = ITEM_WHITE;
    table[4][3].value = ITEM_BLACK;
    table[3][4].value = ITEM_BLACK;
    table[4][4].value = ITEM_WHITE;
  }

  int randomItem() {
    Random random = Random();
    return random.nextInt(3);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xffecf0f1),
          child: Column(
            children: <Widget>[
              buildMenu(),
              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff34495e),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 8, color: Color(0xff2c3e50)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildTable(),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentTurn = ITEM_WHITE;
                      });
                      playBotMove();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff2c3e50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Pass",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              buildScoreTab(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMenu() {
    return Container(
      padding: EdgeInsets.only(top: 36, bottom: 12, left: 16, right: 16),
      color: Color(0xff34495e),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              restart();
            },
            child: Container(
              constraints: BoxConstraints(minWidth: 120),
              decoration: BoxDecoration(
                color: Color(0xff27ae60),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  Text(
                    "New Game",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            constraints: BoxConstraints(minWidth: 120),
            decoration: BoxDecoration(
              color: Color(0xffbbada0),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "TURN",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: buildItem(BlockUnit(value: currentTurn)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScoreTab() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            color: Color(0xff34495e),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: buildItem(BlockUnit(value: ITEM_WHITE)),
                ),
                Text(
                  "x $countItemWhite",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Color(0xffbdc3c7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: buildItem(BlockUnit(value: ITEM_BLACK)),
                ),
                Text(
                  "x $countItemBlack",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Row> buildTable() {
    List<Row> listRow = [];
    for (int row = 0; row < 8; row++) {
      List<Widget> listCol = [];
      for (int col = 0; col < 8; col++) {
        listCol.add(buildBlockUnit(row, col));
      }
      Row rowWidget = Row(mainAxisSize: MainAxisSize.min, children: listCol);
      listRow.add(rowWidget);
    }
    return listRow;
  }

  Widget buildBlockUnit(int row, int col) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   pasteItemToTable(row, col, currentTurn);
        // });
        if (currentTurn == ITEM_BLACK) {
          bool moved = pasteItemToTable(row, col, ITEM_BLACK);
          if (moved) {
            setState(() {}); // Refresh UI for human move
            playBotMove();
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff27ae60),
          borderRadius: BorderRadius.circular(2),
        ),
        width: BLOCK_SIZE,
        height: BLOCK_SIZE,
        margin: EdgeInsets.all(2),
        child: Center(child: buildItem(table[row][col])),
      ),
    );
  }

  Widget buildItem(BlockUnit block) {
    if (block.value == ITEM_BLACK) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      );
    } else if (block.value == ITEM_WHITE) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      );
    }
    return Container();
  }

  bool pasteItemToTable(int row, int col, int item) {
    if (table[row][col].value == ITEM_EMPTY) {
      List<Coordinate> listCoordinate = [];
      listCoordinate.addAll(board.checkRight(row, col, item, table));
      listCoordinate.addAll(board.checkDown(row, col, item, table));
      listCoordinate.addAll(board.checkLeft(row, col, item, table));
      listCoordinate.addAll(board.checkUp(row, col, item, table));
      listCoordinate.addAll(board.checkUpLeft(row, col, item, table));
      listCoordinate.addAll(board.checkUpRight(row, col, item, table));
      listCoordinate.addAll(board.checkDownLeft(row, col, item, table));
      listCoordinate.addAll(board.checkDownRight(row, col, item, table));

      if (listCoordinate.isNotEmpty) {
        table[row][col].value = item;
        inverseItemFromList(listCoordinate);
        currentTurn = inverseItem(currentTurn);
        updateCountItem();
        return true;
      }
    }
    return false;
  }

  void inverseItemFromList(List<Coordinate> list) {
    for (Coordinate c in list) {
      table[c.row][c.col].value = inverseItem(table[c.row][c.col].value);
    }
  }

  int inverseItem(int item) {
    if (item == ITEM_WHITE) {
      return ITEM_BLACK;
    } else if (item == ITEM_BLACK) {
      return ITEM_WHITE;
    }
    return item;
  }

  void updateCountItem() {
    countItemBlack = 0;
    countItemWhite = 0;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (table[row][col].value == ITEM_BLACK) {
          countItemBlack++;
        } else if (table[row][col].value == ITEM_WHITE) {
          countItemWhite++;
        }
      }
    }
  }

  void restart() {
    setState(() {
      countItemWhite = 0;
      countItemBlack = 0;
      currentTurn = ITEM_BLACK;
      initTable();
      initTableItems();
    });
  }

  // Level 1 AI
  List<Coordinate> getAllValidMoves(int playerItem) {
    List<Coordinate> validMoves = [];
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (table[row][col].value == ITEM_EMPTY) {
          // Try placing the item hypothetically
          if (board.checkRight(row, col, playerItem, table).isNotEmpty ||
              board.checkLeft(row, col, playerItem, table).isNotEmpty ||
              board.checkDown(row, col, playerItem, table).isNotEmpty ||
              board.checkUp(row, col, playerItem, table).isNotEmpty ||
              board.checkUpLeft(row, col, playerItem, table).isNotEmpty ||
              board.checkUpRight(row, col, playerItem, table).isNotEmpty ||
              board.checkDownLeft(row, col, playerItem, table).isNotEmpty ||
              board.checkDownRight(row, col, playerItem, table).isNotEmpty) {
            validMoves.add(Coordinate(row: row, col: col));
          }
        }
      }
    }
    return validMoves;
  }

  void playBotMove() {
    Future.delayed(Duration(milliseconds: 2000), () {
      List<Coordinate> moves = getAllValidMoves(ITEM_WHITE);
      if (moves.isNotEmpty) {
        Coordinate move = moves[Random().nextInt(moves.length)];
        setState(() {
          pasteItemToTable(move.row, move.col, ITEM_WHITE);
        });
      }
    });
  }
}
