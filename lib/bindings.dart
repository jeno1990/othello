import 'package:get/get.dart';
import 'package:othello/controllers/game_state_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameStateController());
  }
}
