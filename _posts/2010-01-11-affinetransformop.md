---
layout: post
title: AffineTransformOpで画像を反転する
category: swing
folder: AffineTransformOp
tags: [AffineTransformOp, BufferedImage, AffineTransform]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-01-11

## AffineTransformOpで画像を反転する
`AffineTransformOp`などを使って、画像の上下反転、左右反転を行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHczsN2NI/AAAAAAAAARM/D8gpa0-KfEI/s800/AffineTransformOp.png %}

### サンプルコード
<pre class="prettyprint"><code>int w = bi.getWidth(this);
int h = bi.getHeight(this);
AffineTransform at = AffineTransform.getScaleInstance(-1.0, 1.0);
at.translate(-w, 0);
AffineTransformOp atOp = new AffineTransformOp(at, null);
g.drawImage(atOp.filter(bi, null), 0, 0, w, h, this);
</code></pre>

### 解説
上記のサンプルでは、`AffineTransformOp#filter(...)`メソッドで左右反転した`BufferedImage`を生成しています。

- - - -
以下のような方法で上下反転することもできます。

<pre class="prettyprint"><code>AffineTransform at = AffineTransform.getScaleInstance(1.0, -1.0);
at.translate(0, -h);
g2.drawImage(bi, at, this);
</code></pre>

### 参考リンク
- [Shapeの反転](http://terai.xrea.jp/Swing/HorizontalFlip.html)

<!-- dummy comment line for breaking list -->

### コメント
