import 'package:bmi_record/controller/bmi_controller.dart';
import 'package:bmi_record/controller/sqflite_db.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'BMI Calculator - Are You Fit?',
    theme: ThemeData(
      primaryColor: Colors.pink[300],
    ),
    home: const BMIHome(),
  ));
}

class BMIHome extends StatefulWidget {
  const BMIHome({super.key});

  @override
  State<BMIHome> createState() => _BMIHomeState();
}

class _BMIHomeState extends State<BMIHome> {
  final BmiController bmiController = BmiController();
  final SQLiteController sqliteController = SQLiteController();

  double averageBMIMale = 0.0;
  double averageBMIFemale = 0.0;
  int MaleCount = 0;
  int  FemaleCount = 0;

  @override
  void initState(){
    super.initState();
    loadPreviousData();
    loadStatistics();
  }

  void loadPreviousData() async{
    await bmiController.loadPreviousData(sqliteController);
    if(mounted){
      setState(() {

      });
    }
  }

  void loadStatistics() async {
    averageBMIMale = await sqliteController.calculateAverageBMI('Male');
    averageBMIFemale = await sqliteController.calculateAverageBMI('Female');
    MaleCount = await sqliteController.GenderCount('Male');
    FemaleCount = await sqliteController.GenderCount('Female');
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator- Are You Fit?',
      style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink[900],
      ),
      body: BMICalculatorWidget(
        bmiController: bmiController,
        sqliteController: sqliteController,
        averageBMIFemale: averageBMIFemale,
        averageBMIMale: averageBMIMale,
        MaleCount: MaleCount,
        FemaleCount: FemaleCount,
        onCalculate:(){
          loadStatistics();
          if(mounted){
            setState(() {

            });
          }
        }
      ),
    );
  }
}

class BMICalculatorWidget extends StatefulWidget {
  final BmiController bmiController;
  final SQLiteController sqliteController;
  final double averageBMIMale;
  final double averageBMIFemale;
  final int MaleCount;
  final int  FemaleCount;
  final VoidCallback? onCalculate;

  const BMICalculatorWidget({
    required this.bmiController,
    required this.sqliteController,
    required this.averageBMIMale,
    required this.averageBMIFemale,
    required this.MaleCount,
    required this.FemaleCount,
    this.onCalculate});

  @override
  State<BMICalculatorWidget> createState() => _BMICalculatorWidgetState();
}

class _BMICalculatorWidgetState extends State<BMICalculatorWidget> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: widget.bmiController.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Full Name',
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.bmiController.weightController,
              decoration: const InputDecoration(
                labelText: 'Weight in kg',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.bmiController.heightController,
              decoration: const InputDecoration(
                labelText: 'Height in cm',
              ),
            ),
          ),
          const SizedBox(height:25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Gender: '),
              Radio<String>(
                value: 'Male',
                  groupValue: widget.bmiController.gender,
                  onChanged: (String? value){
                  setState(() {
                    widget.bmiController.setGender(value);
                    });
                  },
              ),
              const Text('Male'),

              Radio<String>(
                value: 'Female',
                groupValue: widget.bmiController.gender,
                onChanged: (String? value){
                  setState(() {
                    widget.bmiController.setGender(value);
                  });
                },
              ),
              const Text('Female'),
            ],
          ),
          ElevatedButton(
              onPressed: (){
                widget.bmiController.BMICalculate();
                widget.sqliteController.insertBMIRecord(widget.bmiController);
                if(widget.onCalculate !=null){
                  widget.onCalculate!();
                }
              },
              child: const Text('Calculate and Save'),
          ),
          const SizedBox(height:25),
          Text('BMI Result: ${widget.bmiController.bmiResult}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Status: ${widget.bmiController.bmiResult}',
              style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 25),
          Text('Average BMI for Males: ${widget.averageBMIMale.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),),
          Text('Average BMI for Females: ${widget.averageBMIFemale.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),),
          Text('Total Male records: ${widget.MaleCount}',
              style: const TextStyle(fontWeight: FontWeight.bold),),
          Text('Total Female records: ${widget.FemaleCount}',
              style: const TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}

