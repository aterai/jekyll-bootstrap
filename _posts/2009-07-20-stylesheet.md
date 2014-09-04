---
layout: post
title: JEditorPaneのHTMLEditorKitにCSSを適用
category: swing
folder: StyleSheet
tags: [JEditorPane, StyleSheet, HTMLEditorKit]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-07-20

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
上記のサンプルでは、クラス名が`.highlight`の要素の文字色と背景色を`CSS`で変更しています。

## 参考リンク
- [Java Swing「JEditorPane」メモ(Hishidama's Swing-JEditorPane Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/swing/JEditorPane.html)
- [Swing - HTMLEditorKit and CSS](https://forums.oracle.com/thread/1392908)
- [StyleSheet (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/text/html/StyleSheet.html)
    - [対応しているCSSプロパティ一覧 - CSS (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/text/html/CSS.html)
- [How to add stylesheet information to a JEditorPane (jfc/swing)](http://www.devdaily.com/blog/post/jfc-swing/how-add-style-stylesheet-jeditorpane-example-code/)
- [GraphicsEnvironmentにFontを登録して使用する](http://terai.xrea.jp/Swing/RegisterFont.html)
- [Rhinoでgoogle-prettify.jsを実行する](http://terai.xrea.jp/Tips/GooglePrettifyRhino.html)

<!-- dummy comment line for breaking list -->

## コメント
- `HTMLEditorKit`の`CSS`で、色は`3`桁表記(`color: #RGB`) には対応していない？(`6`桁表記 `color:#RRGGBB`は問題なく使用可) -- [aterai](http://terai.xrea.jp/aterai.html) 2012-05-28 (月) 17:52:03

<!-- dummy comment line for breaking list -->

