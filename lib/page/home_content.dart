import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hero/model/model.dart';
import 'package:flutter_hero/net/net.dart';
import 'package:flutter_hero/page/app_component.dart';
import 'package:flutter_hero/router/app_router.dart';

/// Create by george
/// Date:2019/5/22
/// description:
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selected = 0;
  List<HeroData> _heros = [];
  bool _showChoice = false;

  @override
  void initState() {
    super.initState();
    if (AppComponent.heros == null) {
      final future = getMain();
      future.then((value) {
        AppComponent.heros = value;
        setState(() {
          _heros = value;
        });
      });
    } else {
      _heros = AppComponent.heros;
    }

    if (AppComponent.articles == null) {
      final future = getArticle();
      future.then((value) {
        AppComponent.articles = value;
      });
    }

    if (AppComponent.mings == null) {
      getMings().then((value) {
        AppComponent.mings = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _heros.length == 0 ? loading() : listView();
  }

  Widget loading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('加载中...'),
          ),
        ],
      ),
    );
  }

  Widget listView() {
    final width = (MediaQuery.of(context).size.width - 40) / 4;
    final aspect = width / (width + 20);
    return Column(
      children: <Widget>[
        _buildChoiceView(),
        Expanded(
          child: GridView.builder(
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
              itemCount: _heros.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: aspect),
              itemBuilder: (BuildContext context, int index) {
                return _getItem(width, _heros[index]);
              }),
        )
      ],
    );
  }

  Widget _getItem(double width, HeroData hero) {
    return GestureDetector(
      onTap: () {
        Application.router.navigateTo(
            context,
            Uri.encodeFull(
                '/hero_info?heroIndex=${AppComponent.heros.indexOf(hero)}'),
            transition: TransitionType.native);
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width,
            height: width,
            child: CachedNetworkImage(
              width: width,
              height: width,
              fit: BoxFit.fill,
              imageUrl: 'https:${hero.href}',
              placeholder: (BuildContext context, String url) {
                return Icon(
                  Icons.file_download,
                  color: Colors.orange,
                );
              },
              errorWidget: (BuildContext context, String url, Object error) {
                return Icon(Icons.error_outline);
              },
            ),
          ),
          Text(hero.name)
        ],
      ),
    );
  }

  Widget _buildChoiceView() {
    if (!_showChoice) {
      return SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
            onPressed: () {
              setState(() {
                _showChoice = true;
              });
            },
            child: Text(
              '点击筛选英雄',
              style: TextStyle(color: Colors.orange),
            )),
      );
    }
    return SizedBox(
      height: 140,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                      child: Text(
                        '综合',
                        style: TextStyle(fontSize: 18, color: Colors.orange),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _choiceItem(0, Text('全部')),
                    _choiceItem(10, Text('限免')),
                    _choiceItem(11, Text('新手'))
                  ],
                ),
              ),
              new SizedBox(
                width: 40,
                height: 70,
                child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_up,color: Colors.orange,),
                    onPressed: (){
                      setState(() {
                        _showChoice=false;
                      });
                    }),
              )
            ],
          ),
          SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: Text('定位',style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-60,
                  height: 70,
                  child: ListView(
                    itemExtent: 60,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      _choiceItem(3, Text('坦克')),
                      _choiceItem(1, Text('战士')),
                      _choiceItem(4, Text('刺客')),
                      _choiceItem(2, Text('法师')),
                      _choiceItem(5, Text('射手')),
                      _choiceItem(6, Text('辅助')),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _choiceItem(int value, Text text) {
    return Column(
      children: <Widget>[
        Radio<int>(
          groupValue: _selected,
          value: value,
          onChanged: (value) {
            _selected = value;
            _tidyHeroList();
          },
        ),
        text
      ],
    );
  }

  void _tidyHeroList() {
    if (_selected == 0) {
      setState(() {
        _heros = AppComponent.heros;
      });
      return;
    }
    List<HeroData> result = [];
    for (final item in AppComponent.heros) {
      if (_selected >= 10) {
        if (item.payType == _selected) {
          result.add(item);
        }
      } else {
        if (item.heroType == _selected || item.heroType2 == _selected) {
          result.add(item);
        }
      }
    }
    setState(() {
      _heros = result;
    });
  }
}
