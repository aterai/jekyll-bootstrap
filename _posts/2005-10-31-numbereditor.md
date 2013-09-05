---
layout: post
title: JSpinnerの値をパーセントで指定
category: swing
folder: NumberEditor
tags: [JSpinner]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-10-31

## JSpinnerの値をパーセントで指定
`JSpinner`の値をパーセントで指定するように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTQecBWSoI/AAAAAAAAAfo/IOSdDmzOIBs/s800/NumberEditor.png)

### サンプルコード
<pre class="prettyprint"><code>JSpinner spinner = new JSpinner(new SpinnerNumberModel(0, 0, 1, 0.01));
JSpinner.NumberEditor editor = new JSpinner.NumberEditor(spinner, "0%");
editor.getTextField().setEditable(false);
spinner.setEditor(editor);
</code></pre>

### 解説
`JSpinner.NumberEditor`のコンストラクタに、`DecimalFormat`オブジェクトのパターンを入力すると数値の解析とフォーマットを行ってくれます。

上記のサンプルでは、数字を表す`0`と、`100`倍してパーセントを表す`%`を組み合わせたフォーマットパターンを使用しています。

### コメント