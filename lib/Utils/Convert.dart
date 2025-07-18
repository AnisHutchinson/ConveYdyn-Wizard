import 'dart:math';

class Tools {
  inchToMilimeter(double value) {
    return value * 25.4;
  }

  milimeterToInch(double value) {
    return value / 25.4;
  }

  meterToFeet(double value) {
    return value * 3.2808399;
  }

  feetToMeter(double value) {
    return value / 3.2808399;
  }

  lbsToKg(double value) {
    return value / 2.20462262;
  }

  kgToLbs(double value) {
    return value * 2.20462262;
  }
}
