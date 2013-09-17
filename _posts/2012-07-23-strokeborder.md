---
layout: post
title: StrokeBorderを使用する
category: swing
folder: StrokeBorder
tags: [Border, StrokeBorder, BasicStroke]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-07-23

## StrokeBorderを使用する
`Java 1.7.0`で導入された`StrokeBorder`をテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-MSfWQgMprsI/UAy_-BOqVII/AAAAAAAABPo/0uH5WtaajqY/s800/StrokeBorder.png)

### サンプルコード
<pre class="prettyprint"><code>dashedStroke = new BasicStroke(5.0f,
    ((EndCapStyle)endcapCombo.getSelectedItem()).style,
    ((JoinStyle)joinCombo.getSelectedItem()).style,
    5.0f, getDashArray(), 0.0f);
label.setBorder(BorderFactory.createStrokeBorder(dashedStroke, Color.RED));
</code></pre>

### 解説
上記のサンプルでは、破線パターンなどから`BasicStroke`を作成し(線幅、接合トリミングの制限値、破線パターン開始位置のオフセットなどは固定)、これを`StrokeBorder`に適用(色は固定)して、`JLabel`に設定しています。

### 参考リンク
- [StrokeBorder (Java Platform SE 7 )](http://docs.oracle.com/javase/7/docs/api/javax/swing/border/StrokeBorder.html)
- [BasicStrokeで点線を作成](http://terai.xrea.jp/Swing/DashedLine.html)

<!-- dummy comment line for breaking list -->

### コメント
