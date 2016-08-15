---
layout: post
category: swing
folder: NonEditableLine
title: JTextAreaの一部を編集不可にする
tags: [JTextArea, DocumentFilter, Highlighter]
author: aterai
pubdate: 2010-02-22T14:50:22+09:00
description: JTextAreaの一部の行を編集不可になるよう設定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQW4ZQhAI/AAAAAAAAAfc/JkImmzMvG6I/s800/NonEditableLine.png
comments: true
---
## 概要
`JTextArea`の一部の行を編集不可になるよう設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQW4ZQhAI/AAAAAAAAAfc/JkImmzMvG6I/s800/NonEditableLine.png %}

## サンプルコード
<pre class="prettyprint"><code>class NonEditableLineDocumentFilter extends DocumentFilter {
  @Override public void insertString(
      FilterBypass fb, int offset, String string, AttributeSet attr)
      throws BadLocationException {
    if (Objects.nonNull(string)) {
      replace(fb, offset, 0, string, attr);
    }
  }
  @Override public void remove(
      FilterBypass fb, int offset, int length)
      throws BadLocationException {
    replace(fb, offset, length, "", null);
  }
  @Override public void replace(
      FilterBypass fb, int offset, int length, String text, AttributeSet attrs)
      throws BadLocationException {
    Document doc = fb.getDocument();
    if (doc.getDefaultRootElement().getElementIndex(offset) &lt; 2) {
      return;
    }
    fb.replace(offset, length, text, attrs);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`DocumentFilter`を使って、`JTextArea`の一行目と二行目で追加、削除などの編集ができないように設定しています。

<pre class="prettyprint"><code>((AbstractDocument) textArea.getDocument()).setDocumentFilter(new NonEditableLineDocumentFilter());
</code></pre>

- - - -
一行目と二行目の背景色は、編集不可のための`DocumentFilter`とは関係なく、`Highlighter`を使って別途設定しています。
<pre class="prettyprint"><code>try {
  Highlighter hilite = textArea.getHighlighter();
  Document doc = textArea.getDocument();
  Element root = doc.getDefaultRootElement();
  for (int i = 0; i &lt; 2; i++) {
    Element elem = root.getElement(i);
    hilite.addHighlight(elem.getStartOffset(),
                        elem.getEndOffset() - 1,
                        highlightPainter);
  }
} catch (BadLocationException ble) {
  ble.printStackTrace();
}
</code></pre>

## 参考リンク
- [Document Guard - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/date/20050622)
- [JTextAreaの最終行だけ編集可能になるよう設定する](http://ateraimemo.com/Swing/LastLineEditableTextArea.html)

<!-- dummy comment line for breaking list -->

## コメント
