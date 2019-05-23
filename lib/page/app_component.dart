import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hero/model/model.dart';
import 'package:flutter_hero/router/app_router.dart';

/// Create by george
/// Date:2019/5/22
/// description:
class AppComponent extends StatefulWidget {
  static List<ArticleData> articles;
  static List<HeroData> heros;
  static List<CommonSkill> commonSkills;
  static List<MingData> mings;

  @override
  _AppComponentState createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> {
  _AppComponentState() {
    Application.buildRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '王者荣耀',
      theme: ThemeData(primarySwatch: Colors.orange),
      onGenerateRoute: Application.router.generator,
    );
  }
}
