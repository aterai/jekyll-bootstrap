---
layout: post
category: swing
folder: MatteBorder
title: MatteBorderでラベル枠を修飾
tags: [MatteBorder, JLabel]
author: aterai
pubdate: 2004-12-20T00:29:03+09:00
description: JLabelの装飾にMatteBorderを使用し、4辺でそれぞれ異なる線幅の枠を描画します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTPp-xSv1I/AAAAAAAAAeU/K5lHH6YMz_E/s800/MatteBorder.png
comments: true
---
## 概要
`JLabel`の装飾に`MatteBorder`を使用し、`4`辺でそれぞれ異なる線幅の枠を描画します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTPp-xSv1I/AAAAAAAAAeU/K5lHH6YMz_E/s800/MatteBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>Border outside = BorderFactory.createMatteBorder(0, 10, 1, 0, Color.GREEN);
Border inside = BorderFactory.createEmptyBorder(0, 5, 0, 0);
label.setBorder(BorderFactory.createCompoundBorder(outside, inside));
</code></pre>

## 解説
上記のサンプルでは、`4`辺それぞれ異なる幅の直線を描画可能な`MatteBorder`を使用し、左と下のみ枠を表示するラベルを作成しています。

- `Border`として`Icon`をタイル状に描画することも可能
    - 参考: [JComboBoxにアイコンを表示](https://ateraimemo.com/Swing/IconComboBox.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MatteBorder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/border/MatteBorder.html)
- [JComboBoxにアイコンを表示](https://ateraimemo.com/Swing/IconComboBox.html)
- [JTextField内にアイコンを追加](https://ateraimemo.com/Swing/IconTextField.html)

<!-- dummy comment line for breaking list -->

## コメント
