import 'package:bohra_calender/core/colors.dart';
import 'package:flutter/cupertino.dart';

class MonthlyData {
  int id = 0;
  String title = '';
  int month = 0;
  int day = 0;
  String color_tag = '';

  Color backgroundColor = CColors.blue_inside;

  //"color_tag": "green",
  List<Files> files = const [];

  MonthlyData(
      {this.id = 0,
      this.title = '',
      this.month = 0,
      this.day = 0,
      this.files = const [],
      this.color_tag = '',
      this.backgroundColor = CColors.blue_inside});

  MonthlyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    month = json['month'];
    day = json['day'];
    if (json['color_tag'] != null) {
      color_tag = json['color_tag'];
    }

    if (color_tag.isEmpty) {
      backgroundColor = CColors.blue_inside;
    }
    else if (color_tag == 'white') {
      backgroundColor = CColors.light_gray_color;
    }
    else if (color_tag == 'green' || color_tag == 'orange') {
      //light_red
      backgroundColor = CColors.light_red;
    } else if (color_tag == 'yellow') {
      backgroundColor = CColors.yellow_color;
    } else if (color_tag == 'blue') {
      backgroundColor = CColors.blue_inside;
    }



    if(id == 332){
      print('');

    }
    if (json['files'] != null) {
      files = [];
      json['files'].forEach((v) {
        files.add(Files.fromJson(v));
      });

      for (Files file in files) {



        var firstWhere = files
            .where((e) => file.title == e.title && (e.id != file.id))
            .toList();

        if (firstWhere.isNotEmpty) {
          if (firstWhere[0].pdfUr.isEmpty &&
              firstWhere[0].audioUrl.isNotEmpty &&
              file.pdfUr.isNotEmpty) {
            file.audioUrl = firstWhere[0].fileUrl;
            firstWhere[0].fileToRemove = true;
          } else if (firstWhere[0].audioUrl.isEmpty &&
              firstWhere[0].pdfUr.isNotEmpty &&
              file.audioUrl.isNotEmpty) {

            file.pdfUr = firstWhere[0].fileUrl;
            firstWhere[0].fileToRemove = true;
          }
        }
      }

      files = files.where((e) => e.fileToRemove == false).toList();

      print('');

      /*
              if (calenderObject.data != null) {
          for (MonthlyData currentData in calenderObject.data!) {
            if (currentData.files.isNotEmpty) {

              for (Files file in currentData.files) {

                var firstWhere =
                    currentData.files.where((e) => file.title == e.title && (e.id != file.id)).toList();

                if(firstWhere.isNotEmpty) {

                  if (firstWhere[0].pdfUr.isEmpty &&
                      firstWhere[0].audioUrl.isNotEmpty &&
                      file.pdfUr.isNotEmpty) {
                    file.audioUrl = firstWhere[0].fileUrl;
                    firstWhere[0].fileToRemove = true;

                  } else if (firstWhere[0].audioUrl.isEmpty &&
                      firstWhere[0].pdfUr.isNotEmpty &&
                      file.audioUrl.isNotEmpty) {
                    file.pdfUr = firstWhere[0].fileUrl;
                    firstWhere[0].fileToRemove = true;
                  }

                }

              }

              currentData.files = currentData.files.where((e) => e.fileToRemove == false).toList();

              print('');

            }
          }
        }
       */
    }

    if(this.files.length > 40){
      print('');

    }
    print('');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['month'] = month;
    data['day'] = day;
    if (files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  int id = 0;
  String title = '';
  String fileName = '';
  String lastUpdate = '';
  String fileUrl = '';
  String pdfUr = '';
  String audioUrl = '';
  bool fileToRemove = false;

  Files(
      {this.id = 0,
      this.title = '',
      this.fileName = '',
      this.lastUpdate = '',
      this.fileUrl = ''});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if(title == '') {

    }
    fileName = json['file_name'];
    lastUpdate = json['last_update'];
    fileUrl = json['file_url'];
    if (fileUrl.contains('http://localhost:3000')) {
      fileUrl = fileUrl.replaceRange(0, 'http://localhost:3000'.length,
          'https://merrycode.com/node/bohra-calendar');
    }
    if (fileUrl.contains('.pdf') || fileUrl.contains('.png') || fileUrl.contains('.jpg') ) {
      pdfUr = fileUrl;
    } else if (fileUrl.contains('mp3') ||
        fileUrl.contains('m4a') ||
        fileUrl.contains('wav') || fileUrl.contains('.amr')) {
      audioUrl = fileUrl;
    }
    else {
      pdfUr = fileUrl;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['file_name'] = this.fileName;
    data['last_update'] = this.lastUpdate;
    data['file_url'] = fileUrl;

    return data;
  }
}
