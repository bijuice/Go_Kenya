class Trip {
  final DateTime dateFrom, dateTo;
  final int guests;
  final bool isResident;
  final String locID;
  final String locName;
  final List<dynamic> prices;

  Trip(
      {required this.locName,
      required this.dateFrom,
      required this.dateTo,
      required this.guests,
      required this.isResident,
      required this.locID,
      required this.prices});
}
