import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/window_provider.dart';

class WindowInputForm extends StatelessWidget {
  const WindowInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WindowProvider>(
      builder: (context, provider, child) {
        final activeWindow = provider.activeWindow;
        if (activeWindow == null) return const SizedBox();

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
              Row(
                children: [
                  Icon(
                    Icons.calculate,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activeWindow.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dimensions
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      context,
                      'الطول (سم)',
                      activeWindow.specs.length,
                      (value) => provider.updateWindowSpecs(
                        activeWindow.specs.copyWith(length: value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNumberField(
                      context,
                      'العرض (سم)',
                      activeWindow.specs.width,
                      (value) => provider.updateWindowSpecs(
                        activeWindow.specs.copyWith(width: value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Color Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette,
                          color: Colors.blue.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'اللون الموحد',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      context,
                      'اختر اللون',
                      activeWindow.specs.color,
                      provider.colorOptions.map((color) => DropdownMenuItem(
                        value: color['value'],
                        child: Text(color['label']!),
                      )).toList(),
                      (value) => _handleColorChange(provider, activeWindow, value!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Frame Section
              _buildSectionHeader(context, 'القفص (40100)'),
              const SizedBox(height: 12),
              _buildDropdownField(
                context,
                'نوع القفص',
                activeWindow.specs.frameType,
                provider.getFrameOptions(activeWindow.specs.color).map((option) => DropdownMenuItem(
                  value: option['value'],
                  child: Text('40100 ${option['label']}'),
                )).toList(),
                (value) => provider.updateWindowSpecs(
                  activeWindow.specs.copyWith(frameType: value),
                ),
              ),
              const SizedBox(height: 24),

              // Sash Section
              _buildSectionHeader(context, 'الفردة'),
              const SizedBox(height: 12),
              _buildDropdownField(
                context,
                'نوع الفردة الرئيسي',
                activeWindow.specs.sashType,
                provider.getSashOptions(activeWindow.specs.color).map((option) => DropdownMenuItem(
                  value: option['value'],
                  child: Text(option['label']),
                )).toList(),
                (value) => _handleSashTypeChange(provider, activeWindow, value!),
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                context,
                'نوع الفردة التفصيلي',
                activeWindow.specs.sashSubType,
                _getSashSubTypes(provider, activeWindow).map((type) => DropdownMenuItem(
                  value: type['value'],
                  child: Text('${activeWindow.specs.sashType} ${type['label']}'),
                )).toList(),
                (value) => provider.updateWindowSpecs(
                  activeWindow.specs.copyWith(sashSubType: value),
                ),
              ),
              const SizedBox(height: 24),

              // Glass Type
              _buildDropdownField(
                context,
                'نوع الزجاج',
                activeWindow.specs.glassType,
                const [
                  DropdownMenuItem(value: 'simple', child: Text('زجاج عادي 4مم')),
                  DropdownMenuItem(value: 'double', child: Text('زجاج مزدوج')),
                  DropdownMenuItem(value: 'tempered', child: Text('زجاج مقوى')),
                ],
                (value) => provider.updateWindowSpecs(
                  activeWindow.specs.copyWith(glassType: value),
                ),
              ),
              const SizedBox(height: 32),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isCalculating ? null : provider.calculateSingleWindow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: provider.isCalculating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('جاري الحساب...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calculate, size: 20),
                            const SizedBox(width: 8),
                            const Text('احسب هذه النافذة'),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade900,
        ),
      ),
    );
  }

  Widget _buildNumberField(
    BuildContext context,
    String label,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value.toStringAsFixed(0),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          onChanged: (val) {
            final doubleVal = double.tryParse(val);
            if (doubleVal != null && doubleVal >= 50 && doubleVal <= 300) {
              onChanged(doubleVal);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>(
    BuildContext context,
    String label,
    T value,
    List<DropdownMenuItem<T>> items,
    Function(T?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }

  void _handleColorChange(WindowProvider provider, activeWindow, String newColor) {
    final frameOptions = provider.getFrameOptions(newColor);
    final sashOptions = provider.getSashOptions(newColor);
    
    final firstFrameOption = frameOptions.isNotEmpty ? frameOptions.first : null;
    final firstSashOption = sashOptions.isNotEmpty ? sashOptions.first : null;
    final firstSashSubType = firstSashOption != null && 
        (firstSashOption['types'] as List).isNotEmpty 
        ? (firstSashOption['types'] as List).first : null;

    provider.updateWindowSpecs(activeWindow.specs.copyWith(
      color: newColor,
      frameType: firstFrameOption?['value'] ?? 'eurosist',
      sashType: firstSashOption?['value'] ?? '6007',
      sashSubType: firstSashSubType?['value'] ?? 'inoforme',
    ));
  }

  void _handleSashTypeChange(WindowProvider provider, activeWindow, String newSashType) {
    final sashOptions = provider.getSashOptions(activeWindow.specs.color);
    final sashOption = sashOptions.firstWhere(
      (opt) => opt['value'] == newSashType,
      orElse: () => sashOptions.first,
    );
    final firstType = (sashOption['types'] as List).isNotEmpty 
        ? (sashOption['types'] as List).first : null;
    
    provider.updateWindowSpecs(activeWindow.specs.copyWith(
      sashType: newSashType,
      sashSubType: firstType?['value'] ?? 'inoforme',
    ));
  }

  List<Map<String, dynamic>> _getSashSubTypes(WindowProvider provider, activeWindow) {
    final sashOptions = provider.getSashOptions(activeWindow.specs.color);
    final sashOption = sashOptions.firstWhere(
      (opt) => opt['value'] == activeWindow.specs.sashType,
      orElse: () => sashOptions.first,
    );
    return List<Map<String, dynamic>>.from(sashOption['types'] ?? []);
  }
}