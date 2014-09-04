---
layout: post
title: JEditorPaneのHTMLDocumentからIDでElementを取得する
category: swing
folder: HTMLAttributeID
tags: [JEditorPane, HTMLDocument, Element, HTMLEditorKit, ParserDelegator, Highlighter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-09-09

## 概要
`JEditorPane`に設定した`HTMLDocument`を検索して`id`属性を持つ`Element`を取得します。

{% download https://lh6.googleusercontent.com/-qbmJcawN3vU/UiyAF7K-MRI/AAAAAAAABz0/i1Hw-dPyqSw/s800/HTMLAttributeID.png %}

## サンプルコード
<pre class="prettyprint"><code>private void traverseElementById(Element element) {
  if(element.isLeaf()) {
    checkID(element);
  }else{
    for(int i=0;i&lt;element.getElementCount();i++) {
      Element child = element.getElement(i);
      checkID(child);
      if(!child.isLeaf()) {
        traverseElementById(child);
      }
    }
  }
}
private void checkID(Element element) {
  AttributeSet attrs = element.getAttributes();
  Object elementName = attrs.getAttribute(
      AbstractDocument.ElementNameAttribute);
  Object name = (elementName != null)
    ? null : attrs.getAttribute(StyleConstants.NameAttribute);
  HTML.Tag tag;
  if(name instanceof HTML.Tag) {
    tag = (HTML.Tag)name;
  }else{
    return;
  }
  textArea.append(String.format("%s%n", tag));
  if(tag.isBlock()) { //block
    Object bid = attrs.getAttribute(HTML.Attribute.ID);
    if(bid!=null) {
      textArea.append(String.format("block: id=%s%n", bid));
      addHighlight(element, true);
    }
  }else{ //inline
    Enumeration e = attrs.getAttributeNames();
    while(e.hasMoreElements()) {
      Object obj = attrs.getAttribute(e.nextElement());
      //System.out.println("AttributeNames: "+obj);
      if(obj instanceof AttributeSet) {
        AttributeSet a = (AttributeSet)obj;
        Object iid = a.getAttribute(HTML.Attribute.ID);
        if(iid!=null) {
          textArea.append(String.format("inline: id=%s%n", iid));
          addHighlight(element, false);
        }
      }
    }
  }
}
</code></pre>

## 解説
- `Element#getElement(id)`
    - [HTMLDocument#getElement(String)](http://docs.oracle.com/javase/jp/7/api/javax/swing/text/html/HTMLDocument.html#getElement%28java.lang.String%29)メソッドを使用して指定した`id`を持つ`Element`を取得
    - これらの`Element`は、`org.w3c.dom.Element`ではなく、`javax.swing.text.Element`インタフェースを実装する`HTMLDocument.BlockElement`など
        - `org.w3c.dom.Document#getElementById(String)`などは使用できない
    - 指定した`id`の`Element`が存在した場合、`editorPane.select(element.getStartOffset(), element.getEndOffset());`で選択
        - `element.getStartOffset()`などで取得されるオフセットは、`JEditorPane`に表示されない要素や属性は含まれない
- `Highlight Element[@id]`
    - `id`属性を持つ`Element`をハイライト表示
    - `HTMLDocument.BlockElement`などには、`html`の要素や属性が後で復元するための備考として`AttributeSet`に保存されている
        - ブロック要素とインライン要素で属性の保存されている場所が異なる
    - `DefaultHighlighter#setDrawsLayeredHighlights(false)`の場合、改行を含むハイライトや選択状態の描画がおかしくなる？
- `ParserDelegator`
    - `ParserDelegator`を使って文字列をパースし、`HTMLEditorKit.ParserCallback#handleStartTag(...)`でタグの開始を見つけたら、`MutableAttributeSet#getAttribute(HTML.Attribute.ID);`でそのタグの`id`を取得
    - `javax.swing.text.Element`とは無関係に、`JEditorPane#getText()`で取得した文字列を`html`として解析している
    - `HTMLEditorKit`が設定された`JEditorPane`から`getText()`で取得された文字列には、`<body>`などのタグが自動的に補完されているので、元の`html`テキストとは異なる点に注意

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>System.out.println("ParserDelegator");
final String id = field.getText().trim();
final String text = editorPane.getText();
ParserDelegator delegator = new ParserDelegator();
try{
  delegator.parse(new StringReader(text), new HTMLEditorKit.ParserCallback() {
    @Override public void handleStartTag(
        HTML.Tag tag, MutableAttributeSet a, int pos) {
      Object attrid = a.getAttribute(HTML.Attribute.ID);
      textArea.append(String.format("%s@id=%s%n", tag, attrid));
      if(id.equals(attrid)) {
        textArea.append(String.format("found: pos=%d%n", pos));
        int endoffs = text.indexOf('&gt;', pos);
        textArea.append(String.format("%s%n", text.substring(pos, endoffs+1)));
      }
    }
  }, Boolean.TRUE);
}catch(Exception ex) {
  ex.printStackTrace();
}
</code></pre>

## 参考リンク
- [HTMLDocument (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/javax/swing/text/html/HTMLDocument.html)
- [JTextPaneで修飾したテキストをJTextAreaにHtmlソースとして表示する](http://terai.xrea.jp/Swing/HTMLEditorKit.html)

<!-- dummy comment line for breaking list -->

## コメント
