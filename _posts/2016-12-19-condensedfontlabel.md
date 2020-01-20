---
layout: post
category: swing
folder: CondensedFontLabel
title: Fontに長体をかけてJTextAreaで使用する
tags: [Font, JLabel, JTextArea, AffineTransform]
author: aterai
pubdate: 2016-12-19T00:45:00+09:00
description: 文字に長体をかけたフォントを生成し、これをJTextAreaなどのコンポーネントで使用します。
image: https://drive.google.com/uc?id=1uTWfknLeV-mrE81h-aAWdGPHYOpf9dEC1g
hreflang:
    href: https://java-swing-tips.blogspot.com/2017/03/make-condensed-font-and-use-it-with.html
    lang: en
comments: true
---
## 概要
文字に長体をかけたフォントを生成し、これを`JTextArea`などのコンポーネントで使用します。

{% download https://drive.google.com/uc?id=1uTWfknLeV-mrE81h-aAWdGPHYOpf9dEC1g %}

## サンプルコード
<pre class="prettyprint"><code>Font font = new Font(Font.MONOSPACED, Font.PLAIN, 18).deriveFont(
    AffineTransform.getScaleInstance(.9, 1d));
textArea.setFont(font);
</code></pre>

## 解説
- 上: `JTextArea(condensed: 0.9)`
    - 水平比率`90%`の変形をかけた長体フォントを作成して`JTextArea`に設定
- 中: `GlyphVector(condensed: 0.9)`
    - 水平比率`90%`の変形をかけた長体フォントを作成し、その`Font`から`FontMetrics`、`GlyphVector`を生成して文字列を描画
    - 一文字ごとに変形する場合は、`GlyphVector#setGlyphTransform(idx, affineTransform)`を使用する方法もある
- 下: `LineBreakMeasurer(condensed: 0.9)`
    - 水平比率`90%`の変形をかけた長体フォントを作成して`AttributedString#addAttribute(TextAttribute.FONT, font)`メソッドで属性付き文字列に設定
    - `LineBreakMeasurer`、`TextLayout`で属性付き文字列を描画

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Font#deriveFont(int, AffineTransform) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Font.html#deriveFont-int-java.awt.geom.AffineTransform-)

<!-- dummy comment line for breaking list -->

## コメント
