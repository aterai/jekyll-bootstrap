---
layout: post
category: swing
folder: StyleConstants
title: JTextPaneに修飾した文字列を挿入
tags: [JTextPane, StyledDocument]
author: aterai
pubdate: 2004-01-12
description: JTextPaneに、スタイル付けした文字列を挿入して、ログ風に表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTT31r9lEI/AAAAAAAAAlI/7PqL2Aa3UJU/s800/StyleConstants.png
comments: true
---
## 概要
`JTextPane`に、スタイル付けした文字列を挿入して、ログ風に表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTT31r9lEI/AAAAAAAAAlI/7PqL2Aa3UJU/s800/StyleConstants.png %}

## サンプルコード
<pre class="prettyprint"><code>StyledDocument doc = jtp.getStyledDocument();
Style def = doc.getStyle(StyleContext.DEFAULT_STYLE);
Style error = doc.addStyle("error", def);
StyleConstants.setForeground(error, Color.RED);
</code></pre>

<pre class="prettyprint"><code>private void append(String str, boolean flg) {
  String style = flg ? StyleContext.DEFAULT_STYLE : "error";
  StyledDocument doc = jtp.getStyledDocument();
  try {
    doc.insertString(doc.getLength(), str + "\n", doc.getStyle(style));
  } catch (BadLocationException e) {
    e.printStackTrace();
  }
}
</code></pre>

## 解説
予め設定しておいたエラー表示用の文字属性スタイルを`StyledDocument#getStyle("error")`で取得し、このスタイルと文字列と合わせて`Document#insertString(...)`メソッドで挿入しています。

## 参考リンク
- [Using Text Components (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/text.html)

<!-- dummy comment line for breaking list -->

## コメント
- 一々、`SimpleAttributeSet`を生成していたのを修正。 -- *aterai* 2010-12-06 (月) 22:24:36

<!-- dummy comment line for breaking list -->
