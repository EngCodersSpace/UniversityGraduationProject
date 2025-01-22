class DoubleDigitParse{
  static String? twoDigit(double? value){
    return (value!=null)?value.toStringAsFixed(2):null;
  }
}