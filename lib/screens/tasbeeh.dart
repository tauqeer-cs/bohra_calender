import 'package:bohra_calender/core/constants.dart';
import 'package:flutter/material.dart';

class Tasbeeh extends StatefulWidget {
  const Tasbeeh({Key? key}) : super(key: key);

  @override
  State<Tasbeeh> createState() => _TasbeehState();
}

class _TasbeehState extends State<Tasbeeh> {
  int _value = 0;

  int _target = 33;

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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Text('بِسْمِ ٱللَّٰهِ'),

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
                          onPressed: () {
                            setState(() {
                              _value = _value + 1;
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(60),
                                  ),
                                  color: Colors.black.withAlpha(60),
                                ),
                                child: const Image(
                                  image: AssetImage('assets/images/thumb.png'),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    _value.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Number',
                                      color: Colors.white,
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
                        child: Container(),
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
