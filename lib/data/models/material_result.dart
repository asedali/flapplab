import 'package:flutter/foundation.dart';

/// Represents a scanned material result with AI analysis
@immutable
class MaterialResult {
  final String id;
  final String name;
  final double confidence;
  final Map<String, double> parameters;
  final String aiInsight;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime scannedAt;
  final bool syncedToHealthApps;

  const MaterialResult({
    required this.id,
    required this.name,
    required this.confidence,
    required this.parameters,
    required this.aiInsight,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.scannedAt,
    this.syncedToHealthApps = false,
  });

  MaterialResult copyWith({
    String? id,
    String? name,
    double? confidence,
    Map<String, double>? parameters,
    String? aiInsight,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    DateTime? scannedAt,
    bool? syncedToHealthApps,
  }) {
    return MaterialResult(
      id: id ?? this.id,
      name: name ?? this.name,
      confidence: confidence ?? this.confidence,
      parameters: parameters ?? this.parameters,
      aiInsight: aiInsight ?? this.aiInsight,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      scannedAt: scannedAt ?? this.scannedAt,
      syncedToHealthApps: syncedToHealthApps ?? this.syncedToHealthApps,
    );
  }

  /// Create from demo config data
  factory MaterialResult.fromDemoData(String materialKey) {
    final data = _demoMaterialsData[materialKey] ?? _demoMaterialsData['apple']!;
    return MaterialResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: data['name'] as String,
      confidence: data['confidence'] as double,
      parameters: Map<String, double>.from(data['parameters'] as Map),
      aiInsight: data['ai_insight'] as String,
      calories: data['calories'] as int,
      protein: data['protein'] as double,
      carbs: data['carbs'] as double,
      fat: data['fat'] as double,
      scannedAt: DateTime.now(),
    );
  }

  static const Map<String, Map<String, dynamic>> _demoMaterialsData = {
    'apple': {
      'name': 'Organic Red Apple',
      'confidence': 0.96,
      'parameters': {
        'freshness': 0.92,
        'ripeness': 0.85,
        'sugar_content': 0.78,
        'acidity': 0.65,
      },
      'ai_insight': 'This apple shows excellent freshness indicators with optimal ripeness for immediate consumption. Sugar content suggests peak sweetness.',
      'calories': 95,
      'protein': 0.5,
      'carbs': 25.0,
      'fat': 0.3,
    },
    'banana': {
      'name': 'Premium Banana',
      'confidence': 0.94,
      'parameters': {
        'freshness': 0.88,
        'ripeness': 0.91,
        'sugar_content': 0.82,
        'potassium': 0.95,
      },
      'ai_insight': 'Banana at perfect ripeness stage. High potassium content detected. Ideal for post-workout nutrition.',
      'calories': 105,
      'protein': 1.3,
      'carbs': 27.0,
      'fat': 0.4,
    },
    'chicken': {
      'name': 'Fresh Chicken Breast',
      'confidence': 0.93,
      'parameters': {
        'freshness': 0.89,
        'protein_quality': 0.97,
        'moisture': 0.72,
        'bacteria_level': 0.05,
      },
      'ai_insight': 'High-quality protein source with excellent freshness markers. Safe for consumption with proper cooking.',
      'calories': 165,
      'protein': 31.0,
      'carbs': 0.0,
      'fat': 3.6,
    },
    'salmon': {
      'name': 'Atlantic Salmon Fillet',
      'confidence': 0.95,
      'parameters': {
        'freshness': 0.94,
        'omega3_content': 0.91,
        'color_quality': 0.88,
        'texture_score': 0.86,
      },
      'ai_insight': 'Premium salmon with high omega-3 fatty acids. Excellent color indicates fresh catch. Recommended for heart-healthy diet.',
      'calories': 208,
      'protein': 20.0,
      'carbs': 0.0,
      'fat': 13.0,
    },
  };
}
