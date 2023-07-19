import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playindex = 0.obs;
  var isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  playsong(String uri, int index) {
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );
      playindex.value = index;
      isPlaying(true);
      audioPlayer.play();
    } catch (e) {
      print(e);
    }
  }

  pauseSong() {
    try {
      isPlaying(false);
      playindex.value = 0;
      audioPlayer.pause();
    } catch (e) {
      print(e);
    }
  }

  checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isDenied) {
      checkPermission();
    } else if (perm.isGranted) {}
  }
}
