import 'package:flutter/material.dart';
import '../models/cost_breakdown.dart';
import '../models/window_specs.dart';

class CostBreakdownWidget extends StatelessWidget {
  final CostBreakdown breakdown;
  final WindowSpecs specs;

  const CostBreakdownWidget({
    super.key,
    required this.breakdown,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'القفص (Dormant)',
        'icon': Icons.window,
        'items': breakdown.frame,
        'color': Colors.blue,
      },
      {
        'title': 'الفردتان (Ouvrants)',
        'icon': Icons.build,
        'items': breakdown.sashes,
        'color': Colors.green,
      },
      {
        'title': 'الفاصل (40112)',
        'icon': Icons.remove,
        'items': breakdown.separator,
        'color': Colors.indigo,
      },
      {
        'title': 'الزجاج',
        'icon': Icons.visibility,
        'items': breakdown.glass,
        'color': Colors.purple,
      },
      {
        'title': 'الملحقات',
        'icon': Icons.hardware,
        'items': breakdown.hardware,
        'color': Colors.orange,
      },
    ];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade700],
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
                        '${breakdown.totalCost.toStringAsFixed(2)} د.ت',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'التكلفة الإجمالية',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blue.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${specs.length.toStringAsFixed(0)}×${specs.width.toStringAsFixed(0)} سم',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue.shade100,
                      ),
                    ),
                    Text(
                      'قفص 40100 + فردتان ${specs.sashType}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue.shade100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'تفصيل التكلفة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Categories
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final items = category['items'] as List;
                final color = category['color'] as MaterialColor;
                final totalCost = items.fold(0.0, (sum, item) => sum + item.totalCost);

                if (items.isEmpty) return const SizedBox();

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Category Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.shade50,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          border: Border.all(color: color.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category['icon'] as IconData,
                              color: color.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category['title'] as String,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: color.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${totalCost.toStringAsFixed(2)} د.ت',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: color.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Category Items
                      ...items.map((item) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} د.ت',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (item.specifications != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.specifications!,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              '${item.totalCost.toStringAsFixed(2)} د.ت',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                );
              },
            ),
          ),

          // Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المجموع الكلي:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${breakdown.totalCost.toStringAsFixed(2)} د.ت',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        context,
                        'المساحة',
                        '${((specs.length * specs.width) / 10000).toStringAsFixed(2)} م²',
                      ),
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        context,
                        'التكلفة للمتر',
                        '${(breakdown.totalCost / ((specs.length * specs.width) / 10000)).toStringAsFixed(2)} د.ت',
                      ),
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        context,
                        'عدد الفردات',
                        '2',
                      ),
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        context,
                        'نوع النافذة',
                        '${specs.color} ${specs.frameType}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}