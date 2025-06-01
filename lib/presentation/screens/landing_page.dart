import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/presentation/screens/home_page.dart';
import 'package:othello/presentation/widgets/play_button.dart';
import 'package:othello/presentation/screens/settings_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.setSource(AssetSource('audio/background_music.wav'));
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
      isScrollControlled: true,
      builder: (context) => GetBuilder<GameStateController>(
        builder: (controller) => Container(
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
                      controller.gameDifficulty == GameDifficulty.easy,
                      () {
                        controller.setGameDifficulty(GameDifficulty.easy);
                        controller.update();
                      },
                    ),
                    const SizedBox(height: 15),
                    _difficultyButton(
                      'MEDIUM',
                      Colors.orange,
                      controller.gameDifficulty == GameDifficulty.medium,
                      () {
                        controller.setGameDifficulty(GameDifficulty.medium);
                        controller.update();
                      },
                    ),
                    const SizedBox(height: 15),
                    _difficultyButton(
                      'HARD',
                      Colors.red,
                      controller.gameDifficulty == GameDifficulty.hard,
                      () {
                        controller.setGameDifficulty(GameDifficulty.hard);
                        controller.update();
                      },
                    ),
                    const SizedBox(height: 45),
                    PlayButton(
                      title: 'PLAY NOW',
                      onPressed: () {
                        Navigator.pop(context); // ✅ Close sheet only here
                        Get.to(() => const GamePage());
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
      body: Stack(
        children: [
          // Background image
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/ottelo.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Top-right settings button
          Positioned(
            top: 30,
            right: 20,
            child: bottomSettings(Icons.settings, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            }),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                PlayButton(
                  icon: Icons.smart_toy,
                  title: 'PLAY VS COMPUTER',
                  onPressed: _showDifficultyBottomSheet,
                ),
                const SizedBox(height: 40),
                PlayButton(
                  icon: Icons.people,
                  title: '2 PLAYERS',
                  onPressed: () {
                    Get.to(() => const GamePage());
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
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
