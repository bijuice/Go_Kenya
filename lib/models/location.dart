class Location {
  final String? locID, locName, description, staffID;
  final List<DateTime>? availability;
  final List<String>? images;
  final List<int>? prices;
  final double? rating;
  final int? capacity;
  final List<String>? geolocation;
  final List<String>? tags;

  Location(
      {this.locID,
      this.locName,
      this.description,
      this.staffID,
      this.availability,
      this.images,
      this.prices,
      this.rating,
      this.capacity,
      this.geolocation,
      this.tags});
}
