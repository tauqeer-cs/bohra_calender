extension DoubleExtension on double {
  double toDoubleAsFixed(int fractionDigits) {
    return double.parse(this.toStringAsFixed(fractionDigits));
  }
}
