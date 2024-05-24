
class BMIModel{
 double weight;
 double height;
 String gender;

 BMIModel({
   required this.weight,
   required this.height,
   required this.gender
 });

 double BMICalculate(){
   // convert cm to m
   double heightInM = height/100.00;
   return weight / (heightInM * heightInM);
 }

 String getStatus(){
   double bmi = BMICalculate();
   if(gender == 'Male'){
     if (bmi < 18.5) {
       return  "You are Underweight. ";
     } else if (bmi >= 18.5 && bmi <= 24.9) {
       return "That is normal";
     } else if (bmi >= 25 && bmi <= 29.9) {
       return "You are Overweight!";
     } else if(bmi > 30.0){
       return "You are obese! ";
     }
   }
   else if (gender == 'Female'){
     if (bmi < 16) {
       return "You are Underweight. ";
     } else if (bmi >= 16 && bmi < 22) {
       return "That is normal! ";
     } else if (bmi >= 22 && bmi < 27) {
       return "You are overweight! ";
     } else if(bmi > 30.0){
       return "Whoa obese!";
     }
   }

     return "Unknown user or gender";

 }
}