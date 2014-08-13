---
layout: post
title: Caretの点滅を停止する
category: swing
folder: BlinkRate
tags: [JTextComponent, Caret, JTextField]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-02-21

## Caretの点滅を停止する
`JTextComponent`の`Caret`が点滅する速さを変更します。


{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TWH8aAgoyiI/AAAAAAAAA1o/J-ljyl_h_i8/s800/BlinkRate.png %}

### サンプルコード
<pre class="prettyprint"><code>((DefaultCaret)textField.getCaret()).setBlinkRate(0);
</code></pre>

### 解説
上記のサンプルでは、`JTextField#getCaret()`で取得した`CaretにsetBlinkRate(0)`で点滅間隔を`0`と設定し、キャレットが点滅しないように設定しています。

### 参考リンク
- [Bug ID: 6289635 getDesktopProperty("awt.cursorBlinkRate") returns null](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6289635)

<!-- dummy comment line for breaking list -->

### コメント
