import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/controllers/sound_state_controller.dart';
import 'package:othello/presentation/screens/user_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showMoves = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: GetBuilder<GameStateController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Difficulty
                GestureDetector(
                  onTap: () => _showDifficultyBottomSheet(context, controller),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Difficulty',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          _difficultyLabel(controller.gameDifficulty),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                GetBuilder<GameStateController>(
                  builder: (gameController) {
                    return _buildToggleTile(
                      'Show Moves',
                      gameController.showMoves,
                      (val) {
                        gameController.setShowMoves();
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                GetBuilder<GameSoundContoller>(
                  builder: (soundController) {
                    return _buildToggleTile(
                      'Background Music',
                      soundController.isBackgroundSoundOn,
                      (val) async {
                        final audioPlayer = Get.find<AudioPlayer>();

                        try {
                          if (soundController.isBackgroundSoundOn) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.resume();
                          }

                          soundController.toggleBackgroundMusic();
                        } catch (e) {
                          print('Audio error: $e');
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                GetBuilder<GameSoundContoller>(
                  builder: (soundController) {
                    return _buildToggleTile(
                      'Key Sound',
                      soundController.isSoundEffectsOn,
                      (val) {
                        soundController.toggleKeySound();
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserProfilePage());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'User Profile',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.greenAccent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }

  void _showDifficultyBottomSheet(
    BuildContext context,
    GameStateController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SELECT DIFFICULTY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 25),
              _difficultyRow(
                context,
                'EASY',
                Colors.green,
                controller.gameDifficulty == GameDifficulty.Easy,
                () {
                  controller.setGameDifficulty(GameDifficulty.Easy);
                  controller.update();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              _difficultyRow(
                context,
                'MEDIUM',
                Colors.orange,
                controller.gameDifficulty == GameDifficulty.Medium,
                () {
                  controller.setGameDifficulty(GameDifficulty.Medium);
                  controller.update();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              _difficultyRow(
                context,
                'HARD',
                Colors.red,
                controller.gameDifficulty == GameDifficulty.Hard,
                () {
                  controller.setGameDifficulty(GameDifficulty.Hard);
                  controller.update();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultyRow(
    BuildContext context,
    String label,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 30,
          child:
              isSelected
                  ? const Icon(Icons.play_arrow, color: Colors.white, size: 26)
                  : const SizedBox.shrink(),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            minimumSize: const Size(220, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  String _difficultyLabel(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.Easy:
        return 'Easy';
      case GameDifficulty.Medium:
        return 'Medium';
      case GameDifficulty.Hard:
        return 'Hard';
    }
  }
}
