import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/window_provider.dart';

class WindowListPanel extends StatelessWidget {
  const WindowListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WindowProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: provider.addWindow,
                    icon: Icon(
                      Icons.add,
                      color: Colors.blue.shade600,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Windows List
              Expanded(
                child: ListView.builder(
                  itemCount: provider.windows.length,
                  itemBuilder: (context, index) {
                    final window = provider.windows[index];
                    final isActive = window.id == provider.activeWindowId;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.blue.shade50 : Colors.grey.shade50,
                        border: Border.all(
                          color: isActive ? Colors.blue.shade300 : Colors.grey.shade200,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () => provider.setActiveWindow(window.id),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        title: TextFormField(
                          initialValue: window.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) => provider.updateWindowName(window.id, value),
                          onTap: () => provider.setActiveWindow(window.id),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              '${window.specs.length.toStringAsFixed(0)}×${window.specs.width.toStringAsFixed(0)} سم',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (window.breakdown != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${window.breakdown!.totalCost.toStringAsFixed(2)} د.ت',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => provider.duplicateWindow(window.id),
                              icon: const Icon(Icons.copy, size: 16),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                minimumSize: const Size(32, 32),
                              ),
                            ),
                            if (provider.windows.length > 1) ...[
                              const SizedBox(width: 4),
                              IconButton(
                                onPressed: () => provider.removeWindow(window.id),
                                icon: const Icon(Icons.close, size: 16),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.red.shade50,
                                  foregroundColor: Colors.red.shade600,
                                  minimumSize: const Size(32, 32),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isCalculating ? null : provider.calculateAllWindows,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: provider.isCalculating
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('جاري الحساب...', style: TextStyle(fontSize: 12)),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_cart, size: 16),
                                const SizedBox(width: 8),
                                const Text('احسب السلع المجمعة', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: provider.calculatedWindows == 0 ? null : () {
                            // Export functionality
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.download, size: 14),
                              const SizedBox(width: 4),
                              const Text('تصدير', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: provider.resetWindows,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh, size: 14),
                              const SizedBox(width: 4),
                              const Text('إعادة تعيين', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}