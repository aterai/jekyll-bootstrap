---
layout: post
category: swing
folder: MatteBorder
title: MatteBorderでラベル枠を修飾
tags: [MatteBorder]
author: aterai
pubdate: 2004-12-20T00:29:03+09:00
description: MatteBorderでラベルの枠を修飾します。
comments: true
---
## 概要
`MatteBorder`でラベルの枠を修飾します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTPp-xSv1I/AAAAAAAAAeU/K5lHH6YMz_E/s800/MatteBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>Border outside = BorderFactory.createMatteBorder(0,10,1,0,Color.GREEN);
Border inside  = BorderFactory.createEmptyBorder(0,5,0,0);
label.setBorder(BorderFactory.createCompoundBorder(outside, inside));
</code></pre>

## 解説
`MatteBorder`は、`4`辺それぞれに色などを表示することができます。上記のサンプルでは、左と下のみ枠を描いてタイトル風のラベルを作成しています。アイコンをタイル状に描画することもできるので、[JComboBoxにアイコンを表示](http://terai.xrea.jp/Swing/IconComboBox.html)のような使い方をする場合もあります。

## 参考リンク
- [JComboBoxにアイコンを表示](http://terai.xrea.jp/Swing/IconComboBox.html)
- [JTextField内にアイコンを追加](http://terai.xrea.jp/Swing/IconTextField.html)

<!-- dummy comment line for breaking list -->

## コメント
