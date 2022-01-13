import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/services/data_service.dart';
import 'package:flutter/material.dart';

import 'day_detail.dart';

class ExtraNamazListing extends StatefulWidget {
  const ExtraNamazListing({Key? key}) : super(key: key);

  @override
  State<ExtraNamazListing> createState() => _ExtraNamazListingState();
}

class _ExtraNamazListingState extends State<ExtraNamazListing> {
  //



  List<MonthlyData>? data;

  MonthlyData? bihoriNamaz;

  void loadData() async {
    data = await dataService.getExtraData();

    if (data != null) {
      bihoriNamaz = data!.firstWhere((e) => e.title == 'Bihori Namaz');
      setState(() {
        data!.removeWhere((e) => e.title == 'Bihori Namaz');
      });
      print(data);
    }
    print(data);
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          decoration: Constants.backgroundPAttern,
          child: Container(
            color: Constants.backgroundPatternTopColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if(data![index].title == 'Ramadan Namaz') {
                        return ExtraNamazItem(data: data![index] , bohriData: bihoriNamaz,);

                      }
                      return ExtraNamazItem(data: data![index]);
                    },
                    itemCount: data == null ? 0 : data!.length,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExtraNamazItem extends StatelessWidget {
  const ExtraNamazItem({
    Key? key,
    required this.data, this.bohriData,
  }) : super(key: key);

  final MonthlyData data;
  final MonthlyData? bohriData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            data.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 8,),

        if(data.title == 'Ramadan Namaz') ... [
          Padding(
            padding:  const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {


              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.transparent,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Bihori Namaz',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                ],
              ),
            ),
          ),

        ],

        for (Files currentFile in data.files) ...[
          FileItem(
            name: currentFile.title,
            onTap: () {},
            hasPDF: currentFile.pdfUr.isNotEmpty,
            hasAudio: currentFile.audioUrl.isNotEmpty,
            fileItem: currentFile,
            verticalGap: 6,
          ),
        ],
        const SizedBox(height: 8,),



      ],
    );
  }
}
