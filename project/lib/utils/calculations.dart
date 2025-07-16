import '../data/materials_data.dart';
import '../models/window_specs.dart';
import '../models/cost_item.dart';
import '../models/cost_breakdown.dart';

const double barLength = 650.0; // cm
const double glassPricePerM2 = 31.25; // TND per m²

double findMaterial(String ref, [double fallbackPrice = 0]) {
  final material = materialsData.firstWhere(
    (m) => m.ref == ref,
    orElse: () => Material(ref: ref, designation: '', prixUMoyen: fallbackPrice),
  );
  return material.prixUMoyen;
}

String getFrameMaterialRef(String frameType, String color) {
  const frameOptions = {
    'blanc_eurosist': '3',
    'blanc_inoforme': '7',
    'blanc_eco_loranzo': '216',
    'fbois_eurosist': '3',
    'fbois_pral': '9',
    'fbois_inter': '97',
    'gris_losanzo': '208'
  };
  
  final key = '${color}_$frameType';
  return frameOptions[key] ?? '3';
}

String getSashMaterialRef(String sashType, String sashSubType, String color) {
  const sashOptions = {
    '6007_inoforme_blanc': '12',
    '6007_inoforme_blanc_alt': '112',
    '6007_gris_gris': '313',
    '40404_eurosist_blanc': '94',
    '40404_inter_blanc': '4',
    '40404_pral_fbois': '11',
    '40404_technoline_fbois': '156'
  };
  
  final key = '${sashType}_${sashSubType}_$color';
  return sashOptions[key] ?? '12';
}

String get40112MaterialRef(String color) {
  const options40112 = {
    'blanc': '289',
    'fbois': '96',
    'gris': '289',
    'economique': '1250'
  };
  
  return options40112[color] ?? '289';
}

String getHardwareColor(String windowColor) {
  return (windowColor == 'fbois' || windowColor == 'gris') ? 'noir' : 'blanc';
}

Map<String, String> getHardwareRefs(String color) {
  if (color == 'noir') {
    return {
      'paumelle': '36',
      'cremone': '63',
      'poigne': '55'
    };
  } else {
    return {
      'paumelle': '35',
      'cremone': '62',
      'poigne': '54'
    };
  }
}

Map<String, dynamic> calculateExactBarUsage(double totalLength, [double barLen = barLength]) {
  final exactBarsNeeded = totalLength / barLen;
  final actualBarsNeeded = exactBarsNeeded.ceil();
  const efficiency = 100.0;
  const waste = 0.0;
  
  return {
    'barsNeeded': exactBarsNeeded,
    'actualBarsNeeded': actualBarsNeeded,
    'efficiency': efficiency,
    'waste': waste,
  };
}

CostBreakdown calculateWindowCost(WindowSpecs specs) {
  final length = specs.length;
  final width = specs.width;
  final color = specs.color;
  final frameType = specs.frameType;
  final sashType = specs.sashType;
  final sashSubType = specs.sashSubType;

  // تحديد لون الملحقات
  final hardwareColor = getHardwareColor(color);
  final hardwareRefs = getHardwareRefs(hardwareColor);

  // حسابات القفص
  final framePerimeter = 2 * (length + width);
  final frameOptimization = calculateExactBarUsage(framePerimeter);
  final frameMaterialRef = getFrameMaterialRef(frameType, color);
  final frameUnitPrice = findMaterial(frameMaterialRef, 74);

  // حسابات الفردة
  final sashLength = length - 4;
  final sashWidth = (width - 4.7) / 2;
  final sashPerimeter = 2 * (sashLength + sashWidth);
  final totalSashLength = sashPerimeter * 2;
  final sashOptimization = calculateExactBarUsage(totalSashLength);
  final sashMaterialRef = getSashMaterialRef(sashType, sashSubType, color);
  final sashUnitPrice = findMaterial(sashMaterialRef, 57.67);

  // حسابات الزجاج
  final glassLengthPerSash = sashLength - 1;
  final glassWidthPerSash = sashWidth - 1;
  final glassAreaPerSash = (glassLengthPerSash * glassWidthPerSash) / 10000;
  final totalGlassArea = glassAreaPerSash * 2;

  // حسابات الفاصل
  final separatorLength = sashLength;
  final separatorOptimization = calculateExactBarUsage(separatorLength);
  final separator40112Ref = get40112MaterialRef(color);
  final separator40112Price = findMaterial(separator40112Ref, 49.3);

  // حسابات الملحقات
  final equerrePrice = findMaterial('43', 1.2);
  final equerrePMPrice = findMaterial('239', 4.5) / 100;
  final equerreGMPrice = findMaterial('91', 5.5) / 100;
  final paumellePrice = findMaterial(hardwareRefs['paumelle']!, 3.33);
  final jointBattementPrice = findMaterial('90', 16) / 50;
  final jointPlatPrice = findMaterial('89', 22.63) / 50;
  final cremonePrice = findMaterial(hardwareRefs['cremone']!, 9.63);
  final kitCremonePrice = findMaterial('31', 2.7);
  final kitVerrouxPrice = findMaterial('32', 2.76);
  final tringPrice = findMaterial('61', 1.7);

  final jointBattementLength = (framePerimeter + totalSashLength) / 100;
  final jointPlatLength = (totalSashLength * 2) / 100;

  // تحديد اسم اللون
  final colorName = color == 'blanc' ? 'أبيض' : color == 'fbois' ? 'خشبي' : 'رمادي';
  final hardwareColorName = hardwareColor == 'blanc' ? 'أبيض' : 'أسود';

  final frame = [
    CostItem(
      name: '40100 $colorName $frameType',
      quantity: '${frameOptimization['barsNeeded'].toStringAsFixed(1)} بارة (${framePerimeter.toStringAsFixed(0)} سم)',
      unitPrice: frameUnitPrice,
      totalCost: frameOptimization['actualBarsNeeded'] * frameUnitPrice,
      specifications: 'الاستهلاك: ${framePerimeter.toStringAsFixed(0)} سم - السعر: ${frameOptimization['actualBarsNeeded']} بارة × ${frameUnitPrice.toStringAsFixed(2)} د.ت',
    ),
    CostItem(
      name: 'زوايا القفص (équerre en tole)',
      quantity: '4 قطع',
      unitPrice: equerrePrice,
      totalCost: 4 * equerrePrice,
    ),
    CostItem(
      name: 'زوايا المحاذاة PM',
      quantity: '4 قطع',
      unitPrice: equerrePMPrice,
      totalCost: 4 * equerrePMPrice,
    ),
  ];

  final sashes = [
    CostItem(
      name: '$sashType $sashSubType $colorName (فردتان)',
      quantity: '${sashOptimization['barsNeeded'].toStringAsFixed(1)} بارة (${totalSashLength.toStringAsFixed(1)} سم)',
      unitPrice: sashUnitPrice,
      totalCost: sashOptimization['actualBarsNeeded'] * sashUnitPrice,
      specifications: 'الاستهلاك: ${totalSashLength.toStringAsFixed(1)} سم - السعر: ${sashOptimization['actualBarsNeeded']} بارة × ${sashUnitPrice.toStringAsFixed(2)} د.ت',
    ),
    CostItem(
      name: 'زوايا الفردات (équerre en tole)',
      quantity: '8 قطع',
      unitPrice: equerrePrice,
      totalCost: 8 * equerrePrice,
    ),
    CostItem(
      name: 'زوايا المحاذاة GM',
      quantity: '8 قطع',
      unitPrice: equerreGMPrice,
      totalCost: 8 * equerreGMPrice,
    ),
  ];

  final separator = [
    CostItem(
      name: '40112 فاصل بين الفردتين $colorName',
      quantity: '${separatorOptimization['barsNeeded'].toStringAsFixed(1)} بارة (${separatorLength.toStringAsFixed(0)} سم)',
      unitPrice: separator40112Price,
      totalCost: separatorOptimization['actualBarsNeeded'] * separator40112Price,
      specifications: 'الاستهلاك: ${separatorLength.toStringAsFixed(0)} سم - السعر: ${separatorOptimization['actualBarsNeeded']} بارة × ${separator40112Price.toStringAsFixed(2)} د.ت',
    ),
  ];

  final glass = [
    CostItem(
      name: 'زجاج 4مم',
      quantity: '${totalGlassArea.toStringAsFixed(2)} م²',
      unitPrice: glassPricePerM2,
      totalCost: totalGlassArea * glassPricePerM2,
      specifications: 'فردتان ${glassLengthPerSash.toStringAsFixed(1)}×${glassWidthPerSash.toStringAsFixed(1)} سم',
    ),
    CostItem(
      name: 'مشط تثبيت الزجاج (joint plat)',
      quantity: '${jointPlatLength.toStringAsFixed(1)} م',
      unitPrice: jointPlatPrice,
      totalCost: jointPlatLength * jointPlatPrice,
      specifications: 'للجهتين',
    ),
  ];

  final hardware = [
    CostItem(
      name: 'مفصلات (paumelle king $hardwareColorName)',
      quantity: '4 قطع',
      unitPrice: paumellePrice,
      totalCost: 4 * paumellePrice,
      specifications: 'لون $hardwareColorName للنوافذ ${colorName == 'أبيض' ? 'البيضاء' : colorName == 'خشبي' ? 'الخشبية' : 'الرمادية'}',
    ),
    CostItem(
      name: 'مشط الحواف (joint battement)',
      quantity: '${jointBattementLength.toStringAsFixed(1)} م',
      unitPrice: jointBattementPrice,
      totalCost: jointBattementLength * jointBattementPrice,
    ),
    CostItem(
      name: 'كريمون (cremone KNG $hardwareColorName)',
      quantity: '1',
      unitPrice: cremonePrice,
      totalCost: cremonePrice,
      specifications: 'لون $hardwareColorName للنوافذ ${colorName == 'أبيض' ? 'البيضاء' : colorName == 'خشبي' ? 'الخشبية' : 'الرمادية'}',
    ),
    CostItem(
      name: 'كيت كريمون',
      quantity: '1',
      unitPrice: kitCremonePrice,
      totalCost: kitCremonePrice,
    ),
    CostItem(
      name: 'كيت القفل',
      quantity: '1',
      unitPrice: kitVerrouxPrice,
      totalCost: kitVerrouxPrice,
    ),
    CostItem(
      name: 'قضيب (tringle)',
      quantity: '${(length / 100).toStringAsFixed(2)} م',
      unitPrice: tringPrice,
      totalCost: (length / 100) * tringPrice,
    ),
  ];

  final allItems = [...frame, ...sashes, ...separator, ...glass, ...hardware];
  final totalCost = allItems.fold(0.0, (sum, item) => sum + item.totalCost);

  return CostBreakdown(
    frame: frame,
    sashes: sashes,
    separator: separator,
    glass: glass,
    hardware: hardware,
    totalCost: totalCost,
  );
}