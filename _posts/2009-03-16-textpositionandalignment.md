---
layout: post
title: JLabelのアイコンと文字列の位置
category: swing
folder: TextPositionAndAlignment
tags: [JLabel, Icon, Alignment]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-03-16

## JLabelのアイコンと文字列の位置
`JLabel`のアイコンと文字列の位置をテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTVPS5wBUI/AAAAAAAAAnU/2hri1cAlfoM/s800/TextPositionAndAlignment.png)

### サンプルコード
<pre class="prettyprint"><code>label.setVerticalAlignment(SwingConstants.CENTER);
label.setVerticalTextPosition(SwingConstants.TOP);
label.setHorizontalAlignment(SwingConstants.RIGHT);
label.setHorizontalTextPosition(SwingConstants.LEFT);
</code></pre>

### 解説
上記のサンプルでは、`setVerticalAlignment`、`setVerticalTextPosition`、`setHorizontalAlignment`、`setHorizontalTextPosition`といったメソッドを使用して、`JLabel`のアイコンと文字列の位置関係を変更しています。

### コメント
