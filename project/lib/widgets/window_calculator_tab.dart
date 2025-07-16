import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/window_provider.dart';
import 'window_input_form.dart';
import 'window_list_panel.dart';
import 'cost_breakdown_widget.dart';
import 'combined_materials_widget.dart';

class WindowCalculatorTab extends StatelessWidget {
  const WindowCalculatorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WindowProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                            'حاسبة تكلفة النوافذ المتعددة',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'احسب التكلفة الدقيقة لتصنيع عدة نوافذ مع تحسين استخدام المواد',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.purple.shade100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.windows.length > 1) ...[
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${provider.totalCost.toStringAsFixed(2)} د.ت',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'التكلفة الإجمالية',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.purple.shade100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // View Mode Selector
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
                      child: _buildViewModeButton(
                        context,
                        'single',
                        'نافذة واحدة',
                        Icons.window,
                        provider.viewMode == 'single',
                        () => provider.setViewMode('single'),
                      ),
                    ),
                    Expanded(
                      child: _buildViewModeButton(
                        context,
                        'multiple',
                        'نوافذ متعددة',
                        Icons.view_list,
                        provider.viewMode == 'multiple',
                        () => provider.setViewMode('multiple'),
                      ),
                    ),
                    Expanded(
                      child: _buildViewModeButton(
                        context,
                        'combined',
                        'قائمة السلع',
                        Icons.shopping_cart,
                        provider.viewMode == 'combined',
                        () => provider.setViewMode('combined'),
                        enabled: provider.calculatedWindows > 0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content
              Expanded(
                child: provider.viewMode == 'combined'
                    ? const CombinedMaterialsWidget()
                    : Row(
                        children: [
                          // Left Panel - Window List
                          SizedBox(
                            width: 300,
                            child: WindowListPanel(),
                          ),
                          const SizedBox(width: 16),
                          // Right Panel - Input Form and Results
                          Expanded(
                            child: Row(
                              children: [
                                // Input Form
                                SizedBox(
                                  width: 350,
                                  child: WindowInputForm(),
                                ),
                                const SizedBox(width: 16),
                                // Results
                                Expanded(
                                  child: _buildResultsPanel(context, provider),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewModeButton(
    BuildContext context,
    String mode,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
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
              color: enabled
                  ? (isSelected ? Colors.white : Colors.grey.shade600)
                  : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: enabled
                    ? (isSelected ? Colors.white : Colors.grey.shade600)
                    : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsPanel(BuildContext context, WindowProvider provider) {
    if (provider.viewMode == 'multiple' && provider.calculatedWindows > 0) {
      return _buildMultipleWindowsResults(context, provider);
    } else if (provider.activeWindow?.breakdown != null && provider.viewMode == 'single') {
      return CostBreakdownWidget(
        breakdown: provider.activeWindow!.breakdown!,
        specs: provider.activeWindow!.specs,
      );
    } else {
      return _buildEmptyState(context, provider);
    }
  }

  Widget _buildMultipleWindowsResults(BuildContext context, WindowProvider provider) {
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
          Text(
            'نتائج جميع النوافذ',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: provider.windows.where((w) => w.breakdown != null).length,
              itemBuilder: (context, index) {
                final window = provider.windows.where((w) => w.breakdown != null).toList()[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            window.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${window.breakdown!.totalCost.toStringAsFixed(2)} د.ت',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'الأبعاد: ${window.specs.length.toStringAsFixed(0)}×${window.specs.width.toStringAsFixed(0)} سم',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'المواصفات: قفص 40100 ${window.specs.frameType} + فردتان ${window.specs.sashType}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المجموع الكلي:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${provider.totalCost.toStringAsFixed(2)} د.ت',
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
    );
  }

  Widget _buildEmptyState(BuildContext context, WindowProvider provider) {
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
            Icons.window,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            provider.windows.length > 1 ? 'احسب النوافذ' : 'أدخل مواصفات النافذة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.windows.length > 1
                ? 'اضغط على "احسب السلع المجمعة" لحساب قائمة السلع الموحدة أو "احسب هذه النافذة" لحساب النافذة المحددة'
                : 'قم بإدخال أبعاد النافذة والمواصفات المطلوبة ثم اضغط على "احسب التكلفة"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}