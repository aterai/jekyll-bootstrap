---
layout: post
category: swing
folder: FlatteningPathIterator
title: FlatteningPathIteratorでShape上の点を取得する
tags: [Shape, PathIterator, FlatteningPathIterator]
author: aterai
pubdate: 2013-07-08T01:45:24+09:00
description: FlatteningPathIteratorを使って平坦化されたShape上の座標点を取得、描画します。
image: https://lh4.googleusercontent.com/-3GsdpxueSG8/Udl1tOfisII/AAAAAAAABvc/SBOIf1ZPPUk/s800/FlatteningPathIterator.png
comments: true
---
## 概要
`FlatteningPathIterator`を使って平坦化された`Shape`上の座標点を取得、描画します。

{% download https://lh4.googleusercontent.com/-3GsdpxueSG8/Udl1tOfisII/AAAAAAAABvc/SBOIf1ZPPUk/s800/FlatteningPathIterator.png %}

## サンプルコード
<pre class="prettyprint"><code>PathIterator i = new FlatteningPathIterator(shape.getPathIterator(null), 1d);
float[] coords = new float[6];
while (!i.isDone()) {
  i.currentSegment(coords);
  g2.fillRect((int) (coords[0] - .5), (int) (coords[1] - .5), 2, 2);
  i.next();
}
</code></pre>

## 解説
- `Ellipse2D`
    - `new Ellipse2D.Double`で作成した`Shape`を描画
- `Polygon x 2`
    - 上記の楕円を`360/60`度ごとに曲線上の座標点を取得し、`Polygon`に変換して直線で描画

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static Polygon convertEllipse2Polygon(Ellipse2D e) {
  Rectangle b = e.getBounds();
  int r1 = b.width / 2, r2 = b.height / 2;
  int x0 = b.x + r1,  y0 = b.y + r2;
  int v  = 60;
  double a = 0.0, d = 2 * Math.PI / v;
  Polygon polygon = new Polygon();
  for (int i = 0; i &lt; v; i++) {
    polygon.addPoint((int) (r1 * Math.cos(a) + x0), (int) (r2 * Math.sin(a) + y0));
    a += d;
  }
  return polygon;
}
</code></pre>

- `FlatteningPathIterator`
    - 上記の楕円から取得した`PathIterator`を`FlatteningPathIterator`で平坦化して曲線上の等間隔な座標点を取得し、`Polygon`に変換して直線で描画
    - 参考: [FlatteningPathIterator and moving object along Shape path.](http://java-sl.com/tip_flatteningpathiterator_moving_shape.html)
        - via: [java - Converting an Ellipse2D to Polygon - Stack Overflow](https://stackoverflow.com/questions/17272912/converting-an-ellipse2d-to-polygon)
    - ~~`FlatteningPathIterator`を使う方法なら、どんな`Shape`でもその線上から等間隔な座標点を簡単に取得できる~~

<!-- dummy comment line for breaking list -->

## 参考リンク
- [FlatteningPathIterator (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/geom/FlatteningPathIterator.html)
- [FlatteningPathIterator and moving object along Shape path.](http://java-sl.com/tip_flatteningpathiterator_moving_shape.html)
    - `Shape`のパスに添ってアニメーションを行うサンプルがある

<!-- dummy comment line for breaking list -->

## コメント
