enum Age {
  less_15,
  bt_15_50,
  bt_50_65,
  sup_65,
}

class Symptoms {
  int counterMinorGravityFactor = 0; // العوامل الصغرى
  int prognosticFactors = 0; //العوامل الإنذارية
  int majorGravityFactors = 0; // العوامل الكبرى

  bool isCough = false; // سعال
  bool isPains = false; // آلام
  bool isFever = false; // حمى
  bool isDiarrhea = false; // إسهال
  bool isAnosmie = false; // فقر دم

  int weight = 0;
  int length = 0;

  String age;
}
