enum Age {
  less_15,
  bt_15_50,
  bt_50_65,
  sup_65,
}

class SymptomsModel {
  int counterMinorGravityFactor = 0; // العوامل الصغرى
  int prognosticFactors = 0; //العوامل الإنذارية
  int majorGravityFactors = 0; // العوامل الكبرى

  bool isCough = false; // سعال
  bool isPains = false; // آلام
  bool isFever = false; // حمى
  bool isDiarrhea = false; // إسهال
  bool isAnosmie = false; // فقر دم

  double weight = 0.0;
  double length = 0.0;
  double bMI = 0.0;

  Age age;

  void restart() {
    counterMinorGravityFactor = 0;
    prognosticFactors = 0;
    majorGravityFactors = 0;
    isCough = false;
    isPains = false;
    isFever = false;
    isDiarrhea = false;
    isAnosmie = false;
    weight = 0.0;
    length = 0.0;
    bMI = 0.0;
    age = null;
  }
}
