String dateString(DateTime date) {
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');
  String year = date.year.toString();

  return "$year-$month-$day";
}
