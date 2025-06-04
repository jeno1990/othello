import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:othello/ai/base_ai.dart';
import 'package:othello/ai/greedy_ai.dart';
import 'package:othello/ai/minmax_ai.dart';
import 'package:othello/ai/random_ai.dart';
import 'package:othello/controllers/board_controller.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/controllers/sound_state_controller.dart';
import 'package:othello/controllers/user_profile_controller.dart';
import 'package:othello/models/block_unit.dart';

import 'package:othello/presentation/screens/settings_page.dart';
import 'package:othello/presentation/widgets/board_boarder_radius.dart';
import 'package:othello/presentation/widgets/count_dashboard.dart';
import 'package:othello/presentation/widgets/menu_tab.dart';
import 'package:othello/presentation/widgets/move_indicator.dart';
import 'package:othello/presentation/widgets/winner_pop.dart';
import 'package:othello/utils/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.isWithBot});
  final bool isWithBot;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final UserProfileController userController;
  late final GameStateController gameStateController;
  late final GameSoundContoller soundController;
  late final BoardController boardController;
  late final OthelloAI ai;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    userController = Get.find<UserProfileController>();
    gameStateController = Get.find<GameStateController>();
    soundController = Get.find<GameSoundContoller>();
    boardController = Get.find<BoardController>();

    if (gameStateController.gameDifficulty == GameDifficulty.Easy) {
      ai = RandomAI(board: boardController.board);
    } else if (gameStateController.gameDifficulty == GameDifficulty.Medium) {
      ai = GreedyAI(board: boardController.board);
    } else {
      ai = HardAI(board: boardController.board);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      boardController.clearMoves();
      if (boardController.isWithBot != null &&
          boardController.isWithBot != widget.isWithBot) {
        boardController.restart();
        boardController.isWithBot = widget.isWithBot;
      } else
        boardController.isWithBot ??= widget.isWithBot;

      _audioPlayer = AudioPlayer();

      // At start of game, show valid moves for black if desired:
      final available = boardController.board.getAllValidMoves(
        boardController.currentTurn,
      );
      boardController.buildValidMoves(available);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff3A6098),
        body: Container(
          decoration: const BoxDecoration(
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
              // ← Back arrow
              GestureDetector(
                onTap: () => Get.back(),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
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
                      onTap: () => Get.to(() => const SettingsPage()),
                    ),
                    MenuCard(
                      title: 'New',
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Are you sure?',
                          middleText:
                              'Do you want to start a new game? If not please click outside.',
                          confirmTextColor: Colors.white,
                          titlePadding: const EdgeInsets.only(top: 20),
                          confirm: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              boardController.restart();
                              final available = boardController.board
                                  .getAllValidMoves(
                                    boardController.currentTurn,
                                  );
                              boardController.buildValidMoves(available);
                              Navigator.pop(context);
                            },
                          ),
                          onConfirm: () {
                            Navigator.pop(context);
                            boardController.restart();
                            final available = boardController.board
                                .getAllValidMoves(boardController.currentTurn);
                            boardController.buildValidMoves(available);
                          },
                        );
                      },
                    ),
                    MenuCard(
                      title: 'Pass',
                      onTap: () {
                        boardController.clearMoves();
                        final nextTurn =
                            (boardController.currentTurn == ITEM_BLACK)
                                ? ITEM_WHITE
                                : ITEM_BLACK;
                        boardController.currentTurn = nextTurn;

                        if (!widget.isWithBot ||
                            boardController.currentTurn == ITEM_BLACK) {
                          final available = boardController.board
                              .getAllValidMoves(boardController.currentTurn);
                          boardController.buildValidMoves(available);
                        }

                        // If this is a bot game and it's now WHITE’s turn, let the bot move:
                        if (widget.isWithBot &&
                            boardController.currentTurn == ITEM_WHITE) {
                          _playBotMove();
                        }
                        if (boardController.isGameOver) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return WinnerPopup(
                                blackCount: boardController.countItemBlack,
                                whiteCount: boardController.countItemWhite,
                                onRestart: () {
                                  boardController.restart();
                                  final available = boardController.board
                                      .getAllValidMoves(
                                        boardController.currentTurn,
                                      );
                                  boardController.buildValidMoves(available);
                                },
                              );
                            },
                          );
                          return;
                        }
                      },
                    ),
                  ],
                ),
              ),

              // top counter
              GetBuilder<BoardController>(
                builder: (boardController) {
                  return CountDashboard(
                    count: boardController.countItemWhite,
                    difficulty: gameStateController.gameDifficulty,
                    isPlayer1: false,
                    isBot: widget.isWithBot,
                    name: 'Player 2',
                    currentTurn: boardController.currentTurn == ITEM_WHITE,
                  );
                },
              ),

              // board
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
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildTable(),
                    ),
                  ),
                ),
              ),

              // Bottom Counter
              GetBuilder<BoardController>(
                builder: (boardController) {
                  return CountDashboard(
                    count: boardController.countItemBlack,
                    difficulty: gameStateController.gameDifficulty,
                    isPlayer1: true,
                    isBot: false,
                    name:
                        (widget.isWithBot &&
                                userController.usernameValue.isNotEmpty)
                            ? userController.usernameValue
                            : 'Player 1',
                    currentTurn: boardController.currentTurn == ITEM_BLACK,
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  List<Row> _buildTable() {
    List<Row> rows = [];
    for (int r = 0; r < 8; r++) {
      List<Widget> cols = [];
      for (int c = 0; c < 8; c++) {
        cols.add(_buildBlockUnit(r, c));
      }
      rows.add(Row(mainAxisSize: MainAxisSize.min, children: cols));
    }
    return rows;
  }

  Widget _buildBlockUnit(int row, int col) {
    double blockSize = MediaQuery.of(context).size.width / 9;

    return GestureDetector(
      onTap: () async {
        // Play click sound if enabled
        if (soundController.isSoundEffectsOn) {
          await _audioPlayer.setSource(AssetSource('audio/click_sound_1.mp3'));
          await _audioPlayer.resume();
        }

        // 1) Clear any previous “valid‐move” markers
        boardController.clearMoves();

        // 2) Attempt to place a piece for the current turn
        final moved = boardController.pasteItemToTable(
          row,
          col,
          boardController.currentTurn,
        );

        // 3) If it was a legal move: rebuild valid moves for next turn
        if (moved) {
          // check if game is over
          if (boardController.isGameOver) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WinnerPopup(
                  blackCount: boardController.countItemBlack,
                  whiteCount: boardController.countItemWhite,
                  onRestart: () {
                    boardController.restart();
                    final available = boardController.board.getAllValidMoves(
                      boardController.currentTurn,
                    );
                    boardController.buildValidMoves(available);
                  },
                );
              },
            );
            return;
          }
          if (widget.isWithBot && boardController.currentTurn == ITEM_WHITE) {
            _playBotMove();
          } else {
            final available = boardController.board.getAllValidMoves(
              boardController.currentTurn,
            );
            boardController.buildValidMoves(available);
          }
        }
      },
      child: GetBuilder<BoardController>(
        builder: (boardController) {
          final block = boardController.board.getTable()[row][col];
          return Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: getBorderRadius(row, col),
            ),
            width: blockSize,
            height: blockSize,
            margin: const EdgeInsets.all(1),
            child: Center(child: _buildItem(block)),
          );
        },
      ),
    );
  }

  /// Return a Widget for black, white, or valid‐move indicator
  Widget _buildItem(BlockUnit block) {
    if (block.value == ITEM_BLACK) {
      return Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      );
    } else if (block.value == ITEM_WHITE) {
      return Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      );
    } else if (block.value == ITEM_VALID_MOVE) {
      return const ValidMoveIndicator();
    }
    return const SizedBox.shrink();
  }

  /// Let the AI pick a move after a 2s delay, then rebuild valid‐move markers.
  void _playBotMove() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      final move = ai.selectMove(ITEM_WHITE);
      if (move != null) {
        boardController.pasteItemToTable(move.row, move.col, ITEM_WHITE);
        if (boardController.isGameOver) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WinnerPopup(
                blackCount: boardController.countItemBlack,
                whiteCount: boardController.countItemWhite,
                onRestart: () {
                  boardController.restart();
                  final available = boardController.board.getAllValidMoves(
                    boardController.currentTurn,
                  );
                  boardController.buildValidMoves(available);
                },
              );
            },
          );
          return;
        }
      }

      final available = boardController.board.getAllValidMoves(
        boardController.currentTurn,
      );
      boardController.buildValidMoves(available);
    });
  }
}
