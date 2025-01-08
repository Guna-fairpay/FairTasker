
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class PriorityData{
  String? name;
  Color? color;
  static List<String> priorityList = ['High - On Time', 'Medium', 'Low', 'Feature'];

  PriorityData({this.name, this.color});

  List<PriorityData> buildPriorityList(){
    List<PriorityData> priorityDataList = [];
    priorityDataList.add(PriorityData(name: priorityList[0], color: AppC.highOnTimeP));
    priorityDataList.add(PriorityData(name: priorityList[1], color: AppC.mediumP));
    priorityDataList.add(PriorityData(name: priorityList[2], color: AppC.lowP));
    priorityDataList.add(PriorityData(name: priorityList[3], color: AppC.featureP));
    return priorityDataList;
  }
}