class AdminTrip {
  final DateTime dateFrom, dateTo;
  final int guests;
  final bool isResident;
  final String locID;
  final String locName;
  final List<dynamic>? prices;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;

  AdminTrip(
      {required this.dateFrom,
      required this.dateTo,
      required this.guests,
      required this.isResident,
      required this.locID,
      required this.locName,
      this.prices,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.phoneNumber});
}
