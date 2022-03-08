import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayerView extends StatefulWidget {
  final Files fileItem;
  final List<Files>? fileItems;

  final int itemIndex;


   const MiniPlayerView({Key? key, required this.fileItem,this.fileItems, this.itemIndex = 1}) : super(key: key);

  @override
  State<MiniPlayerView> createState() => MiniPlayerViewState();
}

class MiniPlayerViewState extends State<MiniPlayerView> {
  Duration? progressDuration;


  int currentIndex = 1;

  int totalSecond = 0;
  var audio = AudioPlayer();

  Duration? totalDuration;
  bool isPlaying = false;

  String? localFilePath;

  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;

      audio.stop();
      audio.dispose();
    }
  }

  void startTimer(int totalSeconds) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {


      setState(() {
        progressDuration = audio.position;

        if (audio.position.inSeconds == audio.duration!.inSeconds && isPlaying ) {


          isPlaying = false;


          if(widget.fileItems != null){

            if(widget.fileItems!.length == (currentIndex+1)) {

              return;

            }
            currentIndex = currentIndex +1;


            progressDuration = null;
            currentIndex = currentIndex +1;

            setPlayer();
          }

        }
      });
    });
  }

  bool isLoadingAudio = false;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.itemIndex;


  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      backgroundColor: Colors.black12,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 36,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                buildTitle(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Image.asset(
                                'assets/images/cancel_icon.png',
                              ),
                              iconSize: 28,
                              onPressed: () async {
                                audio.stop();
                                audio.dispose();

                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/saifa_picture.png',
                              height: 80,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reciter',
                                    style: TextStyle(
                                      color: Colors.red.shade800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    'Mohammed Shk Zohair Mukaddam (Hafiz-ul-Quran)',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.grey.shade700,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              ProgressBar(
                                timeLabelTextStyle:
                                    const TextStyle(color: Colors.white),
                                progress: progressDuration != null
                                    ? progressDuration!
                                    : const Duration(milliseconds: 0),
                                // buffered: Duration(milliseconds: 2000),
                                total: totalDuration == null
                                    ? const Duration(milliseconds: 20)
                                    : totalDuration!,
                                progressBarColor: Colors.red,
                                baseBarColor: Colors.brown,
                                bufferedBarColor: Colors.yellow,
                                thumbColor: Colors.green,
                                barHeight: 3.0,
                                thumbRadius: 5.0,
                                onSeek: (duration) {
                                  audio.seek(duration);

                                  if (audio.playing) {
                                    setState(() {
                                      isPlaying = true;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      GestureDetector(
                        child: isLoadingAudio
                            ? const CircularProgressIndicator()
                            : Image.asset(
                                isPlaying
                                    ? 'assets/images/pause.png'
                                    : 'assets/images/play.png',
                                height: 40,
                              ),
                        onTap: ()  {

                          setPlayer();

                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void setPlayer() async {
    if (isLoadingAudio) {
      return;
    }
    if (isPlaying) {

      setState(() {
        isPlaying = false;
      });

      audio.pause();

    } else {
      setState(() {
        isLoadingAudio = true;
      });

      if(widget.fileItems != null) {



        audio = AudioPlayer();


        totalDuration =
        await audio.setUrl(widget.fileItems![currentIndex].audioUrl);

      }
      else {
        totalDuration ??=
        await audio.setUrl(widget.fileItem.audioUrl);
      }





      setState(() {
        isLoadingAudio = false;
      });

      if (totalDuration != null) {
        totalSecond = totalDuration!.inSeconds;
      }

      audio.play();

      startTimer(1);
      setState(() {
        isPlaying = true;
      });

    }

  }
  String buildTitle() {

    if(widget.fileItems != null){
      return widget.fileItems![currentIndex].title;
    }
    return widget.fileItem.title;

  }
}
