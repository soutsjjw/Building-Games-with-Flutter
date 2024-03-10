import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

void main() async {
  // 建立遊戲實體
  final goldRush = GoldRush();

  // 設定 Flutter 小工具並以全螢幕縱向啟動遊戲
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // 每個都是 Flutter 中的一個 widget！ 因此運行應用程式並在此處傳遞遊戲小部件
  runApp(GameWidget(game: goldRush));
}

class GoldRush with Game {
  // 我們的方塊動畫的速度
  static const int squareSpeed = 250;
  // 方形的顏色
  static final squarePaint = BasicPalette.green.paint();
  // 我們的正方形的寬度和高度將為 100 x 100
  static final squareWidth = 100.0, squareHeight = 100.0;

  // 我們廣場的當前位置和大小
  late Rect squarePos;

  // 我們的方塊移動的方向，1代表從左到右，-1代表從右到左
  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, centerY;

  // 重寫此函數來初始化遊戲狀態並載入遊戲資源
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 取得螢幕的寬度和高度
    screenWidth = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single).size.width;
    screenHeight = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single).size.height;

    // 計算螢幕的中心，可以調整正方形的大小
    centerX = (screenWidth / 2) - (squareWidth / 2);
    centerY = (screenHeight / 2) - (squareHeight / 2);

    // 設定綠色方塊初始位置在螢幕中央，大小為100寬高
    squarePos = Rect.fromLTWH(centerX, centerY, squareWidth, squareHeight);
  }

  // 重寫此函數來控制螢幕上繪製的內容
  @override
  void render(Canvas canvas) {
    // 在畫布上繪製綠色方塊
    canvas.drawRect(squarePos, squarePaint);
  }

  // 覆蓋此函數以更新自上次更新以來經過的時間的遊戲狀態
  @override
  void update(double dt) {
    // 根據速度、方向和經過的時間更新方塊的 x 位置
    squarePos = squarePos.translate(squareSpeed * squareDirection * dt, 0);

    // 如果方塊到達螢幕一側，則反轉方塊行進的方向
    if (squareDirection == 1 && squarePos.right > screenWidth) {
      squareDirection = -1;
    } else if (squareDirection == -1 && squarePos.left < 0) {
      squareDirection = 1;
    }
  }
}
