class Location {
  final String? locID, locName, description, staffID;
  final List<dynamic>? availability;
  final List<dynamic>? images;
  final List<dynamic>? prices;
  final double? rating;
  final int? capacity;
  final List<dynamic>? geolocation;
  final List<dynamic>? tags;

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
