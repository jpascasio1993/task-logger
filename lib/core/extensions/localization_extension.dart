import 'package:flutter/material.dart';
import 'package:task_logger/l10n/l10n.dart';

extension LocalizationExtension on BuildContext {
  AppLocalization get localization => AppLocalization.of(this);
}
