import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hero/custom_widget/loading_dialog.dart';
import 'package:flutter_hero/model/model.dart';
import 'package:flutter_hero/net/net.dart';
import 'package:flutter_hero/page/app_component.dart';

/// Create by george
/// Date:2019/5/22
/// description:
class MingContent extends StatefulWidget {
  @override
  _MingContentState createState() => _MingContentState();
}

class _MingContentState extends State<MingContent> {
  List<MingData> _mingList = [];
  int _colorSelected = 0;
  int _levelSelected = 6;
  bool _showChoice = false;

  @override
  void initState() {
    super.initState();
    if (AppComponent.mings != null) {
      _mingList = AppComponent.mings;
      return;
    }
    final future = getMings();
    future.then((value) {
      setState(() {
        _mingList = value;
        AppComponent.mings = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('history-build-width');
    return _mingList.length==0?loading():listView();
  }

  Widget loading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: const Text('加载中...'),
          ),
        ],
      ),
    );
  }

  Widget listView() {
    final width = (MediaQuery.of(context).size.width-60)/5;
    final aspect = width/(width+20);
    print('history-list-width:$width');

    return Column(
      children: <Widget>[
        _buildChoiceView(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            itemCount: _mingList.length,
            itemBuilder: (BuildContext context, int index) {
              return _getItem(width, index, _mingList[index]);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: aspect
            ),
          ),
        )
      ],
    );
  }

  Widget _buildChoiceView() {
    if (!_showChoice) {
      return SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          child: const Text('点击筛选符文', style: TextStyle(color: Colors.orange),),
          onPressed: () {
            setState(() {
              _showChoice = true;
            });
          },
        ),
      );
    }
    return SizedBox(
      height: 140,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width-40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                      child: const Text('综合', style: TextStyle(fontSize: 18, color: Colors.orange), textAlign: TextAlign.center,),
                    ),
                    _choiceItem(0, Text('全部'), 0),
                    _choiceItem(10, const Text('红色'), 0),
                    _choiceItem(11, const Text('黄色'), 0),
                    _choiceItem(12, const Text('蓝色'), 0),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                height: 70,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up, color: Colors.orange,),
                  onPressed: () {
                    setState(() {
                      _showChoice = false;
                    });
                  },
                ),
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
                  child: const Text('等级', style: TextStyle(fontSize: 18, color: Colors.orange), textAlign: TextAlign.center,),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-60,
                  height: 70,
                  child: ListView(
                    itemExtent: 60,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      _choiceItem(6, const Text('全部'), 1),
                      _choiceItem(5, const Text('五级'), 1),
                      _choiceItem(4, const Text('四级'), 1),
                      _choiceItem(3, const Text('三级'), 1),
                      _choiceItem(2, const Text('二级'), 1),
                      _choiceItem(1, const Text('一级'), 1),
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

  //type 0->color 1->level
  Widget _choiceItem(int value, Text text, int type) {
    return Column(
      children: <Widget>[
        Radio<int>(
          groupValue: type==0?_colorSelected:_levelSelected,
          value: value,
          onChanged: (value) {
            if (type==0) {
              _colorSelected = value;
            } else {
              _levelSelected = value;
            }
            _tidyMingList();
          },
        ),
        text
      ],
    );
  }

  Widget _getItem(double width, int index, MingData ming) {
    print('history-item-index:$index url:https:${ming.href}');
    return GestureDetector(
      onTap: () {
        showDetail(_mingList[index]);
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width,
            height: width,
            child: Center(
              child: CachedNetworkImage(
                width: width*0.85,
                height: width,
                fit: BoxFit.fill,
                imageUrl: 'https:${ming.href}',
                placeholder: (BuildContext context, String url) {
                  return const Icon(Icons.file_download, color: Colors.orange,);
                },
                errorWidget: (BuildContext context, String url, Object error) {
                  return const Icon(Icons.error_outline);
                },
              ),
            ),
          ),
          Text('${ming.name}(${_changeIntToHan(ming.grade)}级)',style: TextStyle(fontSize: 13),),
        ],
      ),
    );
  }

  void _tidyMingList() {
    if (_colorSelected==0&&_levelSelected==6) {
      setState(() {
        _mingList = AppComponent.mings;
      });
      return;
    }

    List<MingData> list = [];
    for (MingData item in AppComponent.mings) {
      if (_colorSelected==10&&item.type!='red') {
        continue;
      }
      if (_colorSelected==11&&item.type!='yellow') {
        continue;
      }
      if (_colorSelected==12&&item.type!='blue') {
        continue;
      }
      if (_levelSelected==5&&item.grade!='5') {
        continue;
      }
      if (_levelSelected==4&&item.grade!='4') {
        continue;
      }

      if (_levelSelected==3&&item.grade!='3') {
        continue;
      }

      if (_levelSelected==2&&item.grade!='2') {
        continue;
      }

      if (_levelSelected==1&&item.grade!='1') {
        continue;
      }
      list.add(item);
    }
    setState(() {
      _mingList = list;
    });
  }
  void showDetail(MingData ming) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MingDialog(
            ming: ming,
          );
        });
  }

  String _changeIntToHan(String value) {
    String result = '';
    switch (value) {
      case '1':
        result = "一";
        break;
      case '2':
        result = "二";
        break;
      case '3':
        result = '三';
        break;
      case '4':
        result = '四';
        break;
      case '5':
        result = '五';
        break;
    }
    return result;
  }
}
