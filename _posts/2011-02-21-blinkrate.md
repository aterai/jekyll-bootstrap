---
layout: post
category: swing
folder: BlinkRate
title: Caretの点滅を停止する
tags: [JTextComponent, Caret, JTextField]
author: aterai
pubdate: 2011-02-21T14:49:17+09:00
description: JTextComponentのCaretが点滅する速さを変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TWH8aAgoyiI/AAAAAAAAA1o/J-ljyl_h_i8/s800/BlinkRate.png
comments: true
---
## 概要
`JTextComponent`の`Caret`が点滅する速さを変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TWH8aAgoyiI/AAAAAAAAA1o/J-ljyl_h_i8/s800/BlinkRate.png %}

## サンプルコード
<pre class="prettyprint"><code>((DefaultCaret) textField.getCaret()).setBlinkRate(0);
</code></pre>

## 解説
上記のサンプルでは、`JTextField#getCaret()`で取得した`Caret`に、`setBlinkRate(...)`メソッドでミリ秒単位の点滅間隔を設定しています。

- 上: デフォルト
- 下: `Caret#setBlinkRate(0)`と`0`を設定することで、キャレットの点滅を停止

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Caret#setBlinkRate(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Caret.html#setBlinkRate-int-)
- [Bug ID: 6289635 getDesktopProperty("awt.cursorBlinkRate") returns null](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6289635)

<!-- dummy comment line for breaking list -->

## コメント
