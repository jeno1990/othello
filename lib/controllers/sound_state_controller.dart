import 'package:get/get.dart';

class GameSoundContoller extends GetxController {
  bool _isSoundOn = true;
  bool get isSoundOn => _isSoundOn;

 void toggleSound() {
    _isSoundOn = !_isSoundOn;
    update();
  }
}
