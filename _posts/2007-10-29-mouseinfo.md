---
layout: post
title: Screen上にあるMouseの位置を取得する
category: swing
folder: MouseInfo
tags: [MouseInfo, Timer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-10-29

## Screen上にあるMouseの位置を取得する
`Screen`上にある`Mouse`の絶対位置を取得して、パネル内のラケットを移動します。


{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQC6wobCI/AAAAAAAAAe8/3UnK314olDM/s800/MouseInfo.png %}

### サンプルコード
<pre class="prettyprint"><code>public static final Dimension panelDim = new Dimension(320, 240);
private final Racket racket = new Racket(panelDim);
public MainPanel() {
  super(new BorderLayout());
  setPreferredSize(panelDim);
  new javax.swing.Timer(10, this).start();
}
@Override public void paintComponent(Graphics g) {
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

### 解説
上記のサンプルでは、マウスカーソルがパネル外に移動した場合でもラケットを動かせるように、以下のような方法を使用しています。

1. `10`ミリ秒ごとに`MouseInfo`から`PointerInfo`を取得
1. `PointerInfo`から画面上でのポインタ座標を取得
1. `SwingUtilities.convertPointFromScreen`メソッドで、これをパネル相対のポインタ座標に変換
1. ラケットに変換した座標を与えて、`repaint`

### 参考リンク
- [J2SE 5.0 Tiger 虎の穴 マウスの位置](http://www.javainthebox.net/laboratory/J2SE1.5/GUI/MouseLocation/MouseLocation.html)
- [ラケットを動かす - Javaでゲーム作りますが何か？](http://d.hatena.ne.jp/aidiary/20070601/1251545490)

<!-- dummy comment line for breaking list -->

### コメント
- スクリーンショットの間違いを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-12-28 (金) 14:41:53

<!-- dummy comment line for breaking list -->

