---
layout: post
category: swing
folder: DashedLine
title: BasicStrokeで点線を作成
tags: [BasicStroke, Graphics2D]
author: aterai
pubdate: 2004-10-04T03:54:35+09:00
description: 破線パターンの配列からBasicStrokeを作成し、これを描画します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKaxPM12I/AAAAAAAAAV8/ZQON-woHuIg/s800/DashedLine.png
comments: true
---
## 概要
破線パターンの配列から`BasicStroke`を作成し、これを描画します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKaxPM12I/AAAAAAAAAV8/ZQON-woHuIg/s800/DashedLine.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel label = new JLabel() {
  BasicStroke dashedStroke;
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    if (dashedStroke == null) {
      dashedStroke = new BasicStroke(
          5f, BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER, 10f,
          getDashArray(), 0f);
    }
    Insets i = getInsets();
    int w = getWidth();
    int h = getHeight() / 2;
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setStroke(dashedStroke);
    g2.drawLine(i.left, h, w - i.right, h);
    g2.dispose();
  }
};
</code></pre>

## 解説
上記のサンプルでは、`BasicStroke`の破線属性を指定して点線をコンポーネント内に描画しています。

- - - -
- 破線のパターンは`JTextField`にカンマ区切りで記入した数値を配列に分解し、これを`BasicStroke`に渡して作成

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BasicStroke (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/BasicStroke.html)
- [Stroking and Filling Graphics Primitives (The Java™ Tutorials > 2D Graphics > Working with Geometry)](https://docs.oracle.com/javase/tutorial/2d/geometry/strokeandfill.html)

<!-- dummy comment line for breaking list -->

## コメント
