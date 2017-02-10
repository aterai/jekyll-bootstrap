---
layout: post
category: swing
folder: CaretPosition
title: JTextPaneで最終行に移動
tags: [JTextPane, JTextComponent, Caret, Document]
author: aterai
pubdate: 2005-08-01T02:22:59+09:00
description: CaretPositionを指定してJTextPaneの最終行に移動します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTId9wo-yI/AAAAAAAAAS0/GZbZiJfMOwI/s800/CaretPosition.png
comments: true
---
## 概要
`CaretPosition`を指定して`JTextPane`の最終行に移動します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTId9wo-yI/AAAAAAAAAS0/GZbZiJfMOwI/s800/CaretPosition.png %}

## サンプルコード
<pre class="prettyprint"><code>Document doc = jtp.getDocument();
try {
  doc.insertString(doc.getLength(), text + "\n", null);
  jtp.setCaretPosition(doc.getLength());
} catch (BadLocationException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
上記のサンプルでは、`Document`に文字列と改行(`JTextComponent`内での改行は常に`\n`であり、`System.getProperties("line.separator")`としたり、`\r\n`を考慮する必要はない)を追加した後、その`Document`の一番最後に`JTextComponent#setCaretPosition(int)`メソッドで`Caret`を移動しています。

- メモ
    - 現在の`Caret`位置の行番号を取得する
        
        <pre class="prettyprint"><code>public static int getLineAtCaret(JTextComponent component) {
          int caretPosition = component.getCaretPosition();
          Element root = component.getDocument().getDefaultRootElement();
          return root.getElementIndex(caretPosition) + 1;
        }
</code></pre>
    - * 参考リンク [#reference]
- [JScrollPaneのオートスクロール](http://ateraimemo.com/Swing/AutoScroll.html)
- [Swing - Line Number in JTextPane](https://community.oracle.com/thread/1393939)
- [How to set AUTO-SCROLLING of JTEXTAREA in Java GUI? - Stack Overflow](http://stackoverflow.com/questions/1627028/how-to-set-auto-scrolling-of-jtextarea-in-java-gui)

<!-- dummy comment line for breaking list -->

## コメント
