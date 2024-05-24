import 'package:bmi_record/controller/sqflite_db.dart';
import 'package:bmi_record/model/bmi_model.dart';
import 'package:flutter/material.dart';

class BmiController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String gender = 'Male';
  String bmiResult = "";
  String bmiStatus = "";

  void setGender(String? value){
    if(value != null){
      gender = value;
    }
  }

  void BMICalculate(){
    final double weight = double.parse(weightController.text);
    final double height = double.parse(heightController.text);
    final bmiModel = BMIModel(weight: weight, height: height, gender: gender);

    bmiResult = bmiModel.BMICalculate().toStringAsFixed(2);
    bmiStatus = bmiModel.getStatus();
  }

  Future<void> loadPreviousData (SQLiteController sqLiteController) async{
    final data = await sqLiteController.getPreviousData();
    if (data != null){
      nameController.text = data['fullname'];
      weightController.text = data['weight'].toString();
      heightController.text = data['weight'].toString();
      setGender(data['gender']);
      bmiResult = data['bmi'].toString();
      bmiStatus = data['status'];
    }
  }
}