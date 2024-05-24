import 'dart:convert';

class VehicleOption {
  final String make;
  final String model;
  final String containerName;
  final int similarity;
  final String externalId;

  VehicleOption({
    required this.make,
    required this.model,
    required this.containerName,
    required this.similarity,
    required this.externalId,
  });

  factory VehicleOption.fromJson(Map<String, dynamic> json) {
    return VehicleOption(
      make: json['make'],
      model: json['model'],
      containerName: json['containerName'],
      similarity: json['similarity'],
      externalId: json['externalId'],
    );
  }
}

List<VehicleOption> parseVehicleOptions(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<VehicleOption>((json) => VehicleOption.fromJson(json))
      .toList();
}
