import 'dart:convert';
import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';

class _DataServic {
  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/public_key.txt');
  }

  Future<String> loadAsset2() async {
    return await rootBundle.loadString('assets/secret_key.txt');
  }

  Future<List<MonthlyData>> getEventsWithFiles() async {
    String pK = await loadAsset();
    String sK = await loadAsset2();
    final queryParameters = {
      'public_key': pK,
      'secret_key': sK,
    };
    Dio dio = Dio();
    String url = 'https://merrycode.com/node/bohra-calendar/events';

    var response = await dio.post(url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(queryParameters),
    );

    List<MonthlyData> monthlyList = [];
    for(var currentItem in response.data) {
      MonthlyData monthItem = MonthlyData.fromJson(currentItem);
      monthlyList.add(monthItem);
    }

    return monthlyList;
  }

  Future<List<MonthlyData>> getExtraData() async {
    String pK = await loadAsset();
    String sK = await loadAsset2();
    // "month" : -1
    final queryParameters = {
      'public_key': pK,
      'secret_key': sK,
       'month' : '-1'
    };
    Dio dio = Dio();
    String url = 'https://merrycode.com/node/bohra-calendar/events/month';

    var response = await dio.post(url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(queryParameters),
    );

    List<MonthlyData> monthlyList = [];
    for(var currentItem in response.data) {
      MonthlyData monthItem = MonthlyData.fromJson(currentItem);
      monthlyList.add(monthItem);
    }



    return monthlyList;
  }
}

final dataService = _DataServic();
