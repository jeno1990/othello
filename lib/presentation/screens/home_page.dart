import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/presentation/widgets/board_boarder_radius.dart';
import 'package:othello/presentation/widgets/menu_tab.dart';
import 'package:othello/utils/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final AudioPlayer _audioPlayer;
  late final Board board;
  int currentTurn = ITEM_BLACK;
  int countItemWhite = 0;
  int countItemBlack = 0;

  @override
  void initState() {
    board = Board();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    super.initState();
  }

  int randomItem() {
    Random random = Random();
    return random.nextInt(3);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff3A6098),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff3A6098),
                Color.fromARGB(255, 47, 105, 163),
                Color(0xff3A6098),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              MenuTab(),
              buildMenu(),
              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 8, color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
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
      onTap: () async {
        // setState(() {
        //   pasteItemToTable(row, col, currentTurn);
        // });
        await _audioPlayer.setSource(AssetSource('audio/click_sound_1.mp3'));
        // await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.resume();
        if (currentTurn == ITEM_BLACK) {
          bool moved = pasteItemToTable(row, col, ITEM_BLACK);
          if (moved) {
            setState(() {});
            playBotMove();
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: getBorderRadius(row, col),
        ),
        width: BLOCK_SIZE,
        height: BLOCK_SIZE,
        margin: EdgeInsets.all(1),
        child: Center(child: buildItem(board.getTable()[row][col])),
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
    if (board.getTable()[row][col].value == ITEM_EMPTY) {
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
        inverseItemFromList(listCoordinate);
        currentTurn = inverseItem(currentTurn);
        updateCountItem();
        return true;
      }
    }
    return false;
  }

  void inverseItemFromList(List<Coordinate> list) {
    List<List<BlockUnit>> table = board.getTable();
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
    List<List<BlockUnit>> table = board.getTable();
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
      board.initTable();
      board.initTableItems();
    });
  }

  // Level 1 AI Bot

  void playBotMove() {
    Future.delayed(Duration(milliseconds: 2000), () {
      List<Coordinate> moves = board.getAllValidMoves(ITEM_WHITE);
      if (moves.isNotEmpty) {
        Coordinate move = moves[Random().nextInt(moves.length)];
        setState(() {
          pasteItemToTable(move.row, move.col, ITEM_WHITE);
        });
      }
    });
  }
}
