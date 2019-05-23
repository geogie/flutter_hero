import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hero/model/model.dart';

/// Create by george
/// Date:2019/5/23
/// description:
///透明dialog
class ArticleDialog extends Dialog {
  final ArticleData article;

  ArticleDialog({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = Duration(microseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;

    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)));
    var desc1 = article.desc1
        .replaceAllMapped(RegExp(r'<p>|</p>'), (Match match) => '');
    desc1 = desc1.replaceAllMapped(RegExp('<br>'), (Match match) => '\n');
    final desc2 = article.desc2
        .replaceAllMapped(RegExp(r'<p>|</p>'), (Match match) => '');

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          EdgeInsets.symmetric(horizontal: 80, vertical: 24),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: Center(
            child: Material(
              elevation: 24,
              color: Colors.black.withOpacity(0.95),
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CachedNetworkImage(
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill,
                        imageUrl: 'https:${article.href}',
                        placeholder: (BuildContext context, String url) {
                          return CircularProgressIndicator();
                        },
                        errorWidget: (BuildContext context, String url, Object error) {
                          return Icon(Icons.error_outline);
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("  出售价格："+article.sellPrice, style: TextStyle(color: Theme.of(context).primaryColor),),
                          Text("  购买价格："+article.buyPrice, style: TextStyle(color: Theme.of(context).primaryColor),),
                        ],
                      )
                    ],
                  ),
                  Text("\n"+desc1, style: TextStyle(color: Theme.of(context).primaryColor),),
                  Text('\n'+desc2, style: TextStyle(color: Theme.of(context).primaryColor),),
                ],
              ),
              shape: _defaultDialogShape,
            ),
          )),
    );
  }
}


class MingDialog extends Dialog{
  final MingData ming;

  MingDialog({Key key,@required this.ming}):super(key:key);

  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = Duration(microseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;
    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0))
    );
    var desc = ming.des.replaceAllMapped(RegExp(r'<p>'), (Match match) => '');
    desc = desc.replaceAllMapped(RegExp('</p>'), (Match match) => '\n');

    return new AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 80.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: Material(
            elevation: 24.0,
            color: Colors.black.withOpacity(0.95),
            type: MaterialType.transparency,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                      imageUrl: 'https:${ming.href}',
                      placeholder: (BuildContext context, String url) {
                        return CircularProgressIndicator();
                      },
                      errorWidget: (BuildContext context, String url, Object error) {
                        return Icon(Icons.error_outline);
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("  铭文颜色："+ming.type, style: TextStyle(color: Theme.of(context).primaryColor),),
                        Text("  铭文等级："+ming.grade, style: TextStyle(color: Theme.of(context).primaryColor),),
                      ],
                    )
                  ],
                ),
                Text("\n"+desc, style: TextStyle(color: Theme.of(context).primaryColor),),
              ],
            ),
            shape: _defaultDialogShape,
          ),
        ),
      ),
    );
  }

}
