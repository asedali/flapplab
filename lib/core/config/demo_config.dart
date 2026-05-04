/// Demo Configuration for NooraSense
/// 
/// HIDDEN CONFIG: This value is used for demo scanning simulation.
/// Change this constant to simulate different materials during demo runs.
/// NO UI picker is provided - the app auto-uses this value.

const String kDemoTargetMaterial = 'apple'; // Change to: 'banana', 'chicken', 'salmon', etc.

const Duration kScanAnimationDuration = Duration(seconds: 3);

const Map<String, Map<String, dynamic>> kDemoMaterialsData = {
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
