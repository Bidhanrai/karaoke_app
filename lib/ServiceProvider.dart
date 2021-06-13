import 'package:get_it/get_it.dart';
import 'package:karaoke_app/Service/AudioPlayerService.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerFactory(() => AudioPlayerService());
}