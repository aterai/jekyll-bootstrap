---
layout: post
category: swing
folder: InsertHtmlText
title: JEditorPaneのHTMLDocumentに要素を追加する
tags: [JEditorPane, HTMLDocument]
author: aterai
pubdate: 2014-04-28T15:00:16+09:00
description: JEditorPaneのHTMLDocumentからtable要素を取得し、その子要素としてtr要素などを追加します。
image: https://lh5.googleusercontent.com/-hU9bkPgb4Q8/U10bg5XoDfI/AAAAAAAACEI/BJrmelBz93M/s800/InsertHtmlText.png
comments: true
---
## 概要
`JEditorPane`の`HTMLDocument`から`table`要素を取得し、その子要素として`tr`要素などを追加します。

{% download https://lh5.googleusercontent.com/-hU9bkPgb4Q8/U10bg5XoDfI/AAAAAAAACEI/BJrmelBz93M/s800/InsertHtmlText.png %}

## サンプルコード
<pre class="prettyprint"><code>String HTML_TEXT = "&lt;html&gt;&lt;body&gt;head&lt;table id='log' border='1'&gt;&lt;/table&gt;tail&lt;/body&gt;&lt;/html&gt;";
HTMLEditorKit htmlEditorKit = new HTMLEditorKit();
JEditorPane editor = new JEditorPane();
editor.setEditorKit(htmlEditorKit);
editor.setText(HTML_TEXT);

HTMLDocument doc = (HTMLDocument) editor.getDocument();
Element element = doc.getElement("log");
String ROW_TEXT = "&lt;tr bgColor='%s'&gt;&lt;td&gt;%s&lt;/td&gt;&lt;td&gt;%s&lt;/td&gt;&lt;/tr&gt;";
Date d = new Date();
String tag = String.format(ROW_TEXT, "#FFFFFF", "insertBeforeEnd", d.toString());
try {
  doc.insertBeforeEnd(element, tag);
} catch (BadLocationException | IOException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
- `insertAfterStart`
    - `table`要素の開始タグの後に、子要素として`tr`要素を追加
    - 注: 挿入後のスクロールで、表示が乱れる場合がある
- `insertBeforeEnd`
    - `table`要素の終了タグの前に、子要素として`tr`要素を追加

<!-- dummy comment line for breaking list -->

## 参考リンク
- [HTMLDocument#insertAfterStart(...) (Java Platform SE 8)](https://docs.oracle.coma/javase/jp/8/docs/api/javax/swing/text/html/HTMLDocument.html#insertAfterStart-javax.swing.text.Element-java.lang.String-)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: [HTMLEditorKit.html#insertHTML(HTMLDocument, int, String, int, int, HTML.Tag) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/HTMLEditorKit.html#insertHTML-javax.swing.text.html.HTMLDocument-int-java.lang.String-int-int-javax.swing.text.html.HTML.Tag-)よりは簡単？速度的にどちらが速いかなどは未検証。 -- *aterai* 2014-04-28 (月) 15:00:16

<!-- dummy comment line for breaking list -->
