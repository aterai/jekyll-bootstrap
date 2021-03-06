---
layout: post
category: swing
folder: DecimalFormatSymbols
title: JSpinnerの文字列を非表示にする
tags: [JSpinner, SpinnerNumberModel, JFormattedTextField, DecimalFormatSymbols]
author: aterai
pubdate: 2009-08-03T20:40:16+09:00
description: SpinnerNumberModelを使用するJSpinnerを無効にしたとき、数値を非表示にします。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKfhstbcI/AAAAAAAAAWE/MMaDVyQ9jNY/s800/DecimalFormatSymbols.png
comments: true
---
## 概要
`SpinnerNumberModel`を使用する`JSpinner`を無効にしたとき、数値を非表示にします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKfhstbcI/AAAAAAAAAWE/MMaDVyQ9jNY/s800/DecimalFormatSymbols.png %}

## サンプルコード
<pre class="prettyprint"><code>private static JSpinner makeSpinner1(SpinnerNumberModel m) {
  JSpinner s = new JSpinner(m);
  JFormattedTextField ftf = getJFormattedTextField(s);
  DecimalFormatSymbols dfs = new DecimalFormatSymbols();
  ftf.setFormatterFactory(makeFFactory(dfs));
  ftf.setDisabledTextColor(UIManager.getColor("TextField.disabledColor"));
  return s;
}
</code></pre>

<pre class="prettyprint"><code>private static JSpinner makeSpinner2(SpinnerNumberModel m) {
  JSpinner s = new JSpinner(m);
  JFormattedTextField ftf = getJFormattedTextField(s);
  DecimalFormatSymbols dfs = new DecimalFormatSymbols();
  dfs.setNaN(" ");
  ftf.setFormatterFactory(makeFFactory(dfs));
  return s;
}
</code></pre>

## 解説
- デフォルト
- 非表示
    - `JSpinner`から`JFormattedTextField`を取得し、この無効の場合の文字色を無効場合の背景色と同じにして非表示化
- 半角スペース
    - `JSpinner`から`JFormattedTextField`を取得し、`DecimalFormatSymbols#setNaN(...)`メソッドを使用して値が`NaN`の場合は表示する文字列を半角スペース(`U+0020`)に変更
- `----`
    - `JSpinner`から`JFormattedTextField`を取得し、`DecimalFormatSymbols#setNaN(...)`メソッドを使用して値が`NaN`の場合は表示する文字列を`----`に変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DecimalFormatSymbols (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/text/DecimalFormatSymbols.html)

<!-- dummy comment line for breaking list -->

## コメント
