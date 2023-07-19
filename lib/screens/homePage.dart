import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/consts/colors.dart';
import 'package:musicplayer/consts/textStyle.dart';
import 'package:musicplayer/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = Get.put(PlayerController());

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
            return Center(
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
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (snapshot.data![index].fileExtension == "mp3" &&
                      snapshot.data![index].artist != "<unknown>") {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        tileColor: bgcolor,
                        title: Text(
                          snapshot.data![index].displayNameWOExt,
                          style: ourTextStyle(
                            family: "two",
                            size: 15,
                            letterSpacing: 1,
                          ),
                        ),
                        subtitle: Text(
                          "${snapshot.data![index].artist}",
                          style: ourTextStyle(
                            family: "one",
                            size: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
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
                            return const Icon(
                              Icons.pause_rounded,
                              color: whitecolor,
                              size: 26,
                            );
                          } else {
                            return const Icon(
                              Icons.play_arrow_rounded,
                              color: whitecolor,
                              size: 26,
                            );
                          }
                        }),
                        onTap: () {
                          controller.playindex.value == index &&
                                  controller.isPlaying.value == true
                              ? controller.pauseSong()
                              : controller.playsong(
                                  snapshot.data![index].uri.toString(),
                                  index,
                                );
                        },
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
