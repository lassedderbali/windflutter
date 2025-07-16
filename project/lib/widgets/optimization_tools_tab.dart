import 'package:flutter/material.dart';

class OptimizationToolsTab extends StatefulWidget {
  const OptimizationToolsTab({super.key});

  @override
  State<OptimizationToolsTab> createState() => _OptimizationToolsTabState();
}

class _OptimizationToolsTabState extends State<OptimizationToolsTab> {
  List<Map<String, dynamic>> windows = [
    {'id': '1', 'length': 100.0, 'width': 100.0, 'quantity': 1},
    {'id': '2', 'length': 120.0, 'width': 110.0, 'quantity': 1},
  ];

  Map<String, dynamic>? optimization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade600, Colors.orange.shade700],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade200,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'أدوات تحسين القص',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'احسب الكمية المثلى للمواد وقلل الهدر عند تصنيع عدة نوافذ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.orange.shade100,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Row(
              children: [
                // Input Section
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
                        // Header
                        Row(
                          children: [
                            Icon(
                              Icons.list,
                              color: Colors.blue.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'قائمة النوافذ',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: _addWindow,
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Windows List
                        Expanded(
                          child: ListView.builder(
                            itemCount: windows.length,
                            itemBuilder: (context, index) {
                              final window = windows[index];
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
                                      children: [
                                        Text(
                                          'نافذة ${index + 1}',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (windows.length > 1)
                                          IconButton(
                                            onPressed: () => _removeWindow(index),
                                            icon: const Icon(Icons.delete, size: 16),
                                            style: IconButton.styleFrom(
                                              foregroundColor: Colors.red.shade600,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'الطول (سم)',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              TextFormField(
                                                initialValue: window['length'].toString(),
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                ),
                                                onChanged: (value) => _updateWindow(index, 'length', double.tryParse(value) ?? 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'العرض (سم)',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              TextFormField(
                                                initialValue: window['width'].toString(),
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                ),
                                                onChanged: (value) => _updateWindow(index, 'width', double.tryParse(value) ?? 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'الكمية',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              TextFormField(
                                                initialValue: window['quantity'].toString(),
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                ),
                                                onChanged: (value) => _updateWindow(index, 'quantity', int.tryParse(value) ?? 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Calculate Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _calculateOptimization,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calculate),
                                const SizedBox(width: 8),
                                const Text('احسب التحسين'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Results Section
                Expanded(
                  child: optimization != null
                      ? _buildResultsSection()
                      : _buildEmptyResultsSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      children: [
        // Frame Results
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
                Row(
                  children: [
                    Icon(
                      Icons.content_cut,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'نتائج القوافص (40100)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildResultCard(
                        context,
                        'عدد البارات',
                        optimization!['frame']['barsNeeded'].toString(),
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildResultCard(
                        context,
                        'الكفاءة',
                        '${optimization!['frame']['efficiency'].toStringAsFixed(1)}%',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildDetailRow('الطول المطلوب:', '${optimization!['frame']['totalLength']} سم'),
                _buildDetailRow('الطول المتوفر:', '${optimization!['frame']['barsNeeded'] * 650} سم'),
                _buildDetailRow('الهدر:', '${optimization!['frame']['waste']} سم', isError: true),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Sash Results
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
                Row(
                  children: [
                    Icon(
                      Icons.content_cut,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'نتائج الفردات (6007)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildResultCard(
                        context,
                        'عدد البارات',
                        optimization!['sash']['barsNeeded'].toString(),
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildResultCard(
                        context,
                        'الكفاءة',
                        '${optimization!['sash']['efficiency'].toStringAsFixed(1)}%',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildDetailRow('الطول المطلوب:', '${optimization!['sash']['totalLength'].toStringAsFixed(1)} سم'),
                _buildDetailRow('الطول المتوفر:', '${optimization!['sash']['barsNeeded'] * 650} سم'),
                _buildDetailRow('الهدر:', '${optimization!['sash']['waste'].toStringAsFixed(1)} سم', isError: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyResultsSection() {
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
            Icons.content_cut,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'احسب التحسين',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أدخل قائمة النوافذ المطلوبة واضغط "احسب التحسين" لمعرفة الكمية المثلى للمواد',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isError ? Colors.red.shade600 : null,
            ),
          ),
        ],
      ),
    );
  }

  void _addWindow() {
    setState(() {
      windows.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'length': 100.0,
        'width': 100.0,
        'quantity': 1,
      });
    });
  }

  void _removeWindow(int index) {
    if (windows.length > 1) {
      setState(() {
        windows.removeAt(index);
      });
    }
  }

  void _updateWindow(int index, String field, dynamic value) {
    setState(() {
      windows[index][field] = value;
    });
  }

  void _calculateOptimization() {
    const barLength = 650.0;
    double totalFrameLength = 0;
    double totalSashLength = 0;

    for (final window in windows) {
      final framePerimeter = 2 * (window['length'] + window['width']);
      final sashLength = window['length'] - 4;
      final sashWidth = (window['width'] - 4.7) / 2;
      final sashPerimeter = 2 * (sashLength + sashWidth) * 2;

      totalFrameLength += framePerimeter * window['quantity'];
      totalSashLength += sashPerimeter * window['quantity'];
    }

    final frameBarsNeeded = (totalFrameLength / barLength).ceil();
    final sashBarsNeeded = (totalSashLength / barLength).ceil();
    
    final frameWaste = (frameBarsNeeded * barLength) - totalFrameLength;
    final sashWaste = (sashBarsNeeded * barLength) - totalSashLength;

    setState(() {
      optimization = {
        'frame': {
          'totalLength': totalFrameLength,
          'barsNeeded': frameBarsNeeded,
          'waste': frameWaste,
          'efficiency': (totalFrameLength / (frameBarsNeeded * barLength)) * 100,
        },
        'sash': {
          'totalLength': totalSashLength,
          'barsNeeded': sashBarsNeeded,
          'waste': sashWaste,
          'efficiency': (totalSashLength / (sashBarsNeeded * barLength)) * 100,
        },
      };
    });
  }
}