---
layout: post
category: swing
folder: ThumbArrowShape
title: JSliderのつまみの形状を変更
tags: [JSlider, LookAndFeel]
author: aterai
pubdate: 2014-04-07T00:03:19+09:00
description: JSliderのつまみの形状を目盛り表示ありの場合と同じになるよう変更します。
comments: true
---
## 概要
`JSlider`のつまみの形状を目盛り表示ありの場合と同じになるよう変更します。

{% download https://lh3.googleusercontent.com/-wnMCy-QjKqI/U0Fp9vKfehI/AAAAAAAACDE/fem_kGyz1KM/s800/ThumbArrowShape.png %}

## サンプルコード
<pre class="prettyprint"><code>slider.putClientProperty("Slider.paintThumbArrowShape", Boolean.TRUE);
</code></pre>

## 解説
上記のサンプルでは、`slider.putClientProperty("Slider.paintThumbArrowShape", Boolean.TRUE);`を使用して、つまみの形状を目盛り表示ありの場合に使用する矢印型に変更しています。

- メモ
    - 矢印型に変化するかどうかは、`LookAndFeel`による
        - `NimbusLookAndFeel`では、目盛り表示ありの場合でも矢印型にはならないが、`Slider.paintThumbArrowShape`で三角形になる
    - `WindowsLookAndFeel`でつまみが小さすぎる場合に使用可
        - `slider.putClientProperty("Slider.minimumHorizontalSize", new Dimension(30, 30));`などは効果がない
    - `slider.setPaintTicks(true);`だけ使用する場合と異なり、目盛り表示領域の余白がない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollBarのKnobの最小サイズを設定する](http://ateraimemo.com/Swing/MinimumThumbSize.html)

<!-- dummy comment line for breaking list -->

## コメント
