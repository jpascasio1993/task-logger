import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  preferRelativeImports: false,
)
GetIt initInjection(GetIt getIt) => getIt.init();
