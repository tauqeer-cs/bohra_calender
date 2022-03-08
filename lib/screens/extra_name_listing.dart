import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/screens/washeq_counter.dart';
import 'package:bohra_calender/services/data_service.dart';
import 'package:flutter/material.dart';

import 'bihori_namaz.dart';
import 'day_detail.dart';

class ExtraNamazListing extends StatefulWidget {
  bool isOther;
  bool isDuas;

  List<MonthlyData>? monthlyListData;

  MonthlyData? monthlyData;

  ExtraNamazListing(
      {Key? key,
      this.isOther = false,
      this.monthlyData,
      this.isDuas = false,
      this.monthlyListData})
      : super(key: key);

  @override
  State<ExtraNamazListing> createState() => _ExtraNamazListingState();
}

class _ExtraNamazListingState extends State<ExtraNamazListing> {
  List<MonthlyData>? data;

  MonthlyData? bihoriNamaz;

  bool isLoading = true;

  void loadData() async {
    data = await dataService.getExtraData();

    isLoading = false;
    if (data != null) {
      bihoriNamaz = data!.firstWhere((e) => e.title == 'Bihori Namaz');
      setState(() {
        data!.removeWhere((e) => e.title == 'Bihori Namaz');
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isOther && widget.monthlyData != null) {
      isLoading = false;

      data = [widget.monthlyData!];
    } else if (widget.isDuas && widget.monthlyListData != null) {
      isLoading = false;

      data = widget.monthlyListData!;
    } else {
      loadData();
    }
  }

  String get barTitle {
    if (widget.isDuas) {
      return 'Duas';
    }
    if (widget.isOther) {
      return 'Other Namaz';
    }
    return 'Bihori Namaz';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(barTitle),
      ),
      body: SafeArea(
        child: Container(
          decoration: Constants.backgroundPAttern,
          child: Container(
            color: Constants.backgroundPatternTopColor,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ExtraNamazItem(
                              data: data![index],
                              hideTitle: widget.isOther,
                              showOnlyOne: widget.isDuas && index == 0,
                            );
                          },
                          itemCount: data == null ? 1 : data!.length,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
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
  final bool hideTitle;

  final bool showOnlyOne;

  final bool isBihori;

  const ExtraNamazItem(
      {Key? key,
      required this.data,
      this.hideTitle = false,
      this.showOnlyOne = false,
      this.isBihori = false})
      : super(key: key);

  final MonthlyData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!hideTitle) ...[
          Align(
            alignment: Alignment.center,
            child: Text(
              data.title,
              style: TextStyle(
                  color: Constants.inkBlack,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
        for (int i = 0; i < (showOnlyOne ? 1 : data.files.length); i++) ...[
          if (isBihori &&
              data.files[i].title.contains('5-') &&
              data.files[i].title.contains('Niyat') &&
              data.files[i].pdfUr.isNotEmpty &&
              data.files[i].audioUrl.isNotEmpty) ...[
            Column(
              children: [
                const SizedBox(
                  height: 4,
                ),
                WasheqButton(
                  title: 'Tahajood Namaz Counter',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WasheqCounterView(
                          files: [],
                          isTahajud: true,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                FileItem(
                  data: showOnlyOne ? data : null,
                  name: data.files[i].title,
                  onTap: () {},
                  hasPDF: data.files[i].pdfUr.isNotEmpty,
                  hasAudio: data.files[i].audioUrl.isNotEmpty,
                  fileItem: data.files[i],
                  verticalGap: 3,
                  otherColor: i % 2 == 0,
                ),
              ],
            ),
          ] else ...[
            FileItem(
              data: showOnlyOne ? data : null,
              name: data.files[i].title,
              onTap: () {},
              hasPDF: data.files[i].pdfUr.isNotEmpty,
              hasAudio: data.files[i].audioUrl.isNotEmpty,
              fileItem: data.files[i],
              verticalGap: 3,
              otherColor: i % 2 == 0,
              shouldContinueAudio:
                  data.title.contains('Alhamdo-Laukshemo'),

            ),
          ],
        ],
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
