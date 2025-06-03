import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class GameSoundContoller extends GetxController {
  bool _isBackgroundMusicOn = true;
  bool _isSoundEffectsOn = true;
  bool get isBackgroundSoundOn => _isBackgroundMusicOn;
  bool get isSoundEffectsOn => _isSoundEffectsOn;

  void toggleBackgroundMusic() {
    _isBackgroundMusicOn = !_isBackgroundMusicOn;
    update();
  }

  void toggleKeySound() {
    _isSoundEffectsOn = !_isSoundEffectsOn;
    update();
  }
}
