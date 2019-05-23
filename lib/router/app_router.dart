import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hero/page/app_component.dart';
import 'package:flutter_hero/page/app_home.dart';
import 'package:flutter_hero/page/hero_info.dart';
import 'package:flutter_hero/page/hero_video.dart';

/// Create by george
/// Date:2019/5/22
/// description:路由
class Application {
  static Router router;

  static buildRouter() {
    router = Router();
    router.define('/', handler: Handler(handlerFunc:
        (BuildContext context, Map<String, List<String>> parameters) {
      return AppHome();
    }));
    router.define('/hero_info', handler: Handler(handlerFunc:
        (BuildContext context, Map<String, List<String>> parameters) {
      int index = int.parse(parameters['heroIndex'].first);
      return HeroInfo(
        hero: AppComponent.heros[index],
      );
    }));
    router.define('/hero_info/hero_video', handler: Handler(handlerFunc:
        (BuildContext context, Map<String, List<String>> parameters) {
      int index = int.parse(parameters['heroIndex'].first);
      return HeroVideo(
        hero: AppComponent.heros[index],
      );
    }));
  }
}
