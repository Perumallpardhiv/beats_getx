import 'package:flutter/material.dart';
import 'package:musicplayer/consts/colors.dart';
import 'package:musicplayer/consts/textStyle.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 50,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                tileColor: bgcolor,
                title: Text(
                  "Music Name",
                  style: ourTextStyle(
                    family: "two",
                    size: 15,
                    letterSpacing: 1,
                  ),
                ),
                subtitle: Text(
                  "Artst Name",
                  style: ourTextStyle(
                    family: "one",
                    size: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                leading: const Icon(
                  Icons.music_note_rounded,
                  color: whitecolor,
                  size: 32,
                ),
                trailing: const Icon(
                  Icons.play_arrow_rounded,
                  color: whitecolor,
                  size: 26,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
