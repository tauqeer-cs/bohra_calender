import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/screens/washeq_counter.dart';
import 'package:flutter/material.dart';

import 'day_detail.dart';
import 'extra_name_listing.dart';

class BihoriNamazView extends StatefulWidget {
  MonthlyData data;


   BihoriNamazView({Key? key,required this.data}) : super(key: key);

  @override
  _BihoriNamazViewState createState() => _BihoriNamazViewState();
}

class _BihoriNamazViewState extends State<BihoriNamazView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data.title),),
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

                      return ExtraNamazItem(data: widget.data,hideTitle: true , isBihori: true,);
                    },
                    itemCount: 1,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),

                const Divider(color: Colors.white,),


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
