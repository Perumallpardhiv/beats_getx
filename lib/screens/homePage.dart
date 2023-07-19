import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/consts/colors.dart';
import 'package:musicplayer/consts/textStyle.dart';
import 'package:musicplayer/controllers/player_controller.dart';
import 'package:musicplayer/screens/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  var controller = Get.put(PlayerController());
  List<SongModel> originalSnapshot = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkcolor,
      appBar: AppBar(
        backgroundColor: bgDarkcolor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: whitecolor,
            ),
          )
        ],
        leading: const Icon(
          Icons.sort_rounded,
          color: whitecolor,
        ),
        title: Text(
          "Beats",
          style: ourTextStyle(
            family: "five",
            size: 22,
            letterSpacing: 1.5,
            color: whitecolor,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          ignoreCase: true,
          uriType: UriType.EXTERNAL,
          sortType: null,
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No songs found",
                style: ourTextStyle(),
              ),
            );
          } else {
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (snapshot.data![i].fileExtension == "mp3" &&
                  snapshot.data![i].artist != "<unknown>") {
                originalSnapshot.add(snapshot.data![i]);
              }
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: originalSnapshot.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: bgcolor,
                      title: Text(
                        originalSnapshot[index].displayNameWOExt,
                        style: ourTextStyle(
                          family: "two",
                          size: 15,
                          letterSpacing: 1,
                        ),
                      ),
                      subtitle: Text(
                        "${originalSnapshot[index].artist}",
                        style: ourTextStyle(
                          family: "one",
                          size: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      leading: QueryArtworkWidget(
                        id: originalSnapshot[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note_rounded,
                          color: whitecolor,
                          size: 32,
                        ),
                      ),
                      trailing: Obx(() {
                        if (controller.playindex.value == index &&
                            controller.isPlaying.value == true) {
                          return IconButton(
                            onPressed: () {
                              controller.audioPlayer.pause();
                              controller.isPlaying(false);
                            },
                            icon: const Icon(
                              Icons.pause_rounded,
                              color: whitecolor,
                              size: 26,
                            ),
                          );
                        } else {
                          return IconButton(
                            onPressed: () {
                              if (controller.playindex.value == index) {
                                controller.audioPlayer.play();
                                controller.isPlaying(true);
                                controller.updatePostiion();
                              } else {
                                controller.playsong(
                                  originalSnapshot[index].uri.toString(),
                                  index,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              color: whitecolor,
                              size: 26,
                            ),
                          );
                        }
                      }),
                      onTap: () {
                        if (controller.playindex.value == index &&
                            controller.isPlaying.value == true) {
                          Get.to(
                            () => Player(
                              songModel: originalSnapshot,
                              index: index,
                            ),
                            transition: Transition.native,
                            duration: const Duration(milliseconds: 500),
                          );
                        } else {
                          if (!controller.isPlaying.value) {
                            if (controller.playindex.value == index) {
                              controller.audioPlayer.play();
                              controller.isPlaying(true);
                              controller.updatePostiion();
                            } else {
                              controller.playsong(
                                originalSnapshot[index].uri.toString(),
                                index,
                              );
                            }
                          }
                          Get.to(
                            () => Player(
                              songModel: originalSnapshot,
                              index: index,
                            ),
                            transition: Transition.native,
                            duration: const Duration(milliseconds: 500),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
