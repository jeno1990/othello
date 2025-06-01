import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/controllers/sound_state_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(GameStateController());
    Get.put(GameSoundContoller());

    final audioPlayer = AudioPlayer();
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setSource(AssetSource('audio/background_music.wav'));
    await audioPlayer.resume(); // ✅ Start playing when app launches

    Get.put<AudioPlayer>(audioPlayer); // Register for Get.find()
  }
}
