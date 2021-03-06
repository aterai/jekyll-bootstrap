---
layout: post
category: swing
folder: NumberEditor
title: JSpinnerの値をパーセントで指定
tags: [JSpinner]
author: aterai
pubdate: 2005-10-31T11:17:46+09:00
description: JSpinnerの値をパーセントで指定するように設定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQecBWSoI/AAAAAAAAAfo/IOSdDmzOIBs/s800/NumberEditor.png
comments: true
---
## 概要
`JSpinner`の値をパーセントで指定するように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQecBWSoI/AAAAAAAAAfo/IOSdDmzOIBs/s800/NumberEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>JSpinner spinner = new JSpinner(new SpinnerNumberModel(0, 0, 1, .01));
JSpinner.NumberEditor editor = new JSpinner.NumberEditor(spinner, "0%");
editor.getTextField().setEditable(false);
spinner.setEditor(editor);
</code></pre>

## 解説
上記のサンプルでは、`JSpinner.NumberEditor`のコンストラクタに`DecimalFormat`オブジェクトのパターンを設定して数値の表示フォーマットを変更しています。

- 数字を表す`0`と`100`倍してパーセントを表す`%`を組み合わせたフォーマットパターンを使用

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSpinner.NumberEditor (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JSpinner.NumberEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
