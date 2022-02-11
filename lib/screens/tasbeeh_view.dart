import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:flutter/material.dart';

class TasbeehView extends StatefulWidget {
  const TasbeehView({Key? key}) : super(key: key);

  @override
  State<TasbeehView> createState() => _TasbeehViewState();
}

class _TasbeehViewState extends State<TasbeehView> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbeeh'),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 60),
              child: Column(
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 337,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/counter1_1.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 221,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/counter1_2.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: AnimatedFlipCounter(
                          textStyle: const TextStyle(
                              fontSize: 70, fontWeight: FontWeight.bold),
                          duration: const Duration(milliseconds: 500),
                          value: _value, // pass in a value like 2014
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 860,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/counter1_3.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 20,
                            shape: const CircleBorder(),
                            primary: Colors.white,
                            side: BorderSide(
                              width: 15.0,
                              color: Colors.green.withOpacity(0.5),
                            ),
                          ),
                          child: Container(
                            width: 200,
                            height: 200,
                            alignment: Alignment.center,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: const Text(
                              '',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _value = _value + 1;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: Container(),
                  ),
                  //
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
