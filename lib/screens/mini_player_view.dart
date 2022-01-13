import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayerView extends StatefulWidget {
  final Files fileItem;

  const MiniPlayerView({Key? key, required this.fileItem}) : super(key: key);

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  Duration? progressDuration;

  int totalSecond = 0;
  var audio = AudioPlayer();

  Duration? totalDuration;
  bool isPlaying = false;

  String? kUrl1 = 'https://download.samplelib.com/mp3/sample-15s.mp3';
  String? localFilePath;

  Timer? _timer;
  int _start = 10;

  void startTimer(int totalSeconds) {

    if(_timer != null) {
      _timer!.cancel();
    }

    _timer =  Timer.periodic(Duration(seconds: 1 ,), (timer) {
      print("Yeah, this line is printed after 3 seconds");
      setState(() {

        progressDuration = audio.position;

        if(audio.position.inSeconds == audio.duration!.inSeconds) {

          isPlaying = false;

        }
      });
    });



  }


  bool isLoadingAudio = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(0, 12, 0, 0),
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
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          const SizedBox(
                            width: 36,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.fileItem.title,
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
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              ProgressBar(
                                timeLabelTextStyle: const TextStyle(color: Colors.white),
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

                                  if(audio.playing) {
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
                      const SizedBox(height: 2,),
                      GestureDetector(
                        child: Image.asset(
                          isPlaying
                              ? 'assets/images/pause.png'
                              : 'assets/images/play.png',
                          height: 40,
                        ),
                        onTap: () async {

                          if(isLoadingAudio){

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

                            totalDuration ??= await audio.setUrl(kUrl1!);

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
}
