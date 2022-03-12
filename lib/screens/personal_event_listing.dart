import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/services/objectbox_service.dart';
import 'package:flutter/material.dart';

import 'add_personal_event.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PersonalEventListing extends StatefulWidget {
  const PersonalEventListing({Key? key}) : super(key: key);

  @override
  _PersonalEventListingState createState() => _PersonalEventListingState();
}

class _PersonalEventListingState extends State<PersonalEventListing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<PersonalEvent> areas = [];

  @override
  void initState() {
    super.initState();

    areas = objectBoxService.store.box<PersonalEvent>().getAll();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Events'),
        actions: [
          TextButton(
            onPressed: () async {
              var check = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPersonalEvent(),
                ),
              );

              if (check != null) {
                loadData();
              }
            },
            child:  Text(
              'Add Event',
              style: TextStyle(color: Constants.inkBlack),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: Constants.backgroundPAttern,
        child: Container(
          color: Constants.backgroundPatternTopColor,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: areas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PersonalListItem(
                        personalEvent: areas[index],
                        deleteTapped: () {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            desc: "Are you sure you want to delete this event.",
                            buttons: [
                              DialogButton(
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  final box = objectBoxService.store
                                      .box<PersonalEvent>();
                                  final id =
                                      box.remove(areas[index].id); // Create

                                  Navigator.pop(context);

                                  loadData();
                                },
                                color: const Color.fromRGBO(0, 179, 134, 1.0),
                              ),
                              DialogButton(
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(116, 116, 191, 1.0),
                                  Color.fromRGBO(52, 138, 199, 1.0)
                                ]),
                              )
                            ],
                          ).show();
                        },
                        syncTapped: () {


                          if(!areas[index].alreadySynced) {


                          }

                        },
                      );
                    }),
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

  void loadData() {
    setState(() {
      areas = objectBoxService.store.box<PersonalEvent>().getAll();
    });
  }
}

class PersonalListItem extends StatelessWidget {
  final PersonalEvent personalEvent;

  final VoidCallback deleteTapped;
  final VoidCallback syncTapped;

  const PersonalListItem({
    Key? key,
    required this.personalEvent,
    required this.deleteTapped,
    required this.syncTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  personalEvent.title,
                  style:  TextStyle(
                      color: Constants.inkBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
              Text(
      personalEvent.hijriMonthString,
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  personalEvent.details,
                  style:  TextStyle(
                      color: Constants.inkBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              IconButton(
                onPressed: syncTapped,
                icon: const Icon(
                  Icons.sync,
                  color: Colors.brown,
                  size: 32,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              IconButton(
                onPressed: deleteTapped,
                icon:  Icon(
                  Icons.close,
                  color: Constants.inkBlack,
                  size: 32,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
