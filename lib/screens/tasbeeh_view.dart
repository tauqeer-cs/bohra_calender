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
        title: Text('Tasbeeh'),
      ),
      body: SafeArea(
        child: Container(
          decoration: Constants.backgroundPAttern,
          child: Container(
            color: Constants.backgroundPatternTopColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: AnimatedFlipCounter(
                      textStyle: const TextStyle(
                          fontSize: 100, fontWeight: FontWeight.bold),
                      duration: const Duration(milliseconds: 500),
                      value: _value, // pass in a value like 2014
                    ),
                  ),
                  ElevatedButton(

                    /*
                    style: ElevatedButton.styleFrom(side: BorderSide(width: 5.0, color: Colors.red,)),
                     */
                    style: ElevatedButton.styleFrom(
                      elevation: 20,
                      shape: const CircleBorder(),
                      primary: Colors.white,
                      side:  BorderSide(
                        width: 15.0,
                        color: Colors.green.withOpacity(0.5),
                      ),
                    ),
                    child: Container(

                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
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
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade600),
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
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
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
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
