import 'package:get/get.dart';
import '../models/window_project.dart';
import '../models/window_specs.dart';
import '../utils/calculations.dart';

class WindowController extends GetxController {
  final RxList<WindowProject> _windows = <WindowProject>[
    WindowProject(
      id: '1',
      name: 'نافذة 1',
      specs: WindowSpecs(
        length: 100,
        width: 100,
        color: 'blanc',
        frameType: 'eurosist',
        sashType: '6007',
        sashSubType: 'inoforme',
        glassType: 'simple',
      ),
    ),
  ].obs;

  final RxString _activeWindowId = '1'.obs;
  final RxString _viewMode = 'single'.obs; // single, multiple, combined
  final RxBool _isCalculating = false.obs;

  List<WindowProject> get windows => _windows;
  String get activeWindowId => _activeWindowId.value;
  String get viewMode => _viewMode.value;
  bool get isCalculating => _isCalculating.value;

  WindowProject? get activeWindow => 
      _windows.firstWhereOrNull((w) => w.id == _activeWindowId.value) ?? 
      (_windows.isNotEmpty ? _windows.first : null);

  double get totalCost => 
      _windows.fold(0.0, (sum, w) => sum + (w.breakdown?.totalCost ?? 0));

  int get calculatedWindows => 
      _windows.where((w) => w.breakdown != null).length;

  void setActiveWindow(String id) {
    _activeWindowId.value = id;
  }

  void setViewMode(String mode) {
    _viewMode.value = mode;
  }

  void addWindow() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newWindow = WindowProject(
      id: newId,
      name: 'نافذة ${_windows.length + 1}',
      specs: WindowSpecs(
        length: 100,
        width: 100,
        color: 'blanc',
        frameType: 'eurosist',
        sashType: '6007',
        sashSubType: 'inoforme',
        glassType: 'simple',
      ),
    );
    _windows.add(newWindow);
    _activeWindowId.value = newId;
  }

  void removeWindow(String id) {
    if (_windows.length == 1) return;
    _windows.removeWhere((w) => w.id == id);
    if (_activeWindowId.value == id) {
      _activeWindowId.value = _windows.first.id;
    }
  }

  void duplicateWindow(String id) {
    final windowToDuplicate = _windows.firstWhere((w) => w.id == id);
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newWindow = WindowProject(
      id: newId,
      name: '${windowToDuplicate.name} (نسخة)',
      specs: windowToDuplicate.specs,
    );
    _windows.add(newWindow);
    _activeWindowId.value = newId;
  }

  void updateWindowSpecs(WindowSpecs specs) {
    final index = _windows.indexWhere((w) => w.id == _activeWindowId.value);
    if (index != -1) {
      _windows[index] = _windows[index].copyWith(specs: specs);
    }
  }

  void updateWindowName(String id, String name) {
    final index = _windows.indexWhere((w) => w.id == id);
    if (index != -1) {
      _windows[index] = _windows[index].copyWith(name: name);
    }
  }

  Future<void> calculateSingleWindow() async {
    if (activeWindow == null) return;
    
    _isCalculating.value = true;
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final breakdown = calculateWindowCost(activeWindow!.specs);
    final index = _windows.indexWhere((w) => w.id == _activeWindowId.value);
    if (index != -1) {
      _windows[index] = _windows[index].copyWith(breakdown: breakdown);
    }
    
    _viewMode.value = 'single';
    _isCalculating.value = false;
  }

  Future<void> calculateAllWindows() async {
    _isCalculating.value = true;
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (int i = 0; i < _windows.length; i++) {
      final breakdown = calculateWindowCost(_windows[i].specs);
      _windows[i] = _windows[i].copyWith(breakdown: breakdown);
    }
    
    _viewMode.value = 'combined';
    _isCalculating.value = false;
  }

  void resetWindows() {
    _windows.clear();
    _windows.add(
      WindowProject(
        id: '1',
        name: 'نافذة 1',
        specs: WindowSpecs(
          length: 100,
          width: 100,
          color: 'blanc',
          frameType: 'eurosist',
          sashType: '6007',
          sashSubType: 'inoforme',
          glassType: 'simple',
        ),
      ),
    );
    _activeWindowId.value = '1';
    _viewMode.value = 'single';
  }

  // Color options
  List<Map<String, String>> get colorOptions => [
    {'value': 'blanc', 'label': 'أبيض'},
    {'value': 'fbois', 'label': 'خشبي'},
    {'value': 'gris', 'label': 'رمادي'},
  ];

  // Frame options based on color
  List<Map<String, dynamic>> getFrameOptions(String color) {
    const allFrameOptions = [
      {'value': 'eurosist', 'label': 'Eurosist', 'colors': ['blanc', 'fbois']},
      {'value': 'inoforme', 'label': 'Inoforme', 'colors': ['blanc']},
      {'value': 'eco_loranzo', 'label': 'Eco Loranzo', 'colors': ['blanc']},
      {'value': 'pral', 'label': 'Pral', 'colors': ['fbois']},
      {'value': 'inter', 'label': 'Inter', 'colors': ['fbois']},
      {'value': 'losanzo', 'label': 'Losanzo', 'colors': ['gris']},
    ];
    
    return allFrameOptions.where((option) => 
        (option['colors'] as List).contains(color)).toList();
  }

  // Sash options based on color
  List<Map<String, dynamic>> getSashOptions(String color) {
    const allSashOptions = [
      {
        'value': '6007',
        'label': '6007',
        'types': [
          {'value': 'inoforme', 'label': 'Inoforme', 'colors': ['blanc']},
          {'value': 'gris', 'label': 'Gris', 'colors': ['gris']},
        ]
      },
      {
        'value': '40404',
        'label': '40404',
        'types': [
          {'value': 'eurosist', 'label': 'Eurosist', 'colors': ['blanc']},
          {'value': 'inter', 'label': 'Inter', 'colors': ['blanc']},
          {'value': 'pral', 'label': 'Pral', 'colors': ['fbois']},
          {'value': 'technoline', 'label': 'Technoline', 'colors': ['fbois']},
        ]
      },
    ];

    return allSashOptions.map((sashOption) {
      final types = (sashOption['types'] as List).where((type) =>
          (type['colors'] as List).contains(color)).toList();
      return {
        ...sashOption,
        'types': types,
      };
    }).where((sashOption) => 
        (sashOption['types'] as List).isNotEmpty).toList();
  }
}