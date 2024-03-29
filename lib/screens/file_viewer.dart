import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:async';

import 'day_detail.dart';
import 'dart:io' show Platform;

class FileViewer extends StatefulWidget {
  final bool nabiNaNaam;

  final Files fileItem;

  final List<Files>? fileItems;

  final bool isAlhamdo;

  final MonthlyData? data;

  const FileViewer(
      {Key? key,
      required this.fileItem,
      this.data,
      this.nabiNaNaam = false,
      this.fileItems,
      this.isAlhamdo = false})
      : super(key: key);

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  // String? kUrl1 = 'https://download.samplelib.com/mp3/sample-15s.mp3';
  String? localFilePath;

  Future<ByteData> loadAsset() async {
    String name = 'assets/audio/Nabi na Naam.mp3';
    return await rootBundle.load('sounds/music.mp3');
  }

  var audio = AudioPlayer();

  bool isLoadingAudio = false;

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

        if (audio.position.inSeconds == audio.duration!.inSeconds) {
          isPlaying = false;
        }
      });
    });
  }

  Timer? _timer;

  Duration? progressDuration;

  bool isPlaying = false;

  Future _loadFile() async {
    final bytes = await readBytes(Uri.parse(widget.fileItem.audioUrl));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (file.existsSync()) {
      setState(() => localFilePath = file.path);
    }
  }

  Duration? totalDuration;

  double speed = 1.0;

  int totalSecond = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(buildTitle()),
        actions: [
          if (widget.fileItem.audioUrl.isEmpty &&
              widget.nabiNaNaam == false) ...[
            Container(),
          ] else if (isLoadingAudio) ...[
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ] else ...[
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

                  if (widget.nabiNaNaam) {
                    //loadAsset
                    totalDuration ??=
                        await audio.setAsset('assets/audio/Nabi na Naam.mp3');
                  } else if (buildTitle() == 'Dus Surat') {
                    totalDuration ??=
                        await audio.setAsset('assets/audio/dus1.mp3');
                  } else {
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
              },
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (totalDuration != null || (Platform.isAndroid && 1 == 2)) ...[
              if (widget.fileItem.audioUrl.isEmpty && !widget.nabiNaNaam)
                ...[]
              else ...[
                Container(
                  color: Colors.grey.shade700,
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              speed = speed - 0.25;
                              audio.setSpeed(speed);
                            },
                            child: Transform.translate(
                              offset: const Offset(0, -8),
                              child: const Icon(
                                Icons.fast_rewind_outlined,
                                color: Color.fromRGBO(255, 184, 28, 1),
                              ),
                            ),
                          ),
                           SizedBox(
                            width: speed == 1.0 ? 12 : 16,
                          ),
                          Expanded(
                            child: ProgressBar(
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
                              thumbColor: const Color.fromRGBO(255, 184, 28, 1),
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
                          ),
                          SizedBox(
                            width: speed == 1.0 ? 12 : 16,
                            child: (speed != 1.0)
                                ? Transform.translate(
                              offset: const Offset(16, 8),
                              child: Text(
                                      '$speed',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                    ),
                                )
                                : Container(),
                          ),
                          GestureDetector(
                            onTap: () {
                              speed = speed + 0.25;
                              audio.setSpeed(speed);
                            },
                            child: Transform.translate(
                              offset: const Offset(0, -8),
                              child: const Icon(
                                Icons.fast_forward_outlined,
                                color: Color.fromRGBO(255, 184, 28, 1),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
            if (widget.data != null) ...[
              Expanded(
                flex: 3,
                child: buildPdfFromUrl(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 1; i < widget.data!.files.length; i++) ...[
                        FileItem(
                          name: widget.data!.files[i].title,
                          onTap: () {},
                          files: widget.isAlhamdo ? widget.data!.files : null,
                          hasPDF: widget.data!.files[i].pdfUr.isNotEmpty,
                          hasAudio: widget.data!.files[i].audioUrl.isNotEmpty,
                          fileItem: widget.data!.files[i],
                          verticalGap: 3,
                          otherColor: i % 2 == 0,
                          currentIndex: i,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else if (widget.fileItem.pdfUr.contains('.pdf') ||
                widget.nabiNaNaam) ...[
              Expanded(
                child: buildPdfFromUrl(),
              ),
            ] else ...[
              Expanded(
                child: Image.network(widget.fileItem.pdfUr),
              ),
            ],
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  String buildTitle() {
    if (this.widget.nabiNaNaam) {
      return 'Nabi na Naam';
    }
    return widget.fileItem.title;
  }

  Widget buildPdfFromUrl() {
    if (widget.nabiNaNaam) {
      if(Platform.isAndroid) {
        return SfPdfViewer.asset('assets/audio/nabi na naam.pdf');
      } else {
        return const PDF().fromAsset('assets/audio/nabi na naam.pdf');
      }
    }
    if(Platform.isAndroid) {
      return SfPdfViewer.network(widget.fileItem.pdfUr);
    }

    return const PDF().cachedFromUrl(
      widget.fileItem.pdfUr,
      placeholder: (double progress) => Center(child: Text('$progress %')),
      errorWidget: (dynamic error) => Center(child: Text(error.toString())),
    );
  }
}
