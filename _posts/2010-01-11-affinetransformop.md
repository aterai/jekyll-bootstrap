---
layout: post
category: swing
folder: AffineTransformOp
title: AffineTransformOpで画像を反転する
tags: [AffineTransformOp, BufferedImage, AffineTransform]
author: aterai
pubdate: 2010-01-11T23:59:17+09:00
description: AffineTransformOpなどを使って、画像の上下反転、左右反転を行います。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHczsN2NI/AAAAAAAAARM/D8gpa0-KfEI/s800/AffineTransformOp.png
comments: true
---
## 概要
`AffineTransformOp`などを使って、画像の上下反転、左右反転を行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHczsN2NI/AAAAAAAAARM/D8gpa0-KfEI/s800/AffineTransformOp.png %}

## サンプルコード
<pre class="prettyprint"><code>int w = bi.getWidth(this);
int h = bi.getHeight(this);
AffineTransform at = AffineTransform.getScaleInstance(-1d, 1d);
at.translate(-w, 0);
AffineTransformOp atOp = new AffineTransformOp(at, null);
g.drawImage(atOp.filter(bi, null), 0, 0, w, h, this);
</code></pre>

## 解説
上記のサンプルでは、`AffineTransformOp#filter(...)`メソッドを使用して左右反転した`BufferedImage`を生成しています。

- 上下反転の例:
    
    <pre class="prettyprint"><code>AffineTransform at = AffineTransform.getScaleInstance(1d, -1d);
    at.translate(0, -h);
    g2.drawImage(bi, at, this);
</code></pre>
- * 参考リンク [#reference]
- [AffineTransform#getScaleInstance(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/geom/AffineTransform.html#getScaleInstance-double-double-)
- [Shapeの反転](https://ateraimemo.com/Swing/HorizontalFlip.html)

<!-- dummy comment line for breaking list -->

## コメント
