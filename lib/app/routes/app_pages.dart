import 'package:get/get.dart';
import '../modules/game/views/game_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [GetPage(name: AppRoutes.game, page: () => GameView())];
}
