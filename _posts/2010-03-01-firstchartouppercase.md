---
layout: post
title: DocumentFilterで先頭文字を大文字に変換する
category: swing
folder: FirstCharToUpperCase
tags: [JTextField, DocumentFilter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-03-01

## DocumentFilterで先頭文字を大文字に変換する
`DocumentFilter`を使って、文字列の先頭が常に大文字になるように設定します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMuU7OQ-I/AAAAAAAAAZo/jnaPTnPJY4w/s800/FirstCharToUpperCase.png)

### サンプルコード
<pre class="prettyprint"><code>class FirstCharToUpperCaseDocumentFilter extends DocumentFilter {
  private final JTextComponent textArea;
  public FirstCharToUpperCaseDocumentFilter(JTextComponent textArea) {
    super();
    this.textArea = textArea;
  }
  @Override public void insertString(
      FilterBypass fb, int offset, String text, AttributeSet attrs)
      throws BadLocationException {
    if(text==null) return;
    replace(fb, offset, 0, text, attrs);
  }
  @Override public void remove(
      FilterBypass fb, int offset, int length) throws BadLocationException {
    Document doc = fb.getDocument();
    if(offset==0 &amp;&amp; doc.getLength()-length&gt;0) {
      fb.replace(0, length+1, doc.getText(length, 1).toUpperCase(), null);
      textArea.setCaretPosition(0);
    }else{
      fb.remove(offset, length);
    }
  }
  @Override public void replace(
      FilterBypass fb, int offset, int length, String text, AttributeSet attrs)
      throws BadLocationException {
    if(offset==0 &amp;&amp; text!=null &amp;&amp; text.length()&gt;0) {
      text = text.substring(0,1).toUpperCase()+text.substring(1);
    }
    fb.replace(offset, length, text, attrs);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JTextField`に入力された文字列の先頭一文字が、常に大文字になるように変換する`DocumentFilter`を設定しています。

- - - -
以下のように、`JFormattedTextField` + `MaskFormatter`を使うと、先頭文字を削除した場合などで空白文字が挿入される(長さが決まっているから？)。

<pre class="prettyprint"><code>JFormattedTextField field1 = new JFormattedTextField(new MaskFormatter("ULLLLLLLLLL"));
</code></pre>

### コメント
