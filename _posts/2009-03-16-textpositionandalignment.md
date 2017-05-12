---
layout: post
category: swing
folder: TextPositionAndAlignment
title: JLabelのアイコンと文字列の位置
tags: [JLabel, Icon, Alignment, JButton]
author: aterai
pubdate: 2009-03-16T13:43:23+09:00
description: JLabelのアイコンと文字列の位置をテストします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTVPS5wBUI/AAAAAAAAAnU/2hri1cAlfoM/s800/TextPositionAndAlignment.png
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

- `AbstractButton`を継承する`JButton`などにも、アイコンと文字列の位置を設定する同名のメソッドが存在する
    - 引数は`SwingConstants`インタフェースで定義された共通の定数が使用可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLabel#setVerticalAlignment(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JLabel.html#setVerticalAlignment-int-)
- [JLabel#setVerticalTextPosition(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JLabel.html#setVerticalTextPosition-int-)
- [JLabel#setHorizontalAlignment(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JLabel.html#setHorizontalAlignment-int-)
- [JLabel#setHorizontalTextPosition(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JLabel.html#setHorizontalTextPosition-int-)
- [AbstractButton#setVerticalAlignment(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractButton.html#setVerticalAlignment-int-)
- [AbstractButton#setVerticalTextPosition(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractButton.html#setVerticalTextPosition-int-)
- [AbstractButton#setHorizontalAlignment(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractButton.html#setHorizontalAlignment-int-)
- [AbstractButton#setHorizontalTextPosition(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractButton.html#setHorizontalTextPosition-int-)

<!-- dummy comment line for breaking list -->

## コメント
