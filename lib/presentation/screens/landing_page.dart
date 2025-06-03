import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:othello/controllers/board_controller.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/controllers/sound_state_controller.dart';
import 'package:othello/presentation/screens/game_page.dart';
import 'package:othello/presentation/widgets/play_button.dart';
import 'package:othello/presentation/screens/settings_page.dart';
import 'package:othello/presentation/widgets/play_button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final soundController = Get.find<GameSoundContoller>();
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _audioPlayer = Get.find<AudioPlayer>();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.setSource(AssetSource('audio/background_music.wav'));
      await _audioPlayer.resume();
    });
  }

  @override
  void dispose() {
    // _audioPlayer.dispose();
    super.dispose();
  }

  void _showDifficultyBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => GetBuilder<GameStateController>(
            builder:
                (controller) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white24,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'SELECT DIFFICULTY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _difficultyButton(
                              'EASY',
                              Colors.green,
                              controller.gameDifficulty == GameDifficulty.Easy,
                              () {
                                controller.setGameDifficulty(
                                  GameDifficulty.Easy,
                                );
                                controller.update();
                              },
                            ),
                            const SizedBox(height: 15),
                            _difficultyButton(
                              'MEDIUM',
                              Colors.orange,
                              controller.gameDifficulty ==
                                  GameDifficulty.Medium,
                              () {
                                controller.setGameDifficulty(
                                  GameDifficulty.Medium,
                                );
                                controller.update();
                              },
                            ),
                            const SizedBox(height: 15),
                            _difficultyButton(
                              'HARD',
                              Colors.red,
                              controller.gameDifficulty == GameDifficulty.Hard,
                              () {
                                controller.setGameDifficulty(
                                  GameDifficulty.Hard,
                                );
                                controller.update();
                              },
                            ),
                            const SizedBox(height: 45),
                            PlayButton(
                              title: 'PLAY NOW',
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                ); // ✅ Close sheet only here
                                Get.to(() => const GamePage(isWithBot: true));
                              },
                              centerTitle: true,
                              shadowColor: Colors.white70,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/ottelo.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Spacer(),
            Spacer(),
            //! continue from here
            GetBuilder<BoardController>(
              builder: (boardController) {
                if (boardController.isWithBot != null) {
                  return PlayButton(
                    icon: Icons.keyboard_double_arrow_right_rounded,
                    title: 'Continue Playing',
                    onPressed: () {
                      Get.to(
                        () => GamePage(isWithBot: boardController.isWithBot!),
                      );
                    },
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox(height: 40),
            PlayButton(
              icon: Icons.smart_toy,
              title: 'PLAY VS COMPUTER',
              onPressed: () {
                _showDifficultyBottomSheet();
              },
            ),
            SizedBox(height: 40),
            PlayButton(
              icon: Icons.people,
              title: '2 PLAYERS',
              onPressed: () {
                Get.to(() => const GamePage(isWithBot: false));
              },
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bottomSettings(Icons.settings, () {
                  Get.to(() => const SettingsPage());
                }),
                SizedBox(width: 20),
                GetBuilder<GameSoundContoller>(
                  builder: (controller) {
                    return bottomSettings(
                      controller.isBackgroundSoundOn
                          ? Icons.volume_up
                          : Icons.volume_off,
                      () {
                        if (controller.isBackgroundSoundOn) {
                          _audioPlayer.pause();
                        } else {
                          _audioPlayer.resume();
                        }
                        controller.toggleBackgroundMusic();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _difficultyButton(
    String text,
    Color color,
    bool selected,
    VoidCallback onPressed,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.play_arrow,
          color: selected ? Colors.white : Colors.transparent,
          size: 40,
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  IconButton bottomSettings(IconData icon, VoidCallback onPressed) =>
      IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 26, color: Colors.white),
        ),
        splashColor: Colors.white,
        splashRadius: 24,
      );
}
