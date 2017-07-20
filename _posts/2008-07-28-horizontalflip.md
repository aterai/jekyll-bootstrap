---
layout: post
category: swing
folder: HorizontalFlip
title: Shapeの反転
tags: [Shape, Font, AffineTransform]
author: aterai
pubdate: 2008-07-28T12:01:57+09:00
description: AffineTransformで図形や画像を反転して表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTN731lMzI/AAAAAAAAAbk/Wc0qp3ocR88/s800/HorizontalFlip.png
comments: true
---
## 概要
`AffineTransform`で図形や画像を反転して表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTN731lMzI/AAAAAAAAAbk/Wc0qp3ocR88/s800/HorizontalFlip.png %}

## サンプルコード
<pre class="prettyprint"><code>Font font = new Font(Font.MONOSPACED, Font.PLAIN, 200);
FontRenderContext frc = new FontRenderContext(null, true, true);
Shape copyright = new TextLayout("\u00a9", font, frc).getOutline(null);
AffineTransform at = AffineTransform.getScaleInstance(-1d, 1d);
//Rectangle r = copyright.getBounds();
//at.translate(r.getWidth(), r.getHeight());
//AffineTransform at = new AffineTransform(-1d, 0d, 0d, 1d, r.getWidth(), r.getHeight());
Shape copyleft = at.createTransformedShape(copyright);
</code></pre>

## 解説
上記のサンプルでは、コピーライトの文字を鏡像(左右)反転して、コピーレフトの文字アイコンを作成しています。

- - - -
上下反転の場合は、`AffineTransform.getScaleInstance(1d, -1d)`が使用可能です。

## 参考リンク
- [コピーレフト - Wikipedia](http://en.wikipedia.org/wiki/Copyleft)
- [AffineTransformOpで画像を反転する](http://ateraimemo.com/Swing/AffineTransformOp.html)

<!-- dummy comment line for breaking list -->

## コメント
