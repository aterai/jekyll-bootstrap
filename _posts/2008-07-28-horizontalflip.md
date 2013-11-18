---
layout: post
title: Shapeの反転
category: swing
folder: HorizontalFlip
tags: [Shape, Font, AffineTransform]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-07-28

## Shapeの反転
`AffineTransform`で図形や画像を反転します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTN731lMzI/AAAAAAAAAbk/Wc0qp3ocR88/s800/HorizontalFlip.png)

### サンプルコード
<pre class="prettyprint"><code>Font font = new Font(Font.MONOSPACED, Font.PLAIN, 200);
FontRenderContext frc = new FontRenderContext(null, true, true);
Shape copyright = new TextLayout("\u00a9", font, frc).getOutline(null);
AffineTransform at = AffineTransform.getScaleInstance(-1.0, 1.0);
//Rectangle r = copyright.getBounds();
//at.translate(r.getWidth(), r.getHeight());
//AffineTransform at = new AffineTransform(-1d,0,0,1d,r.getWidth(), r.getHeight());
Shape copyleft = at.createTransformedShape(copyright);
</code></pre>

### 解説
上記のサンプルでは、コピーライトの文字を鏡像(左右)反転して、コピーレフトのアイコンを作成しています。

上下反転の場合は、`AffineTransform.getScaleInstance(1.0, -1.0)`を使用します。

### 参考リンク
- [コピーレフト - Wikipedia](http://en.wikipedia.org/wiki/Copyleft)
    - アイコン
- [AffineTransformOpで画像を反転する](http://terai.xrea.jp/Swing/AffineTransformOp.html)

<!-- dummy comment line for breaking list -->

### コメント
