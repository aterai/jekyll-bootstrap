---
layout: post
category: swing
folder: AnchorTextColor
title: JLabelで表示するHtmlアンカータグの文字色を変更する
tags: [JLabel, Html, JEditorPane, HTMLEditorKit, StyleSheet]
author: aterai
pubdate: 2015-03-23T00:19:09+09:00
description: JLabelやJEditorPaneで表示されるHtmlアンカータグのデフォルト文字色を変更するテストを行います。
image: https://lh4.googleusercontent.com/-tilzZhgELFk/VQ7ZWC4xblI/AAAAAAAAN1E/bR7KsSRQuRg/s800/AnchorTextColor.png
comments: true
---
## 概要
`JLabel`や`JEditorPane`で表示される`Html`アンカータグのデフォルト文字色を変更するテストを行います。

{% download https://lh4.googleusercontent.com/-tilzZhgELFk/VQ7ZWC4xblI/AAAAAAAAN1E/bR7KsSRQuRg/s800/AnchorTextColor.png %}

## サンプルコード
<pre class="prettyprint"><code>HTMLEditorKit kit = new HTMLEditorKit();
StyleSheet styleSheet = kit.getStyleSheet();
styleSheet.addRule("a{color:#FF0000;}");
JLabel label2 = new JLabel("&lt;html&gt;&lt;a href='" + MYSITE + "'&gt;" + MYSITE + "&lt;/a&gt;");

JLabel label3 = new JLabel("&lt;html&gt;&lt;a style='color:#00FF00' href='" + MYSITE + "'&gt;" + MYSITE + "&lt;/a&gt;");
</code></pre>

## 解説
上記のサンプルでは、[Customize detault html link color in java swing - Stack Overflow](http://stackoverflow.com/questions/26749495/customize-detault-html-link-color-in-java-swing)を参考にして、
`Html`のアンカータグ(`<a href='...'>...</a>`)のデフォルト文字色を変更しています。

- デフォルトの`StyleSheet`(`HTMLEditorKit#getStyleSheet()`)は、グローバルな`AppContext`で管理されているため、これに`a{color:#FF0000;}`などのルールを追加すると、`Swing`アプリ全体でアンカータグの文字色を変更できる
    - `JLabel`は作成された時点のデフォルト`StyleSheet`を使用(一番上の`JLabel`はアンカーの文字色は青のまま)するが、`JEditorPane`は、現在の`StyleSheet`を使用(すべての`JEditorPane`でアンカーの文字色は赤になる)する？
    - 直接、`<a style='color:#00FF00'`のようにスタイルを指定した場合は、こちらが優先される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Customize detault html link color in java swing - Stack Overflow](http://stackoverflow.com/questions/26749495/customize-detault-html-link-color-in-java-swing)

<!-- dummy comment line for breaking list -->

## コメント
