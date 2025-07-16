class WindowSpecs {
  final double length;
  final double width;
  final String color;
  final String frameType;
  final String sashType;
  final String sashSubType;
  final String glassType;

  WindowSpecs({
    required this.length,
    required this.width,
    required this.color,
    required this.frameType,
    required this.sashType,
    required this.sashSubType,
    required this.glassType,
  });

  WindowSpecs copyWith({
    double? length,
    double? width,
    String? color,
    String? frameType,
    String? sashType,
    String? sashSubType,
    String? glassType,
  }) {
    return WindowSpecs(
      length: length ?? this.length,
      width: width ?? this.width,
      color: color ?? this.color,
      frameType: frameType ?? this.frameType,
      sashType: sashType ?? this.sashType,
      sashSubType: sashSubType ?? this.sashSubType,
      glassType: glassType ?? this.glassType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'color': color,
      'frameType': frameType,
      'sashType': sashType,
      'sashSubType': sashSubType,
      'glassType': glassType,
    };
  }

  factory WindowSpecs.fromJson(Map<String, dynamic> json) {
    return WindowSpecs(
      length: json['length']?.toDouble() ?? 100.0,
      width: json['width']?.toDouble() ?? 100.0,
      color: json['color'] ?? 'blanc',
      frameType: json['frameType'] ?? 'eurosist',
      sashType: json['sashType'] ?? '6007',
      sashSubType: json['sashSubType'] ?? 'inoforme',
      glassType: json['glassType'] ?? 'simple',
    );
  }
}