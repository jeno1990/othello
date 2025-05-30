import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/presentation/screens/home_page.dart';
import 'package:othello/presentation/widgets/play_button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isComputerMode = false;

  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.setSource(AssetSource('audio/background_music.wav'));
      // await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _showDifficultyBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => GetBuilder<GameStateController>(
            builder:
                (controller) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
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
                        margin: EdgeInsets.all(10),
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'SELECT DIFFICULTY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30),
                            _difficultyButton(
                              'EASY',
                              Colors.green,
                              controller.gameDifficulty == GameDifficulty.easy,
                              () {
                                controller.setGameDifficulty(
                                  GameDifficulty.easy,
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            _difficultyButton(
                              'MEDIUM',
                              Colors.orange,
                              controller.gameDifficulty ==
                                  GameDifficulty.medium,
                              () {
                                controller.setGameDifficulty(
                                  GameDifficulty.medium,
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            _difficultyButton(
                              'HARD',
                              Colors.red,
                              controller.gameDifficulty == GameDifficulty.hard,
                              () {
                                controller.setGameDifficulty(
                                  GameDifficulty.hard,
                                );
                              },
                            ),
                            SizedBox(height: 45),
                            PlayButton(
                              title: 'PLAY NOW',
                              onPressed: () {
                                Get.to(() => GamePage());
                              },
                              centerTitle: true,
                              shadowColor: Colors.white70,
                            ),
                            SizedBox(height: 20),
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
                Get.to(() => const GamePage());
              },
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bottomSettings(Icons.settings),
                SizedBox(width: 20),
                bottomSettings(Icons.volume_up),
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
            minimumSize: Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  IconButton bottomSettings(IconData icon) => IconButton(
    onPressed: () {},
    icon: Icon(icon, size: 40, color: Colors.white),
    splashColor: Colors.white,
    splashRadius: 5,
  );
}
