---
layout: post
category: swing
folder: SelectionColor
title: JEditorPaneで選択色を半透明化
tags: [JEditorPane, Translucent, StyleSheet, HighlightPainter]
author: aterai
pubdate: 2013-10-07T00:14:25+09:00
description: JEditorPaneで選択色を半透明化し、HighlightPainterによるハイライトやCSSでの背景色変更と組み合わせた場合の描画のテストを行います。
comments: true
---
## 概要
`JEditorPane`で選択色を半透明化し、`HighlightPainter`によるハイライトや`CSS`での背景色変更と組み合わせた場合の描画のテストを行います。

{% download https://lh4.googleusercontent.com/-vbDIDKoUbmw/UlFdSAKWCVI/AAAAAAAAB3A/wbVAmRfeTCY/s800/SelectionColor.png %}

## サンプルコード
<pre class="prettyprint"><code>JEditorPane area = new JEditorPane();
area.setOpaque(false);
area.setForeground(new Color(200, 200, 200));
area.setSelectedTextColor(Color.WHITE);
area.setBackground(new Color(0, true));
area.setSelectionColor(new Color(0xC86464FF, true));
</code></pre>

## 解説
上記のサンプルでは、`JEditorPane`の選択色などを半透明化して、ハイライトや`CSS`での背景色変更と組み合わせた場合のテストをしています。

- `JTextComponent#setSelectionColor`, `JTextComponent#setSelectedTextColor`
    - 選択色、選択文字色を変更することができる
    - どちらも半透明色を使用可能
    - デフォルトでは、選択が一番手前に描画されるので、半透明にしておくと他の選択色とアルファで乗算されて表示される
    - [JTextComponent#setSelectionColor(Color)](http://docs.oracle.com/javase/jp/7/api/javax/swing/text/JTextComponent.html#setSelectionColor%28java.awt.Color%29)では、「色に `null` を設定することは、`Color.white` を設定することと同じです。」となっているが、上記のサンプルで、`"setSelectionColor(#C86464FF)"`のチェックを外して`null`を設定すると、選択の描画が一行目とそれ以降で異なる
- `HighlightPainter`
    - ハイライトの背景色は設定可能だが、文字色を変更することはできない
    - 背景色を半透明にすることは可能
    - デフォルトのハイライトの設定(`DefaultHighlighter#setDrawsLayeredHighlights(true)`)では、文字列の選択描画より手前にハイライトの矩形が表示される
        - [DefaultHighlighterの描画方法を変更する](http://terai.xrea.jp/Swing/DrawsLayeredHighlights.html)
- `StyleSheet`
    - [JEditorPaneのHTMLEditorKitにCSSを適用](http://terai.xrea.jp/Swing/StyleSheet.html)
    - `styleSheet.addRule(".highlight {color: blue; background: #FF5533; opacity: 0.5;}");`などで、文字色、背景色を変更可能
    - デフォルトの`HTMLEditorKit`は`CSS`の`opacity: 0.5`、`background: rgba(255,100,100,0.6);`などに未対応で、半透明化は不可
- 文字列選択の描画や、ハイライトの矩形より奥に描画される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextComponent#setSelectionColor(Color) (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/javax/swing/text/JTextComponent.html#setSelectionColor%28java.awt.Color%29)
- [JEditorPaneのHTMLEditorKitにCSSを適用](http://terai.xrea.jp/Swing/StyleSheet.html)
- [Highlighterで文字列をハイライト](http://terai.xrea.jp/Swing/Highlighter.html)
- [JTextAreaの背景に画像を表示](http://terai.xrea.jp/Swing/CentredBackgroundBorder.html)
- [DefaultHighlighterの描画方法を変更する](http://terai.xrea.jp/Swing/DrawsLayeredHighlights.html)

<!-- dummy comment line for breaking list -->

## コメント
