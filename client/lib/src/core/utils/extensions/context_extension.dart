import 'package:auther_client/src/core/localization/app_localization.dart';
import 'package:flutter/widgets.dart';

extension LocalizationX on BuildContext {
  Localization stringOf() => Localization.of(this);
}
