import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class GameSoundContoller extends GetxController {
  final isSoundOn = true.obs;
  late final AudioPlayer _player;

  @override
  void onInit() {
    super.onInit();
    _player = Get.find<AudioPlayer>();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setSource(AssetSource('audio/background_music.wav'));
    await _player.resume();
  }

  void toggleSound() {
    isSoundOn.value = !isSoundOn.value;
    if (isSoundOn.value) {
      _player.resume();
    } else {
      _player.pause();
    }
  }
}
