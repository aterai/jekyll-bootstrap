---
layout: post
category: swing
folder: StrokeBorder
title: StrokeBorderを使用する
tags: [Border, StrokeBorder, BasicStroke]
author: aterai
pubdate: 2012-07-23T12:17:18+09:00
description: Java 1.7.0で導入されたStrokeBorderをテストします。
image: https://lh3.googleusercontent.com/-MSfWQgMprsI/UAy_-BOqVII/AAAAAAAABPo/0uH5WtaajqY/s800/StrokeBorder.png
comments: true
---
## 概要
`Java 1.7.0`で導入された`StrokeBorder`をテストします。

{% download https://lh3.googleusercontent.com/-MSfWQgMprsI/UAy_-BOqVII/AAAAAAAABPo/0uH5WtaajqY/s800/StrokeBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>dashedStroke = new BasicStroke(5f,
    ((EndCapStyle) endcapCombo.getSelectedItem()).style,
    ((JoinStyle) joinCombo.getSelectedItem()).style,
    5f, getDashArray(), 0f);
label.setBorder(BorderFactory.createStrokeBorder(dashedStroke, Color.RED));
</code></pre>

## 解説
上記のサンプルでは、破線パターンなどから`BasicStroke`を作成し(線幅、接合トリミングの制限値、破線パターン開始位置のオフセットなどは固定)、これを`StrokeBorder`に適用して`JLabel`に設定しています。

## 参考リンク
- [StrokeBorder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/border/StrokeBorder.html)
- [BasicStrokeで点線を作成](https://ateraimemo.com/Swing/DashedLine.html)

<!-- dummy comment line for breaking list -->

## コメント
