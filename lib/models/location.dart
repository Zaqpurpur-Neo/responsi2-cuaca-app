class Location {
  final int id;
  final String name;
  final String country;
  final String? admin1; // Provinsi / Wilayah administratif
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.name,
    required this.country,
    this.admin1,
    required this.latitude,
    required this.longitude,
  });

  // Parsing dari response Geocoding API Open-Meteo
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tidak Diketahui',
      country: json['country'] ?? '',
      admin1: json['admin1'],
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  // Konversi ke JSON untuk disimpan di local storage (shared_preferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'admin1': admin1,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Factory khusus untuk membaca dari local storage (menggunakan format yang sama)
  factory Location.fromLocalStorage(Map<String, dynamic> json) {
    return Location.fromJson(json);
  }
}
