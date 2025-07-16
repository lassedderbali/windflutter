import 'cost_item.dart';

class CostBreakdown {
  final List<CostItem> frame;
  final List<CostItem> sashes;
  final List<CostItem> separator;
  final List<CostItem> glass;
  final List<CostItem> hardware;
  final double totalCost;

  CostBreakdown({
    required this.frame,
    required this.sashes,
    required this.separator,
    required this.glass,
    required this.hardware,
    required this.totalCost,
  });

  Map<String, dynamic> toJson() {
    return {
      'frame': frame.map((item) => item.toJson()).toList(),
      'sashes': sashes.map((item) => item.toJson()).toList(),
      'separator': separator.map((item) => item.toJson()).toList(),
      'glass': glass.map((item) => item.toJson()).toList(),
      'hardware': hardware.map((item) => item.toJson()).toList(),
      'totalCost': totalCost,
    };
  }

  factory CostBreakdown.fromJson(Map<String, dynamic> json) {
    return CostBreakdown(
      frame: (json['frame'] as List?)
          ?.map((item) => CostItem.fromJson(item))
          .toList() ?? [],
      sashes: (json['sashes'] as List?)
          ?.map((item) => CostItem.fromJson(item))
          .toList() ?? [],
      separator: (json['separator'] as List?)
          ?.map((item) => CostItem.fromJson(item))
          .toList() ?? [],
      glass: (json['glass'] as List?)
          ?.map((item) => CostItem.fromJson(item))
          .toList() ?? [],
      hardware: (json['hardware'] as List?)
          ?.map((item) => CostItem.fromJson(item))
          .toList() ?? [],
      totalCost: json['totalCost']?.toDouble() ?? 0.0,
    );
  }
}