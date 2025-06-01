import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/presentation/widgets/board_boarder_radius.dart';
import 'package:othello/presentation/widgets/count_dashboard.dart';
import 'package:othello/presentation/widgets/menu_tab.dart';
import 'package:othello/utils/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.isWithBot});
  final bool isWithBot;

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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuCard(title: 'Menu', onTap: () {}),
                    MenuCard(
                      title: 'New',
                      onTap: () {
                        restart();
                      },
                    ),
                    MenuCard(
                      title: 'Pass',
                      onTap: () {
                        setState(() {
                          currentTurn = ITEM_WHITE;
                        });
                        playBotMove();
                      },
                    ),
                  ],
                ),
              ),

              CountDashboard(
                count: countItemWhite,
                difficulty: GameDifficulty.easy,
                isPlayer1: false,
                isBot: true,
                name: '',
                currentTurn: currentTurn == ITEM_BLACK,
              ),

              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 8, color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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

              CountDashboard(
                count: countItemBlack,
                difficulty: GameDifficulty.easy,
                isPlayer1: true,
                isBot: false,
                name: 'Jeno',
                currentTurn: currentTurn == ITEM_WHITE,
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
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
