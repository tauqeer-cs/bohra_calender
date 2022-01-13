import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'dart:async';

class FileViewer extends StatefulWidget {
  final Files fileItem;


  FileViewer({Key? key, required this.fileItem}) : super(key: key);

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  String? kUrl1 = 'https://download.samplelib.com/mp3/sample-15s.mp3';
  String? localFilePath;

  var audio = AudioPlayer();

  bool isLoadingAudio = false;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      this._timer!.cancel();
      this._timer = null;

      audio.stop();
      audio.dispose();
    }
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isIOS) {}
  }

  Timer? _timer;
  int _start = 10;

  Duration? progressDuration;

  bool isPlaying = false;

  Future _loadFile() async {
    final bytes = await readBytes(Uri.parse(kUrl1!));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (file.existsSync()) {
      setState(() => localFilePath = file.path);
    }
  }

  Duration? totalDuration;

  int totalSecond = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.fileItem.title),
        actions: [
          if(widget.fileItem.audioUrl.isEmpty) ... [
            Container(),
          ] else
          if(isLoadingAudio) ... [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child:  CircularProgressIndicator(
                  ),
                ),
              ),
            ),
          ] else ... [
            IconButton(
              icon: Image.asset(
                isPlaying
                    ? 'assets/images/pause.png'
                    : 'assets/images/play.png',
              ),
              iconSize: 40,
              onPressed: () async {
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

                  //audio.play();

                  setState(() {
                    isPlaying = true;
                  });
                }
              },
            ),
          ],

        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if(totalDuration != null) ... [
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
            ],

            Expanded(
              child: const PDF().cachedFromUrl(
                widget.fileItem.pdfUr,
                placeholder: (double progress) =>
                    Center(child: Text('$progress %')),
                errorWidget: (dynamic error) =>
                    Center(child: Text(error.toString())),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
