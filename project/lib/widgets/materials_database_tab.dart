import 'package:flutter/material.dart';
import '../data/materials_data.dart';

class MaterialsDatabaseTab extends StatefulWidget {
  const MaterialsDatabaseTab({super.key});

  @override
  State<MaterialsDatabaseTab> createState() => _MaterialsDatabaseTabState();
}

class _MaterialsDatabaseTabState extends State<MaterialsDatabaseTab> {
  String searchTerm = '';
  String filterCategory = 'all';
  List<Material> materials = List.from(materialsData);
  bool showAddForm = false;

  final categories = [
    {'value': 'all', 'label': 'جميع المواد'},
    {'value': 'profiles', 'label': 'البروفايل'},
    {'value': 'hardware', 'label': 'الملحقات'},
    {'value': 'glass', 'label': 'الزجاج'},
    {'value': 'joints', 'label': 'المواد اللاصقة'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMaterials = materials.where((material) {
      final matchesSearch = material.designation.toLowerCase().contains(searchTerm.toLowerCase()) ||
                           material.ref.toLowerCase().contains(searchTerm.toLowerCase());
      
      final matchesCategory = filterCategory == 'all' || _getCategoryForRef(material.ref) == filterCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade700],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade200,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'قاعدة بيانات المواد',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'إدارة أسعار وبيانات المواد المستخدمة في تصنيع النوافذ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.green.shade100,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Controls
          Container(
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
            child: Row(
              children: [
                // Search
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن المواد...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => setState(() => searchTerm = value),
                  ),
                ),
                const SizedBox(width: 16),

                // Filter
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: filterCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: categories.map((category) => DropdownMenuItem(
                      value: category['value'],
                      child: Text(category['label']!),
                    )).toList(),
                    onChanged: (value) => setState(() => filterCategory = value!),
                  ),
                ),
                const SizedBox(width: 16),

                // Add Button
                ElevatedButton.icon(
                  onPressed: () => setState(() => showAddForm = true),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة مادة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Materials Table
          Expanded(
            child: Container(
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
                  // Table Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'المرجع',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'اسم المادة',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'السعر الوسطي (د.ت)',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'الفئة',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    child: filteredMaterials.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory,
                                  size: 48,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد مواد تطابق البحث',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredMaterials.length,
                            itemBuilder: (context, index) {
                              final material = filteredMaterials[index];
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.inventory,
                                            size: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            material.ref,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        material.designation,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        material.prixUMoyen.toStringAsFixed(2),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(_getCategoryForRef(material.ref)),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _getCategoryLabel(_getCategoryForRef(material.ref)),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'إجمالي المواد',
                  materials.length.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'البروفايل',
                  materials.where((m) => _getCategoryForRef(m.ref) == 'profiles').length.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'الملحقات',
                  materials.where((m) => _getCategoryForRef(m.ref) == 'hardware').length.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'متوسط السعر',
                  (materials.fold(0.0, (sum, m) => sum + m.prixUMoyen) / materials.length).toStringAsFixed(2),
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCategoryForRef(String ref) {
    if (ref.startsWith('40') || ref.startsWith('22') || ref.startsWith('60')) return 'profiles';
    if (ref.contains('joint') || ref.contains('plat')) return 'joints';
    if (ref.contains('glass') || ref.contains('زجاج')) return 'glass';
    return 'hardware';
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'profiles': return 'البروفايل';
      case 'hardware': return 'الملحقات';
      case 'joints': return 'المواد اللاصقة';
      case 'glass': return 'الزجاج';
      default: return 'أخرى';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'profiles': return Colors.blue.shade600;
      case 'hardware': return Colors.green.shade600;
      case 'joints': return Colors.yellow.shade600;
      case 'glass': return Colors.purple.shade600;
      default: return Colors.grey.shade600;
    }
  }
}