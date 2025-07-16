import 'window_specs.dart';
import 'cost_breakdown.dart';

class WindowProject {
  final String id;
  final String name;
  final WindowSpecs specs;
  final CostBreakdown? breakdown;

  WindowProject({
    required this.id,
    required this.name,
    required this.specs,
    this.breakdown,
  });

  WindowProject copyWith({
    String? id,
    String? name,
    WindowSpecs? specs,
    CostBreakdown? breakdown,
  }) {
    return WindowProject(
      id: id ?? this.id,
      name: name ?? this.name,
      specs: specs ?? this.specs,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specs': specs.toJson(),
      'breakdown': breakdown?.toJson(),
    };
  }

  factory WindowProject.fromJson(Map<String, dynamic> json) {
    return WindowProject(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specs: WindowSpecs.fromJson(json['specs'] ?? {}),
      breakdown: json['breakdown'] != null 
          ? CostBreakdown.fromJson(json['breakdown'])
          : null,
    );
  }
}