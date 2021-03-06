---
layout: post
category: swing
folder: MouseInfo
title: Screen上にあるMouseの位置を取得する
tags: [MouseInfo, Timer]
author: aterai
pubdate: 2007-10-29T13:39:49+09:00
description: Screen上にあるMouseの絶対位置を取得して、パネル内のラケットを移動します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQC6wobCI/AAAAAAAAAe8/3UnK314olDM/s800/MouseInfo.png
comments: true
---
## 概要
`Screen`上にある`Mouse`の絶対位置を取得して、パネル内のラケットを移動します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQC6wobCI/AAAAAAAAAe8/3UnK314olDM/s800/MouseInfo.png %}

## サンプルコード
<pre class="prettyprint"><code>public static final Dimension panelDim = new Dimension(320, 240);
private final Racket racket = new Racket(panelDim);

public MainPanel() {
  super(new BorderLayout());
  setPreferredSize(panelDim);
  new Timer(10, this).start();
}

@Override protected void paintComponent(Graphics g) {
  super.paintComponent(g);
  racket.draw(g);
}

@Override public void actionPerformed(ActionEvent e) {
  PointerInfo pi = MouseInfo.getPointerInfo();
  Point pt = pi.getLocation();
  SwingUtilities.convertPointFromScreen(pt, this);
  racket.move(pt.x);
  repaint();
}
</code></pre>

## 解説
上記のサンプルでは、マウスカーソルがパネル外に移動した場合でもラケットを動かせるように、以下のような方法を使用しています。

1. `Timer`を使用して`10`ミリ秒ごとに`MouseInfo`から`PointerInfo`を取得
1. `PointerInfo`から画面上でのポインタ座標を取得
1. `SwingUtilities.convertPointFromScreen(...)`メソッドで、これをパネル相対の座標に変換
1. ラケットに変換した座標を与えて`JPanel#repaint()`メソッドで再描画

## 参考リンク
- [MouseInfo (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/MouseInfo.html)
- [J2SE 5.0 Tiger 虎の穴 マウスの位置](http://www.javainthebox.net/laboratory/J2SE1.5/GUI/MouseLocation/MouseLocation.html)
- [ラケットを動かす - Javaでゲーム作りますが何か？](http://d.hatena.ne.jp/aidiary/20070601/1251545490)

<!-- dummy comment line for breaking list -->

## コメント
- スクリーンショットの間違いを修正。 -- *aterai* 2007-12-28 (金) 14:41:53

<!-- dummy comment line for breaking list -->
