import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hero/page/article_content.dart';
import 'package:flutter_hero/page/common_content.dart';
import 'package:flutter_hero/page/home_content.dart';
import 'package:flutter_hero/page/ming_content.dart';

/// Create by george
/// Date:2019/5/22
/// description:
class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _currentTabbarIndex = 0;

  Widget _getCurrentContent() {
    Widget result;
    switch (_currentTabbarIndex) {
      case 0:
        result = HomeContent();
        break;
      case 1:
        result = ArticleContent();
        break;
      case 2:
        result = CommonContent();
        break;
      case 3:
        result = MingContent();
        break;
    }
    return result;
  }

  String _getCurrentTitle() {
    String result;
    switch (_currentTabbarIndex) {
      case 0:
        result = "英雄列表";
        break;
      case 1:
        result = "物品列表";
        break;
      case 2:
        result = "召唤师技能";
        break;
      case 3:
        result = '铭文列表';
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getCurrentTitle(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _getCurrentContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('英雄')),
          BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text('物品')),
          BottomNavigationBarItem(icon: Icon(Icons.insert_emoticon), title: Text('技能')),
          BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('铭文')),
        ],
        currentIndex: _currentTabbarIndex,
        onTap: (int index) {
          setState(() {
            _currentTabbarIndex = index;
          });
        },
      ),
    );
  }
}
