import 'package:get/get.dart';
import 'package:othello/controllers/game_state_controller.dart';
import 'package:othello/controllers/sound_state_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameStateController());
    Get.put(GameSoundContoller());
  }
}
