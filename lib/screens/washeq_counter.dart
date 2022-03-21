import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'day_detail.dart';

class WasheqCounterView extends StatefulWidget {
  final ClassItemInfo? calenderItem;

  final bool isTahajud;

  final bool isRamadanLast;
  final List<Files> files;
  final bool wadaNiNamaz;

  const WasheqCounterView(
      {Key? key,
      this.calenderItem,
      this.isTahajud = false,
      this.isRamadanLast = false,
      this.wadaNiNamaz = false,
      required this.files})
      : super(key: key);

  @override
  _WasheqCounterViewState createState() => _WasheqCounterViewState();
}

class _WasheqCounterViewState extends State<WasheqCounterView> {
  int salamDone = 0;
  int salamLimit = 14;

  List<List<Files>> waseqFile = [];

  List<String> notes = [];
  final scrollDirection = Axis.vertical;

  bool isShaban = false;

  @override
  void initState() {
    super.initState();

    if (widget.calenderItem != null) {
      if (widget.calenderItem!.monthNo == 8 &&
          widget.calenderItem!.dayNo == '14') {
        isShaban = true;
      }
    }

    if (1 == 1) {
      if (widget.calenderItem == null) {
        salamLimit = 6;
        notes.add('6 Salams /12 Rakats');
      } else {
        if (widget.isRamadanLast) {
         /// widget.calenderItem!.washerLimit = 10;
          salamLimit = (10 / 2).floor();
        }
        else if (widget.wadaNiNamaz) {
      //    widget.calenderItem!.washerLimit = 2;

          salamLimit = (2 / 2).floor();
        } else {
          salamLimit = (widget.calenderItem!.washerLimit / 2).floor();
        }

        notes.add(
            '$salamLimit Salams /${widget.calenderItem!.washerLimit} Rakats');

        if (widget.calenderItem!.monthNo == 8 &&
            widget.calenderItem!.dayNo == '14') {
          notes.add('In each Rakats user will pray -');
          notes.add('Alhamdo (14 times)');
          notes.add('Qul Howalho (14 times)');
          notes.add('Qul Auozo Falaq (14 times)');
          notes.add('Qul Auzo bin Nas(14 times)');
          notes.add('Aayatul Kursi (1 times)');
        } else if (widget.calenderItem!.monthNo == 9 &&
            widget.calenderItem!.dayNo == '22') {
          notes.add('In each Rakats user will pray -');

          notes.add('Alhamdo (Once)');
          notes.add('Inna Anzalna  (Once)');
        } else if (widget.calenderItem!.monthNo == 9 &&
            widget.calenderItem!.dayNo == '29') {
          notes.add('In each Rakats user will pray -');
          notes.add('Alhamdo (Once)');
          notes.add('Inna Anzalna  (Once)');
        } else if (widget.calenderItem!.monthNo == 9 &&
            widget.calenderItem!.dayNo == '30' &&
            widget.isRamadanLast) {
          notes.add('In each Rakats user will pray -');
          notes.add('Alhamdo (Once)');
          notes.add('Inna Anzalna  (Once)');
        }
      }
    }

    if (widget.files.isNotEmpty) {
      for (int i = 1; i <= salamLimit * 2; i++) {
        var what = widget.files
            .where((e) =>
                e.title.substring(0, e.title.indexOf('-') + 1) ==
                (i.toString() + '-'))
            .toList();

        if (isShaban) {
          if (what.isNotEmpty) {
            waseqFile.add(what);
          }
        } else {
          waseqFile.add(what);
        }

        print('');
      }

      print('');
    }
  }

  bool checkBool(Files e, int i) {
    var c = e.title.substring(0, e.title.indexOf('-'));

    return int.parse(c) == i;
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerText(),
          style: TextStyle(
              color: Constants.inkBlack,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: Constants.backgroundPAttern,
          child: Container(
            color: Constants.backgroundPatternTopColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 4,
                ),
                if (1 == 2) ...[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      buildIslamicDayFullString(),
                      style: TextStyle(
                          color: Constants.inkBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
                if (1 == 2) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      notes[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
                const SizedBox(
                  height: 16,
                ),
                if (widget.isTahajud) ...[
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Tahajood Namaz Counter',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else if (isShaban) ...[
                  WasheqListItem(
                    files: waseqFile[0],
                    isActive: true,
                    index: 0,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 4),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isActive(index)
                                      ? Colors.black
                                      : Colors.grey,
                                  width: 1.4),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      (index + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: buildTextStyleSelected(
                                        isActive(index),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildTextWitnTimes(
                                            'Alhamdo', index, 14),
                                        buildTextWitnTimes(
                                            'Qul Howa allho ahad', index, 14),
                                        buildTextWitnTimes(
                                            'Qul Auzo birabbil falaq',
                                            index,
                                            14),
                                        buildTextWitnTimes(
                                            'Qul Auzo bay rab bin nas',
                                            index,
                                            14),
                                        buildTextWitnTimes(
                                            'Ayat ul Kursi', index, 1),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 14,
                    ),
                  ),
                ] else if (widget.isRamadanLast) ...[
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 4),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isActive(index)
                                      ? Colors.black
                                      : Colors.grey,
                                  width: 1.4),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      (index + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: buildTextStyleSelected(
                                        isActive(index),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildTextWitnTimes('Alhamdo', index, 1),
                                        buildTextWitnTimes(
                                            'Qul Howa allho ahad', index, 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 10,
                    ),
                  ),
                ] else if (widget.wadaNiNamaz) ...[
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 4),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isActive(index)
                                      ? Colors.black
                                      : Colors.grey,
                                  width: 1.4),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      (index + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: buildTextStyleSelected(
                                        isActive(index),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildTextWitnTimes('Alhamdo', index, 0),
                                        buildTextWitnTimes(
                                            'Qul huwal laahu ahad', index, 10),
                                        buildTextWitnTimes(
                                            'Qul Auzo birabbil falaq',
                                            index,
                                            7),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 2,
                    ),
                  ),
                ] else if (widget.calenderItem != null &&
                    widget.calenderItem!.monthNo == 9 &&
                    widget.calenderItem!.dayNo == '22') ...[
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 4),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isActive(index)
                                      ? Colors.black
                                      : Colors.grey,
                                  width: 1.4),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      (index + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: buildTextStyleSelected(
                                        isActive(index),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildTextWitnTimes('', index, 0),
                                      buildTextWitnTimes(
                                          'Alhamdo + Inna Anzalnho', index, 0),
                                      buildTextWitnTimes('', index, 0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 20,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: waseqFile.length,
                          itemBuilder: (BuildContext context, int index) {
                            return WasheqListItem(
                              files: waseqFile[index],
                              isActive: isActive(index),
                              index: index,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(
                  height: 24,
                ),
                Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            if (0 == salamDone) {
                              return;
                            }

                            setState(() {
                              salamDone = salamDone - 1;
                            });
                            scollToPos();
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.minus,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: salamDone.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Number',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' SALAM',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PlayfairDisplay',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (salamLimit == salamDone) {
                              if (widget.wadaNiNamaz) {
                                Alert(
                                  context: context,
                                  title: 'Namaz Completed',
                                ).show();
                              } else {
                                Alert(
                                  context: context,
                                  title: 'Washeq Completed',
                                ).show();
                              }

                              return;
                            }
                            setState(() {
                              salamDone = salamDone + 1;
                            });

                            scollToPos();

                            if (widget.wadaNiNamaz) {
                              Alert(
                                context: context,
                                title: 'Namaz Completed',
                              ).show();
                            } else if (salamLimit == salamDone) {
                              Alert(
                                context: context,
                                title: 'Washeq Completed',
                              ).show();

                              return;
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextWitnTimes(String text, int index, int numberOftimes) {
    return RichText(
      text: TextSpan(
        text: '',
        children: <TextSpan>[
          TextSpan(
            text: text + (numberOftimes == 0 ? '' : ' ('),
            style: buildTextStyleSelected(
              isActive(index),
            ),
          ),
          if (numberOftimes > 0) ...[
            TextSpan(
              text: numberOftimes.toString() +
                  ' ' +
                  (numberOftimes == 1 ? 'time' : 'times'),
              style: numberSmallerText(
                isActive(index),
              ),
            ),
            TextSpan(
              text: ')',
              style: buildTextStyleSelected(isActive(index)),
            ),
          ],
        ],
      ),
    );
  }

  TextStyle buildTextStyleSelected(bool isActive, {bool smaller = false}) {
    return TextStyle(
      color: !isActive ? Colors.grey : Constants.inkBlack,
      fontWeight: FontWeight.w600,
      fontFamily: 'PlayfairDisplay',
      fontSize: smaller ? 17 : 18,
    );
  }

  TextStyle numberSmallerText(bool isActive) {
    return TextStyle(
      color: !isActive ? Colors.grey : Constants.inkBlack,
      fontSize: 15,
    );
  }

  void scollToPos() {
    int scrollInset = salamDone;
    if (salamDone > 5) {
      scrollInset = salamDone + 2;
    } else if (salamDone > 8) {
      scrollInset = salamLimit;
    } else {
      scrollInset = salamDone;
    }

    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent *
            ((scrollInset) / salamLimit),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut);
  }

  bool isActive(int index) {
    if (this.isShaban) {
      // return salamDone == index;

    }
    bool one = (salamDone * 2 == index);
    bool two = ((salamDone * 2 + 1) == index);

    return one || two;
  }

  String headerText() {
    if(widget.isTahajud){
      return 'Tajajood Counter';
    }
    if (widget.wadaNiNamaz) {
      return 'Wada ni Namaz';
    } else if (widget.calenderItem != null) {
      return 'Washeq Counter';
    }

    return 'Tasbee Counter';
  }

  String buildIslamicDayFullString() {
    if (widget.calenderItem != null) {
      return widget.calenderItem!.islamicDayFullString;
    }

    return "Bihori Namaz";
  }
}

class WasheqListItem extends StatelessWidget {
  final bool isActive;
  final List<Files> files;
  final int index;

  const WasheqListItem(
      {Key? key,
      required this.isActive,
      required this.files,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? Colors.white : Colors.transparent),
      ),
      child: Column(
        children: [
          for (Files currentFile in files) ...[
            if (isActive) ...[
              Transform.scale(
                scale: 1.00,
                child: FileItem(
                  isDisabled: false,
                  verticalGap: 0,
                  noGap: true,
                  name: currentFile.title,
                  pop: isActive,
                  onTap: () {},
                  hasPDF: currentFile.pdfUr.isNotEmpty,
                  hasAudio: currentFile.audioUrl.isNotEmpty,
                  fileItem: currentFile,
                ),
              ),
            ] else ...[
              Transform.scale(
                scale: 0.90,
                child: FileItem(
                  isDisabled: true,
                  verticalGap: 0,
                  noGap: true,
                  name: currentFile.title,
                  pop: isActive,
                  onTap: () {},
                  hasPDF: currentFile.pdfUr.isNotEmpty,
                  hasAudio: currentFile.audioUrl.isNotEmpty,
                  fileItem: currentFile,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
