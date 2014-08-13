---
layout: post
title: JEditorPaneのHTMLDocumentに要素を追加する
category: swing
folder: InsertHtmlText
tags: [JEditorPane, HTMLDocument]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-04-28

## JEditorPaneのHTMLDocumentに要素を追加する
`JEditorPane`の`HTMLDocument`から`table`要素を取得し、その子要素として`tr`要素などを追加します。


{% download https://lh5.googleusercontent.com/-hU9bkPgb4Q8/U10bg5XoDfI/AAAAAAAACEI/BJrmelBz93M/s800/InsertHtmlText.png %}

### サンプルコード
<pre class="prettyprint"><code>HTMLDocument doc = (HTMLDocument) editor.getDocument();
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

### 解説
- `insertAfterStart`
    - `table`要素の開始タグの後に、子要素として`tr`要素を追加
    - 注: 挿入後のスクロールがおかしい場合がある？
- `insertBeforeEnd`
    - `table`要素の終了タグの前に、子要素として`tr`要素を追加

<!-- dummy comment line for breaking list -->

### コメント
- メモ: [HTMLEditorKit.html#insertHTML(HTMLDocument, int, String, int, int, HTML.Tag)](http://docs.oracle.com/javase/8/docs/api/javax/swing/text/html/HTMLEditorKit.html#insertHTML-javax.swing.text.html.HTMLDocument-int-java.lang.String-int-int-javax.swing.text.html.HTML.Tag-)よりは簡単？速度などは？ -- [aterai](http://terai.xrea.jp/aterai.html) 2014-04-28 (月) 15:00:16

<!-- dummy comment line for breaking list -->

