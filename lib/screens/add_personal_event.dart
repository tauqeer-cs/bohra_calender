import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/services/objectbox_service.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

class AddPersonalEvent extends StatefulWidget {
  const AddPersonalEvent({Key? key}) : super(key: key);

  @override
  State<AddPersonalEvent> createState() => _AddPersonalEventState();
}

class _AddPersonalEventState extends State<AddPersonalEvent> {
  String? selectedDay;
  String? selectedMonthString;

  var days = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
  ];

  TextEditingController controller = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();

  //  ClassItemInfo.islamicMonthName
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Container(
        decoration: Constants.backgroundPAttern,
        child: Container(
          color: Constants.backgroundPatternTopColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButton<String>(
                      value: selectedDay,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      dropdownColor: Colors.grey.shade900,
                      iconEnabledColor: Colors.transparent,
                      hint: const Text(
                        'Select Hijri Day',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      items: days.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedDay = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButton<String>(
                      value: selectedMonthString,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      dropdownColor: Colors.grey.shade900,
                      iconEnabledColor: Colors.transparent,
                      hint: const Text(
                        'Select Hijri Month',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      items: ClassItemInfo.islamicMonthName.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonthString = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.yellowAccent,
                        hoverColor: Colors.red,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        labelText: 'Event Title',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: controllerDetail,
                      maxLines: 10,
                      minLines: 1,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.yellowAccent,
                        hoverColor: Colors.red,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        labelText: 'Event Details',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (selectedDay == null ||
                            selectedMonthString == null ||
                            controller.text.isEmpty ||
                            controllerDetail.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Please fill all fields.'),
                                      ),
                                    ),
                                  ));

                          return;
                        }

                        int indexMonth = ClassItemInfo.islamicMonthName.indexOf(selectedMonthString!);

                        var events = PersonalEvent()
                          ..idNumber = 1
                          ..title = controller.text
                          ..details = controllerDetail.text
                          ..hijriDay = int.parse(selectedDay!)
                          ..hijriMonth = indexMonth;

                        final box = objectBoxService.store.box<PersonalEvent>();
                        final id = box.put(events); // Create

                        Navigator.pop(context,true);

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Entity()
class PersonalEvent {
  int id = 0;
  int idNumber = 0;

  int hijriDay = 0;

  int hijriMonth = 0;

  String title = '';

  String details = '';

  bool alreadySynced = false;

  String get hijriMonthString {
    return ClassItemInfo.islamicMonthName[hijriMonth];
  }
}
