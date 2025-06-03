import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:othello/ai/base_ai.dart';
import 'package:othello/ai/greedy_ai.dart';
import 'package:othello/ai/random_ai.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/controllers/sound_state_controller.dart';
import 'package:othello/controllers/user_profile_controller.dart';
import 'package:othello/game/board.dart';
import 'package:othello/models/block_unit.dart';
import 'package:othello/models/coordinate.dart';
import 'package:othello/presentation/screens/settings_page.dart';
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
  late final UserProfileController userController;
  late final AudioPlayer _audioPlayer;
  late final Board board;
  int currentTurn = ITEM_BLACK;
  int countItemWhite = 0;
  int countItemBlack = 0;
  late OthelloAI ai;

  @override
  void initState() {
    userController = Get.find<UserProfileController>();
    board = Board();
    // ai = RandomAI(board: board);
    ai = GreedyAI(board: board);
    _audioPlayer = Get.find<AudioPlayer>();
    // _audioPlayer.setReleaseMode(ReleaseMode.stop);
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
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/image/back.png'),
                        height: 20,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuCard(
                      title: 'Menu',
                      onTap: () {
                        Get.to(() => SettingsPage());
                      },
                    ),
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
                difficulty: Get.find<GameStateController>().gameDifficulty,
                isPlayer1: !widget.isWithBot,
                isBot: widget.isWithBot,
                name: 'Player 1',
                currentTurn: currentTurn == ITEM_WHITE,
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
                difficulty: Get.find<GameStateController>().gameDifficulty,
                isPlayer1: widget.isWithBot,
                isBot: false,
                name:
                    widget.isWithBot
                        ? (userController.usernameValue != ''
                            ? userController.usernameValue
                            : 'Player 1')
                        : 'Player 2',
                currentTurn: currentTurn == ITEM_BLACK,
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
        final soundController = Get.find<GameSoundContoller>();
        if (soundController.isSoundEffectsOn) {
          await _audioPlayer.setSource(AssetSource('audio/click_sound_1.mp3'));
          await _audioPlayer.resume();
        }
        clearMoves();
        if (currentTurn == ITEM_BLACK) {
          bool moved = pasteItemToTable(row, col, ITEM_BLACK);
          setState(() {});
          if (moved && widget.isWithBot) {
            playBotMove();
          }
        } else if (currentTurn == ITEM_WHITE && !widget.isWithBot) {
          pasteItemToTable(row, col, ITEM_WHITE);
          setState(() {});
        }
        if (!widget.isWithBot || currentTurn == ITEM_BLACK) {
          List<Coordinate> availableMoves = board.getAllValidMoves(currentTurn);
          buildValidMoves(availableMoves);
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
    } else if (block.value == ITEM_VALID_MOVE) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/image/gif.webp'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Container();
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
        inverseItemFromList(listCoordinate);
        currentTurn = inverseItem(currentTurn);
        var (blackCount, whiteCount) = board.countItems();
        countItemWhite = whiteCount;
        countItemBlack = blackCount;
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

  void buildValidMoves(List<Coordinate> list) {
    List<List<BlockUnit>> table = board.getTable();
    for (Coordinate c in list) {
      table[c.row][c.col].value = ITEM_VALID_MOVE;
    }
    setState(() {});
  }

  void clearMoves() {
    List<List<BlockUnit>> table = board.getTable();
    for (var row = 0; row < 8; row++) {
      for (var col = 0; col < 8; col++) {
        if (table[row][col].value == ITEM_VALID_MOVE) {
          table[row][col].value = ITEM_EMPTY;
        }
      }
    }
    setState(() {});
  }

  int inverseItem(int item) {
    if (item == ITEM_WHITE) {
      return ITEM_BLACK;
    } else if (item == ITEM_BLACK) {
      return ITEM_WHITE;
    }
    return item;
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
      Coordinate? move = ai.selectMove(ITEM_WHITE);
      if (move != null) {
        pasteItemToTable(move.row, move.col, ITEM_WHITE);
        setState(() {});
      }
      List<Coordinate> availableMoves = board.getAllValidMoves(currentTurn);
      buildValidMoves(availableMoves);
    });
  }
}
