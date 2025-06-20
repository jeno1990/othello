import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:othello/controllers/board_controller.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/controllers/sound_state_controller.dart';
import 'package:othello/controllers/user_profile_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameStateController());
    Get.put(GameSoundContoller());
    // Get.put(UserProfileController());
    Get.put(
      UserProfileController(),
      permanent: true,
    ); // Keep all existing logic
    final audioPlayer = AudioPlayer();

    Get.put<AudioPlayer>(audioPlayer);
    Get.put(BoardController());
  }
}
