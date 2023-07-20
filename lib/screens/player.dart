import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/consts/colors.dart';
import 'package:musicplayer/consts/textStyle.dart';
import 'package:musicplayer/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class Player extends StatelessWidget {
  final List<SongModel> songModel;
  final int index;
  Player({super.key, required this.songModel, required this.index});

  var controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      color: bgDarkcolor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        QueryArtworkWidget(
                          id: songModel[controller.playindex.value].id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: double.infinity,
                          artworkWidth: double.infinity,
                          nullArtworkWidget: const Icon(
                            Icons.music_note_rounded,
                            color: whitecolor,
                            size: 20,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: bgDarkcolor,
                            radius: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: whitecolor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          songModel[controller.playindex.value]
                              .displayNameWOExt,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: ourTextStyle(
                            family: "two",
                            size: 18,
                            color: bgDarkcolor,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          songModel[controller.playindex.value]
                              .artist
                              .toString(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: ourTextStyle(
                            family: "one",
                            size: 15,
                            color: bgDarkcolor,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          return Row(
                            children: [
                              Text(
                                controller.position.value,
                                style: ourTextStyle(
                                  color: bgDarkcolor,
                                  size: 14,
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  thumbColor: slidercolor,
                                  activeColor: slidercolor,
                                  inactiveColor: bgcolor,
                                  value: controller.value.value,
                                  max: controller.max.value,
                                  min:
                                      const Duration(seconds: 0).inSeconds.toDouble(),
                                  onChanged: (newValue) {
                                    controller.changeDurationToSeconds(
                                        newValue.toInt());
                                  },
                                ),
                              ),
                              Text(
                                controller.duration.value,
                                style: ourTextStyle(
                                  color: bgDarkcolor,
                                  size: 14,
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.playsong(
                                  songModel[controller.playindex.value - 1]
                                      .uri
                                      .toString(),
                                  controller.playindex.value - 1,
                                );
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 40,
                                color: bgDarkcolor,
                              ),
                            ),
                            Obx(() {
                              return CircleAvatar(
                                radius: 35,
                                backgroundColor: bgDarkcolor,
                                child: Transform.scale(
                                  scale: 1.5,
                                  child: IconButton(
                                    onPressed: () {
                                      if (controller.isPlaying.value == true) {
                                        controller.audioPlayer.pause();
                                        controller.isPlaying(false);
                                      } else {
                                        controller.audioPlayer.play();
                                        controller.isPlaying(true);
                                        controller.playindex.value = controller.playindex.value;
                                        controller.updatePostiion();
                                      }
                                    },
                                    icon: !controller.isPlaying.value
                                        ? const Icon(
                                            Icons.play_arrow_rounded,
                                            size: 40,
                                            color: whitecolor,
                                          )
                                        : const Icon(
                                            Icons.pause_rounded,
                                            size: 40,
                                            color: whitecolor,
                                          ),
                                  ),
                                ),
                              );
                            }),
                            IconButton(
                              onPressed: () {
                                controller.playsong(
                                  songModel[controller.playindex.value + 1]
                                      .uri
                                      .toString(),
                                  controller.playindex.value + 1,
                                );
                              },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                                color: bgDarkcolor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }
}
