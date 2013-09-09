---
layout: post
title: JTextPaneで最終行に移動
category: swing
folder: CaretPosition
tags: [JTextPane, JTextComponent, Caret, Document]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-08-01

## JTextPaneで最終行に移動
`CaretPosition`を指定して`JTextPane`の最終行に移動します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTId9wo-yI/AAAAAAAAAS0/GZbZiJfMOwI/s800/CaretPosition.png)

### サンプルコード
<pre class="prettyprint"><code>Document doc = jtp.getDocument();
try{
  doc.insertString(doc.getLength(), str+"\n", null);
  jtp.setCaretPosition(doc.getLength());
}catch(BadLocationException e) {}
</code></pre>

### 解説
上記のサンプルでは、`Document`に文字列と改行(`JTextComponent`内での改行は常に`\n`であり、`System.getProperties("line.separator")`としたり、`\r\n`を考慮する必要はない)を追加した後、その`Document`の一番最後に`JTextComponent#setCaretPosition(int)`メソッドでキャレットを移動しています。

`Document`の最後ではなく、現在のキャレットの位置から、その行番号を取得したい場合は、以下のようにします。

<pre class="prettyprint"><code>public static int getLineAtCaret(JTextComponent component) {
  int caretPosition = component.getCaretPosition();
  Element root = component.getDocument().getDefaultRootElement();
  return root.getElementIndex(caretPosition)+1;
}
</code></pre>

### 参考リンク
- [JScrollPaneのオートスクロール](http://terai.xrea.jp/Swing/AutoScroll.html)
- [Swing - Line Number in JTextPane](https://forums.oracle.com/thread/1393939)
- [How to set AUTO-SCROLLING of JTEXTAREA in Java GUI? - Stack Overflow](http://stackoverflow.com/questions/1627028/how-to-set-auto-scrolling-of-jtextarea-in-java-gui)

<!-- dummy comment line for breaking list -->

### コメント
