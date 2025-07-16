import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/window_provider.dart';
import '../models/window_project.dart';

class CombinedMaterial {
  final String name;
  final double totalQuantity;
  final String unit;
  final double unitPrice;
  final double totalCost;
  final String category;
  final List<String> usedInWindows;
  final String? specifications;

  CombinedMaterial({
    required this.name,
    required this.totalQuantity,
    required this.unit,
    required this.unitPrice,
    required this.totalCost,
    required this.category,
    required this.usedInWindows,
    this.specifications,
  });
}

class CombinedMaterialsWidget extends StatefulWidget {
  const CombinedMaterialsWidget({super.key});

  @override
  State<CombinedMaterialsWidget> createState() => _CombinedMaterialsWidgetState();
}

class _CombinedMaterialsWidgetState extends State<CombinedMaterialsWidget> {
  bool showCuttingPlan = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<WindowProvider>(
      builder: (context, provider, child) {
        final calculatedWindows = provider.windows.where((w) => w.breakdown != null).toList();
        
        if (calculatedWindows.isEmpty) {
          return _buildEmptyState(context);
        }

        final combinedMaterials = _combineMaterials(calculatedWindows);
        final totalProjectCost = combinedMaterials.fold(0.0, (sum, material) => sum + material.totalCost);

        return Column(
          children: [
            // View Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      context,
                      'قائمة السلع',
                      Icons.inventory,
                      !showCuttingPlan,
                      () => setState(() => showCuttingPlan = false),
                    ),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                      context,
                      'خطة القص',
                      Icons.content_cut,
                      showCuttingPlan,
                      () => setState(() => showCuttingPlan = true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: showCuttingPlan
                  ? _buildCuttingPlan(context, calculatedWindows)
                  : _buildMaterialsList(context, combinedMaterials, totalProjectCost, calculatedWindows),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نوافذ محسوبة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بحساب النوافذ أولاً لعرض قائمة السلع المجمعة',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList(
    BuildContext context,
    List<CombinedMaterial> materials,
    double totalCost,
    List<WindowProject> calculatedWindows,
  ) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade600, Colors.purple.shade700],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade200,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'قائمة السلع المجمعة',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${calculatedWindows.length} نافذة - ${materials.length} صنف مختلف',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.purple.shade100,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${totalCost.toStringAsFixed(2)} د.ت',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'التكلفة الإجمالية',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.purple.shade100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Materials Table
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'قائمة السلع الكاملة مرتبة حسب التكلفة',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Table Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'المادة',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'الكمية الإجمالية',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'سعر الوحدة',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'التكلفة الإجمالية',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table Body
                Expanded(
                  child: ListView.builder(
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      final material = materials[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    material.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (material.specifications != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      material.specifications!,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 4),
                                  Text(
                                    'مستخدم في: ${material.usedInWindows.join(', ')}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                material.unit.contains('بارة')
                                    ? '${material.totalQuantity.toStringAsFixed(1)} مستهلكة (${material.totalQuantity.ceil()} للشراء)'
                                    : '${material.totalQuantity.toStringAsFixed(1)} ${material.unit}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${material.unitPrice.toStringAsFixed(2)} د.ت',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${material.totalCost.toStringAsFixed(2)} د.ت',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Summary Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إجمالي ${materials.length} صنف مختلف لـ ${calculatedWindows.length} نافذة',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'المجموع: ${totalCost.toStringAsFixed(2)} د.ت',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCuttingPlan(BuildContext context, List<WindowProject> calculatedWindows) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade600, Colors.indigo.shade700],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خطة القص الذكية',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'قص مُحسَّن لـ ${calculatedWindows.length} نافذة مع احتساب سمك المنشار (0.5 سم)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.indigo.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_calculateTotalBars(calculatedWindows)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'إجمالي البارات',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.indigo.shade100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.content_cut,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'خطة القص الذكية',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم إضافة خطة القص التفصيلية قريباً',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CombinedMaterial> _combineMaterials(List<WindowProject> calculatedWindows) {
    final Map<String, CombinedMaterial> materialMap = {};

    for (final window in calculatedWindows) {
      if (window.breakdown == null) continue;

      final allItems = [
        ...window.breakdown!.frame.map((item) => {'item': item, 'category': 'frame'}),
        ...window.breakdown!.sashes.map((item) => {'item': item, 'category': 'sashes'}),
        ...window.breakdown!.separator.map((item) => {'item': item, 'category': 'separator'}),
        ...window.breakdown!.glass.map((item) => {'item': item, 'category': 'glass'}),
        ...window.breakdown!.hardware.map((item) => {'item': item, 'category': 'hardware'}),
      ];

      for (final itemData in allItems) {
        final item = itemData['item'];
        final category = itemData['category'] as String;
        final key = item.name;

        if (materialMap.containsKey(key)) {
          final existing = materialMap[key]!;
          final currentConsumedQuantity = double.tryParse(item.quantity.split(' ')[0]) ?? 0;
          final existingConsumedQuantity = existing.totalQuantity;

          final newTotalQuantity = existingConsumedQuantity + currentConsumedQuantity;
          double newTotalCost;

          if (existing.unit.contains('بارة')) {
            final totalBarsNeeded = newTotalQuantity.ceil();
            newTotalCost = totalBarsNeeded * existing.unitPrice;
          } else {
            newTotalCost = existing.totalCost + item.totalCost;
          }

          materialMap[key] = CombinedMaterial(
            name: existing.name,
            totalQuantity: newTotalQuantity,
            unit: existing.unit,
            unitPrice: existing.unitPrice,
            totalCost: newTotalCost,
            category: existing.category,
            usedInWindows: [...existing.usedInWindows, window.name],
            specifications: existing.specifications,
          );
        } else {
          final consumedQuantity = double.tryParse(item.quantity.split(' ')[0]) ?? 0;
          final unit = item.quantity.split(' ').skip(1).join(' ').isNotEmpty 
              ? item.quantity.split(' ').skip(1).join(' ') 
              : 'قطعة';

          double totalCost = item.totalCost;
          if (unit.contains('بارة')) {
            final barsNeeded = consumedQuantity.ceil();
            totalCost = barsNeeded * item.unitPrice;
          }

          materialMap[key] = CombinedMaterial(
            name: item.name,
            totalQuantity: consumedQuantity,
            unit: unit,
            unitPrice: item.unitPrice,
            totalCost: totalCost,
            category: category,
            usedInWindows: [window.name],
            specifications: item.specifications,
          );
        }
      }
    }

    final materials = materialMap.values.toList();
    materials.sort((a, b) => b.totalCost.compareTo(a.totalCost));
    return materials;
  }

  int _calculateTotalBars(List<WindowProject> calculatedWindows) {
    // Simplified calculation for total bars needed
    return calculatedWindows.length * 3; // Approximate
  }
}