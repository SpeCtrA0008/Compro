class SensorReading {
  final double ph;
  final double suhu;
  final double mineral;
  final DateTime tanggal;

  SensorReading({
    required this.ph,
    required this.suhu,
    required this.mineral,
    required this.tanggal,
  });

  String get tanggalFormatted {
    return '${tanggal.day.toString().padLeft(2, '0')}/${tanggal.month.toString().padLeft(2, '0')}/${tanggal.year}';
  }

  String get pukul {
    return '${tanggal.hour.toString().padLeft(2, '0')}:${tanggal.minute.toString().padLeft(2, '0')}';
  }

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      ph: json['ph'].toDouble(),
      suhu: json['suhu'].toDouble(),
      mineral: json['mineral'].toDouble(),
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ph': ph,
      'suhu': suhu,
      'mineral': mineral,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}
