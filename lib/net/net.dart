import 'dart:convert';
import 'dart:io';

import 'package:flutter_hero/model/model.dart';
import 'package:dio/dio.dart';

/// Create by george
/// Date:2019/5/22
/// description:

const MainUrl = 'https://pvp.qq.com/web201605/';
const HeroList = 'js/herolist.json';
const SummonerList = 'js/summoner.json';
const ItemList = 'js/item.json';
const MingList = 'js/ming.json';

///获取英雄列表
Future<List<HeroData>> getMain() async {
  try {
    Response response = await Dio(BaseOptions(
            contentType: ContentType.json, responseType: ResponseType.json))
        .get(MainUrl + HeroList);
    return await _parseHTML(response.toString());
  } catch (e) {
    print('error:$e');
    return null;
  }
}

///解析英雄列表
Future<List<HeroData>> _parseHTML(String json) async {
  List<HeroData> list = [];
  final heros = jsonDecode(json) as List<dynamic>;
  for (int i = heros.length - 1; i > -1; i--) {
    final item = heros[i];
    list.add(HeroData(
        href: '//game.gtimg.cn/images/yxzj/img201606/heroimg/${item['ename']}/${item['ename']}.jpg',
        name: item['cname'],
        number: item['cname'].toString(),
        infoHref: 'herodetail/${item['ename']}.shtml',
        payType: item['pay_type'],
        heroType: item['hero_type'],
        newType: item['new_type'],
        heroType2: item['hero_type2']));
  }
  return list;
}

///获取物品页面
Future<List<ArticleData>> getArticle() async {
  try {
    Response detailJson = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get(MainUrl+ItemList);
    print('获取到article结果，开始解析');
    return await _parseArticles(detailJson.toString());
  } catch (e) {
    print('article发生了错误: '+e.toString());
    return null;
  }
}

Future<List<ArticleData>> _parseArticles(String json) async {
  List<ArticleData> list = [];
  final itemDetails = jsonDecode(json);
  for (final item in itemDetails) {
    list.add(ArticleData(
      href: "//game.gtimg.cn/images/yxzj/img201606/itemimg/${item['item_id']}.jpg",
      name: item['item_name'],
      ID: item['item_id'].toString(),
      sellPrice: item['total_price'].toString(),
      buyPrice: item['total_price'].toString(),
      desc1: item['des1'],
      desc2: item['des2'],
      type: item['item_type'],
    ));
  }
  return list;
}

///获得符文列表
Future<List<MingData>> getMings() async {
  try {
    Response detailJson = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get(MainUrl+MingList);
    print('获取到skill结果，开始解析');
    return await _parseMingHtml(detailJson.toString());
  } catch (e) {
    print('skill发生了错误: '+e.toString());
    return null;
  }
}

Future<List<MingData>> _parseMingHtml(String json) async {
  List<MingData> result = [];
  final details = jsonDecode(json);
  for (final item in details) {
    result.add(MingData(
        mingID: item['ming_id'],
        type: item['ming_type'],
        grade: item['ming_grade'],
        name: item['ming_name'],
        des: item['ming_des'],
        href: "//game.gtimg.cn/images/yxzj/img201606/mingwen/${item['ming_id']}.png"
    ));
  }
  return result;
}

//获得召唤师技能
Future<List<CommonSkill>> getCommonSkill() async {
  try {
    Response detailJson = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get(MainUrl+SummonerList);
    print('获取到skill结果，开始解析');
    return await _parseCommonHtml(detailJson.toString());
  } catch (e) {
    print('skill发生了错误: '+e.toString());
    return null;
  }
}
Future<List<CommonSkill>> _parseCommonHtml(String json) async {
  List<CommonSkill> result = [];
  final details = jsonDecode(json);
  for (final item in details) {
    result.add(CommonSkill(
        name: item['summoner_name'],
        href: "//game.gtimg.cn/images/yxzj/img201606/summoner/${item['summoner_id']}.jpg",
        ID: item['summoner_id'].toString(),
        rank: item['summoner_rank'],
        description: item['summoner_description'],
        showImageHref: "//game.gtimg.cn/images/yxzj/img201606/summoner/${item['summoner_id']}-big.jpg"
    ));
  }
  return result;
}