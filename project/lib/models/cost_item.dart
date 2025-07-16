class CostItem {
  final String name;
  final String quantity;
  final double unitPrice;
  final double totalCost;
  final String? specifications;

  CostItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalCost,
    this.specifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalCost': totalCost,
      'specifications': specifications,
    };
  }

  factory CostItem.fromJson(Map<String, dynamic> json) {
    return CostItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
      unitPrice: json['unitPrice']?.toDouble() ?? 0.0,
      totalCost: json['totalCost']?.toDouble() ?? 0.0,
      specifications: json['specifications'],
    );
  }
}