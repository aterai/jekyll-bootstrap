---
layout: post
title: JSpinnerの文字列を非表示にする
category: swing
folder: DecimalFormatSymbols
tags: [JSpinner, SpinnerNumberModel, JFormattedTextField, DecimalFormatSymbols]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-08-03

## JSpinnerの文字列を非表示にする
`SpinnerNumberModel`を使用する`JSpinner`を無効にしたとき、数値を非表示にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKfhstbcI/AAAAAAAAAWE/MMaDVyQ9jNY/s800/DecimalFormatSymbols.png)

### サンプルコード
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

### 解説
1. デフォルト
1. `JSpinner`から`JFormattedTextField`を取得し、この無効の場合の文字色を無効場合の背景色と同じにして、非表示になるようにしています。
1. `JSpinner`から`JFormattedTextField`を取得し、`DecimalFormatSymbols#setNaN`メソッドを使用して、値が`NaN`の場合、表示する文字列をスペースに変更しています。
1. `JSpinner`から`JFormattedTextField`を取得し、`DecimalFormatSymbols#setNaN`メソッドを使用して、値が`NaN`の場合、表示する文字列を`----`に変更しています。

### コメント
