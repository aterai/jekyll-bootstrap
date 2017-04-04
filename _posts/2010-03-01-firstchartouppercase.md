---
layout: post
category: swing
folder: FirstCharToUpperCase
title: DocumentFilterで先頭文字を大文字に変換する
tags: [JTextField, DocumentFilter]
author: aterai
pubdate: 2010-03-01T12:38:41+09:00
description: DocumentFilterを使って、文字列の先頭が常に大文字になるように設定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMuU7OQ-I/AAAAAAAAAZo/jnaPTnPJY4w/s800/FirstCharToUpperCase.png
comments: true
---
## 概要
`DocumentFilter`を使って、文字列の先頭が常に大文字になるように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMuU7OQ-I/AAAAAAAAAZo/jnaPTnPJY4w/s800/FirstCharToUpperCase.png %}

## サンプルコード
<pre class="prettyprint"><code>class FirstCharToUpperCaseDocumentFilter extends DocumentFilter {
  private final JTextComponent textField;
  protected FirstCharToUpperCaseDocumentFilter(JTextComponent textField) {
    super();
    this.textField = textField;
  }
  @Override public void remove(
      DocumentFilter.FilterBypass fb, int offset, int length)
      throws BadLocationException {
    Document doc = fb.getDocument();
    if (offset == 0 &amp;&amp; doc.getLength() - length &gt; 0) {
      fb.replace(length, 1, doc.getText(length, 1).toUpperCase(Locale.ENGLISH), null);
      textField.setCaretPosition(offset);
    }
    fb.remove(offset, length);
  }
  @Override public void replace(
      DocumentFilter.FilterBypass fb, int offset, int length, String text, AttributeSet attrs)
      throws BadLocationException {
    String str = text;
    if (offset == 0 &amp;&amp; Objects.nonNull(text) &amp;&amp; !text.isEmpty()) {
      str = text.substring(0, 1).toUpperCase(Locale.ENGLISH) + text.substring(1);
    }
    fb.replace(offset, length, str, attrs);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTextField`に入力された文字列の先頭一文字が、常に大文字になるように変換する`DocumentFilter`を設定しています。

- - - -
以下のように、`JFormattedTextField` + `MaskFormatter`を使うと、~~先頭文字を削除した場合などで空白文字が挿入される(長さが決まっているから？)~~ 指定した文字列長に足りない場合などでアンドゥが実行される。

<pre class="prettyprint"><code>JFormattedTextField field1 = new JFormattedTextField(new MaskFormatter("ULLLLLLLLLL"));
</code></pre>

## コメント
