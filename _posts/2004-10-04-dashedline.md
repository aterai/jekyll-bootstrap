---
layout: post
title: BasicStrokeで点線を作成
category: swing
folder: DashedLine
tags: [BasicStroke, Graphics2D]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-10-04

## BasicStrokeで点線を作成
点線・破線を描画します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKaxPM12I/AAAAAAAAAV8/ZQON-woHuIg/s800/DashedLine.png)

### サンプルコード
<pre class="prettyprint"><code>JLabel label = new JLabel() {
  BasicStroke dashed2;
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    super.paintComponent(g2);
    if(dashed2==null) dashed2 = new BasicStroke(5.0f, BasicStroke.CAP_BUTT,
                  BasicStroke.JOIN_MITER, 10.0f, getDashArray(), 0.0f);
    g2.setStroke(dashed2);
    g2.drawLine(5, getHeight()/2, getWidth()-10, getHeight()/2);
  }
};
</code></pre>

### 解説
`BasicStroke`の破線属性を指定して点線を描画します。

上記のサンプルでは、カンマ区切りで記入した数値を配列に分解し、これを破線のパターンとして`BasicStroke`に渡しています。

### 参考リンク
- [Stroking and Filling Graphics Primitives (The Java™ Tutorials > 2D Graphics > Working with Geometry)](http://docs.oracle.com/javase/tutorial/2d/geometry/strokeandfill.html)

<!-- dummy comment line for breaking list -->

### コメント
