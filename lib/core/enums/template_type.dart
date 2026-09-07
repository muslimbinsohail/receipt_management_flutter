import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';

part 'template_type.g.dart';

@HiveType(typeId: HiveConstants.templateTypeId)
enum TemplateType {
  @HiveField(0)
  modernMinimal,

  @HiveField(1)
  classicFormal,

  @HiveField(2)
  boldColorful,

  @HiveField(3)
  darkPremium,

  @HiveField(4)
  vintage,
}

extension TemplateTypeExtension on TemplateType {
  String get label {
    switch (this) {
      case TemplateType.modernMinimal:
        return 'Modern Minimal';
      case TemplateType.classicFormal:
        return 'Classic Formal';
      case TemplateType.boldColorful:
        return 'Bold Colorful';
      case TemplateType.darkPremium:
        return 'Dark Premium';
      case TemplateType.vintage:
        return 'Vintage';
    }
  }

  String get description {
    switch (this) {
      case TemplateType.modernMinimal:
        return 'Clean and minimalist with lots of whitespace';
      case TemplateType.classicFormal:
        return 'Traditional professional look with borders';
      case TemplateType.boldColorful:
        return 'Vibrant and modern with colorful accents';
      case TemplateType.darkPremium:
        return 'Dark theme with gold accents for a luxury feel';
      case TemplateType.vintage:
        return 'Retro style with decorative elements';
    }
  }
}
