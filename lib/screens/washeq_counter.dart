import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class WasheqCounterView extends StatefulWidget {
  final ClassItemInfo? calenderItem;

  const WasheqCounterView({Key? key, this.calenderItem}) : super(key: key);

  @override
  _WasheqCounterViewState createState() => _WasheqCounterViewState();
}

class _WasheqCounterViewState extends State<WasheqCounterView> {
  int salamDone = 0;
  int salamLimit = 14;

  List<String> notes = [];

  @override
  void initState() {
    super.initState();

    if (1 == 1) {



      if (widget.calenderItem == null) {
        salamLimit = 6;


        notes.add(
            '6 Salams /12 Rakats');


      } else {
        salamLimit = (widget.calenderItem!.washerLimit / 2).floor();



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
            widget.calenderItem!.dayNo == '30') {
          notes.add('In each Rakats user will pray -');
          notes.add('Alhamdo (Once)');
          notes.add('Inna Anzalna  (Once)');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerText(),
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
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
                  height: 24,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    buildIslamicDayFullString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.blue,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          print('on Tap');
                          if (0 == salamDone) {

                            return;
                          }
                          setState(() {
                            salamDone = salamDone - 1;
                          });
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
                          child: Text(
                            '$salamDone SALAM',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      TextButton(
                        onPressed: () {
                          if (salamLimit == salamDone) {
                            Alert(context: context, title: "Masha-Allah", desc: "You have already completed this prayer").show();


                            return;
                          }
                          setState(() {
                            salamDone = salamDone + 1;
                          });

                          if (salamLimit == salamDone) {
                            Alert(context: context, title: "Masha-Allah", desc: "Prayer completed"  ).show();


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
                  height: 100,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 8,
                ),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemCount: notes.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            notes[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String headerText() {
    if (widget.calenderItem != null) {
      return 'Washeq Counter';
    }

    return 'Tasbeeh Counter';
  }

  String buildIslamicDayFullString() {
    if (widget.calenderItem != null) {
      return widget.calenderItem!.islamicDayFullString;
    }

    return "Bihori Namaz";
  }
}
