---
layout: post
category: swing
folder: StyleSheet
title: JEditorPaneのHTMLEditorKitにCSSを適用
tags: [JEditorPane, StyleSheet, HTMLEditorKit]
author: aterai
pubdate: 2009-07-20T14:20:10+09:00
description: JEditorPaneにStyleSheetを追加したHTMLEditorKitを設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTT6cwbhCI/AAAAAAAAAlM/PsSYnlumJJg/s800/StyleSheet.png
comments: true
---
## 概要
`JEditorPane`に`StyleSheet`を追加した`HTMLEditorKit`を設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTT6cwbhCI/AAAAAAAAAlM/PsSYnlumJJg/s800/StyleSheet.png %}

## サンプルコード
<pre class="prettyprint"><code>StyleSheet styleSheet = new StyleSheet();
styleSheet.addRule("body {font-size: 12pt;}");
styleSheet.addRule(".highlight {color: red; background: green}");
HTMLEditorKit htmlEditorKit = new HTMLEditorKit();
htmlEditorKit.setStyleSheet(styleSheet);
JEditorPane editor = new JEditorPane();
editor.setEditorKit(htmlEditorKit);
editor.setText(makeTestHtml());
</code></pre>

## 解説
上記のサンプルでは、`JEditorPane`に`HTMLEditorKit`を適用して`HTML`を表示するよう設定し、クラス名が`.highlight`になっている要素の文字色と背景色を`CSS`で変更しています。

## 参考リンク
- [Java Swing「JEditorPane」メモ(Hishidama's Swing-JEditorPane Memo)](https://www.ne.jp/asahi/hishidama/home/tech/java/swing/JEditorPane.html)
- [Swing - HTMLEditorKit and CSS](https://community.oracle.com/thread/1392908)
- [StyleSheet (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/StyleSheet.html)
    - [対応しているCSSプロパティ一覧 - CSS (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/CSS.html)
- [How to add stylesheet information to a JEditorPane | alvinalexander.com](http://alvinalexander.com/blog/post/jfc-swing/how-add-style-stylesheet-jeditorpane-example-code)
- [GraphicsEnvironmentにFontを登録して使用する](https://ateraimemo.com/Swing/RegisterFont.html)
- [Rhinoでgoogle-prettify.jsを実行する](https://ateraimemo.com/Tips/GooglePrettifyRhino.html)

<!-- dummy comment line for breaking list -->

## コメント
- `HTMLEditorKit`の`CSS`で、色は`3`桁表記(`color: #RGB`) には対応していない？(`6`桁表記 `color:#RRGGBB`は問題なく使用可) -- *aterai* 2012-05-28 (月) 17:52:03

<!-- dummy comment line for breaking list -->
