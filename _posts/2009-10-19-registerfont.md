---
layout: post
category: swing
folder: RegisterFont
title: GraphicsEnvironmentにFontを登録して使用する
tags: [Font, GraphicsEnvironment, Html, StyleSheet, JLabel, JEditorPane, JTextPane]
author: aterai
pubdate: 2009-10-19T14:42:22+09:00
description: GraphicsEnvironmentにFontを登録して、Htmlタグなどで使用できるようにします。
comments: true
---
## 概要
`GraphicsEnvironment`に`Font`を登録して、`Html`タグなどで使用できるようにします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRkZgST0I/AAAAAAAAAhY/czEyIQL0NfY/s800/RegisterFont.png %}

## サンプルコード
<pre class="prettyprint"><code>Font font = makeFont(getClass().getResource("Burnstown Dam.ttf"));
GraphicsEnvironment.getLocalGraphicsEnvironment().registerFont(font);
</code></pre>

## 解説
- 1. `JLabel#setFont`メソッドでフォントを設定しています。
- 2. 登録したフォントを`Html`タグで指定して使用しています。
    - `label.setText("<html><font size='+3' face='Burnstown Dam'>2: html,font,size,+3</font></html>");`
- 3. `StyleSheet`で`body`タグのフォントを設定しています。
    - `styleSheet.addRule("body {font-size: 24pt; font-family: Burnstown Dam;}");`
- 4. `JTextPane#setFont`メソッドでフォントを設定しています。
    - `body`タグで指定されているフォントを無視して、`JTextPane`のデフォルトのフォントを使用したい場合は、`editor.putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);`としておく必要があります。

<!-- dummy comment line for breaking list -->

## 参考リンク
- [creamundo | Fuentes Gratis TrueType TTF](http://www.creamundo.com/)
    - こちらから`TrueType`フォントを利用しています。
- [Fontをファイルから取得](http://terai.xrea.jp/Swing/CreateFont.html)
- [Htmlを使ったJLabelとJEditorPaneの無効化](http://terai.xrea.jp/Swing/DisabledHtmlLabel.html)
- [JEditorPaneのHTMLEditorKitにCSSを適用](http://terai.xrea.jp/Swing/StyleSheet.html)

<!-- dummy comment line for breaking list -->

## コメント
