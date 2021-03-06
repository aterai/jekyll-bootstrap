---
layout: post
category: swing
folder: CharacterAttributes
title: JTextPane内の文字に適用されているスタイル情報を取得する
tags: [JTextPane, AttributeSet, StyledDocument, StyleConstants]
author: aterai
pubdate: 2020-03-09T18:26:14+09:00
description: JTextPaneのCaret位置に存在する文字に適用されているスタイルの属性セットを取得します。
image: https://drive.google.com/uc?id=1LVro6tfG-PGrN80BWtx-Fmwupx2D3t0w
comments: true
---
## 概要
`JTextPane`の`Caret`位置に存在する文字に適用されているスタイルの属性セットを取得します。

{% download https://drive.google.com/uc?id=1LVro6tfG-PGrN80BWtx-Fmwupx2D3t0w %}

## サンプルコード
<pre class="prettyprint"><code>StyleContext style = new StyleContext();
StyledDocument doc = new DefaultStyledDocument(style);
// ...
MutableAttributeSet attr1 = new SimpleAttributeSet();
attr1.addAttribute(StyleConstants.Bold, Boolean.TRUE);
attr1.addAttribute(StyleConstants.Foreground, Color.RED);
doc.setCharacterAttributes(4, 11, attr1, false);

MutableAttributeSet attr2 = new SimpleAttributeSet();
attr2.addAttribute(StyleConstants.Underline, Boolean.TRUE);
doc.setCharacterAttributes(10, 20, attr2, false);

JTextPane textPane = new JTextPane(doc);
textPane.addCaretListener(e -&gt; {
  if (e.getDot() == e.getMark()) {
    AttributeSet a = doc.getCharacterElement(e.getDot()).getAttributes();
    append("isBold: " + StyleConstants.isBold(a));
    append("isUnderline: " + StyleConstants.isUnderline(a));
    append("Foreground: " + StyleConstants.getForeground(a));
    append("FontFamily: " + StyleConstants.getFontFamily(a));
    append("FontSize: " + StyleConstants.getFontSize(a));
    append("Font: " + style.getFont(a));
    append("----");
  }
});
</code></pre>

## 解説
- `JTextPane`に`CaretListener`を設定してカーソル位置の`CharacterElement`を取得
- `Element#getAttributes()`メソッドを使用してこの文字が保持する属性セットを取得
- 取得した属性セットに以下の属性キーが存在するかなどを`StyleConstants`のスタティックメソッドを使用してテスト
    - `isBold`、`isUnderline`、`Foreground`、`FontFamily`、`FontSize`
    - `FontFamily`ではなく`Font`自体を取得する場合は[StyleContext#getFont(AttributeSet)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/StyleContext.html#getFont-javax.swing.text.AttributeSet-)を使用する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - How can I get the font(isBold,isUnderline) of a specific character in jTextPane? - Stack Overflow](https://stackoverflow.com/questions/60410481/how-can-i-get-the-fontisbold-isunderline-of-a-specific-character-in-jtextpane)
- [JTextArea内にあるCaret位置の文字のUnicodeコードポイントを表示する](https://ateraimemo.com/Swing/CodePointAtCaret.html)

<!-- dummy comment line for breaking list -->

## コメント
