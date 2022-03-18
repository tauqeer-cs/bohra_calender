import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tasbeeh extends StatefulWidget {
  const Tasbeeh({Key? key}) : super(key: key);

  @override
  State<Tasbeeh> createState() => _TasbeehState();
}

class _TasbeehState extends State<Tasbeeh> {
  int _value = 0;

  bool isGoal33 = true;
  bool isGoald100 = false;
  bool isGoal1000 = false;
  bool isGoal4166 = false;

  double get fontSizeToShow {
    if(_value > 99 && _value < 1000) {
      return 54;
    }
    else if(_value > 999) {
      return 40;
    }
    return 70;

  }
  int selectedTasbeeh = 0;

  List<String> tasbeehTexts = [
    'بِسْمِ ٱللَّٰهِ',
    'اللّهُمّ صَلّ عَلَى مُحَمّدٍ وَعلىٰ آلِ مُحَمّدٍ كَمَا صَلّيْتَ وَبَارَكْتَ عَلَى إبْرَاهِيمَ وَعلىٰ آلِ إبْرَاهِيمَ إنّكَ حَمِيدٌ مَجِيدٌ',
    'يا الي',
    'سُبْحَانَ ٱللَّٰه',
    'ٱلْحَمْدُ لِلَّٰه',
    'ٱللَّٰهُ أَكْبَرُ',
    'أَسْتَغْفِرُ ٱللَّٰه',
    'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِالله',
    'ربِّ اغفِرْ لي وتُبْ عليَّ إنَّك أنت التَّوَّابُ الرَّحيمُ',
    'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَعَافِنِي وَارْزُقْنِي',
    'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ'
  ];
  List<String> tasbeehSubTexts = [
    'Bismillah',
    'Salawat',
    'Ya Ali',
    'Subhanallah',
    'Alhamdulillah',
    'Allahu Akbar',
    'Astaghfirullah',
    'Laillaha illa aanta subhanaka innie kunto minzzalemiun',
    'Lahawla walakuwata illah billah.',
    'Rabbe aagfirli watub alayha ennaka aanta twwabur rahim',
    'Allahumag firli warhamni wahadeni waagfiuni wazukni',
        'Rabbana antenatal fi Duniya hasanatun wafil aakherate hasanatun wakena azzabun nar',
  ];
  List<String> rowTitles = [
    'بِسْمِ ٱللَّٰه',
    'صلوات',
    'يا الي',
    'سُبْحَانَ ٱللَّٰه',
    'ٱلْحَمْدُ لِلَّٰه',
    'ٱللَّٰهُ أَكْبَرُ',
    'أَسْتَغْفِرُ ٱللَّٰه',
    'لَا إِلَهَ إِلَّا أَنْتَ',
    'لَا حَوْلَ',
    'ربِّ اغفِرُْ',
    'اللَّهُمَّ اغْفِرْ',
    'رَبَّنَا'
  ];

  List<double> sizedEng = [
    32,
    20,
    32,
    32,
    32,
    32,
    32,
    18,
    22,
    20,
    20,
    20,
    20,
  ];

  List<double> sizedArabic = [
    48,
    20,
    48,
    48,
    48,
    48,
    48,
    24,
    30,
    24,
    20,
    20,
    20,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbee'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red.shade600),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Text(
                  'RESET',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () {
                setState(() {
                  _value = 0;
                });
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: Constants.backgroundPAttern,
          child: Container(
            color: Constants.backgroundPatternTopColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 9,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              tasbeehTexts[selectedTasbeeh],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Arabic',
                                  fontSize: sizedArabic[selectedTasbeeh]),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              tasbeehSubTexts[selectedTasbeeh],
                              textAlign: TextAlign.center,
                              style:  TextStyle(fontSize: sizedEng[selectedTasbeeh]),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < rowTitles.length; i++) ...[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTasbeeh = i;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    color: selectedTasbeeh == i
                                        ? CColors.green_main
                                        : Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 9,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    child: Text(
                                      rowTitles[i],
                                      style: TextStyle(
                                          color: selectedTasbeeh == i
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'Arabic'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Set Goal',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GoalButton(
                            number: '33',
                            onTap: () {
                              isGoal33 = true;
                              isGoald100 = false;
                              isGoal4166 = false;

                              setState(() {
                                isGoal1000 = false;
                              });
                            },
                            isSelected: isGoal33,
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: GoalButton(
                            number: '100',
                            onTap: () {
                              isGoal33 = false;
                              isGoald100 = true;
                              isGoal4166 = false;

                              setState(() {
                                isGoal1000 = false;
                              });
                            },
                            isSelected: isGoald100,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: GoalButton(
                            number: '1000',
                            onTap: () {
                              isGoal33 = false;
                              isGoald100 = false;
                              isGoal4166 = false;

                              setState(() {
                                isGoal1000 = true;
                              });
                            },
                            isSelected: isGoal1000,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),

                        Expanded(
                          child: GoalButton(
                            number: '4166',
                            onTap: () {
                              isGoal33 = false;
                              isGoald100 = false;
                              isGoal4166 = true;

                              setState(() {
                                isGoal1000 = false;
                              });
                            },
                            isSelected: isGoal4166,
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(15)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _value = _value + 1;
                            });

                            if (_value % 10 == 0) {
                              HapticFeedback.heavyImpact();
                            } else {
                              HapticFeedback.lightImpact();
                            }
                            if (_value == 33 && isGoal33) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _value = 0;
                              });
                            } else if (_value == 100 && isGoald100) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _value = 0;
                              });
                            } else if (_value == 1000 && isGoal1000) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _value = 0;
                              });
                            }
                            else if (_value == 1000 && isGoal4166) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _value = 0;
                              });
                            }

                            // <uses-permission android:name="android.permission.VIBRATE" />
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(60),
                                  ),
                                  color: Colors.black.withAlpha(90),
                                ),
                                child: const Image(
                                  image: AssetImage('assets/images/thumb.png'),
                                ),
                              ),
                              const Positioned.fill(
                                child: Center(
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      fontFamily: 'Number',
                                      color: Colors.yellowAccent,
                                      fontSize: 70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            _value.toString(),
                            style:  TextStyle(
                              fontFamily: 'Number',
                              color: Colors.black,
                              fontSize: fontSizeToShow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoalButton extends StatelessWidget {
  final String number;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalButton(
      {Key? key,
      required this.number,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: isSelected ? 2 : 0,
          ),
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 9,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Number',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
