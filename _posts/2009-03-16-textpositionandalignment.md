---
layout: post
category: swing
folder: TextPositionAndAlignment
title: JLabelのアイコンと文字列の位置
tags: [JLabel, Icon, Alignment, JButton]
author: aterai
pubdate: 2009-03-16T13:43:23+09:00
description: JLabelのアイコンと文字列の位置をテストします。
comments: true
---
## 概要
`JLabel`のアイコンと文字列の位置をテストします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTVPS5wBUI/AAAAAAAAAnU/2hri1cAlfoM/s800/TextPositionAndAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>label.setVerticalAlignment(SwingConstants.CENTER);
label.setVerticalTextPosition(SwingConstants.TOP);
label.setHorizontalAlignment(SwingConstants.RIGHT);
label.setHorizontalTextPosition(SwingConstants.LEFT);
</code></pre>

## 解説
上記のサンプルでは、`JLabel#setVerticalAlignment(...)`、`JLabel#setVerticalTextPosition(...)`、`JLabel#setHorizontalAlignment(...)`、`JLabel#setHorizontalTextPosition(...)`などのメソッドを使用して、`JLabel`のアイコンと文字列の位置関係を変更しています。

`JButton`などにも、アイコンと文字列の位置を設定する同名のメソッドが存在します(引数は`SwingConstants`インタフェースで定義された共通の定数が使用可)。

## コメント
