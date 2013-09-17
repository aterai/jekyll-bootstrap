---
layout: post
title: JEditorPaneのHTMLタグにToolTipTextを設定する
category: swing
folder: ElementAttribute
tags: [JEditorPane, JTextPane, HTMLDocument, JToolTip, HyperlinkListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-08-08

## JEditorPaneのHTMLタグにToolTipTextを設定する
`JEditorPane`で`div`や`span`タグの`title`属性を`ToolTip`で表示できるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-3HQ42PjgBfs/Tj97O_2VS6I/AAAAAAAABAc/EnrOPXrJxfE/s800/ElementAttribute.png)

### サンプルコード
<pre class="prettyprint"><code>JTextPane editor1 = new JTextPane() {
  private transient Position.Bias[] bias = new Position.Bias[1];
  @Override public String getToolTipText(MouseEvent e) {
    String title = super.getToolTipText(e);
    JEditorPane editor = (JEditorPane) e.getSource();
    if(!editor.isEditable()) {
      Point pt = new Point(e.getX(), e.getY());
      int pos = editor.getUI().viewToModel(editor, pt, bias);
      if(bias[0] == Position.Bias.Backward &amp;&amp; pos &gt; 0) {
        pos--;
      }
      if(pos &gt;= 0 &amp;&amp;(editor.getDocument() instanceof HTMLDocument)) {
        HTMLDocument hdoc = (HTMLDocument)editor.getDocument();
        Element elem = hdoc.getCharacterElement(pos);
        if(elem != null) {
          AttributeSet a = elem.getAttributes();
          AttributeSet span = (AttributeSet)a.getAttribute(HTML.Tag.SPAN);
          if(span != null) {
            title = (String)span.getAttribute(HTML.Attribute.TITLE);
          }
        }
      }
    }
    return title;
  }
};
editor1.setEditorKit(new HTMLEditorKit());
</code></pre>

### 解説
上記のサンプルでは、`JEditorPane`で`HTMLEditorKit`を使った場合の`ToolTip`表示についてテストしています。`img`タグの`alt`属性は自動的に`ToolTip`表示され、リンクは`HyperlinkListener`を追加することで`ToolTip`を変更することができます。

<pre class="prettyprint"><code>private final String htmlText =
  "&lt;html&gt;&lt;body&gt;" +
  "&lt;span style='background:#88ff88;' title='tooltip: span[@title]'&gt;span&lt;/span&gt;&lt;br /&gt;" +
  "&lt;div title='tooltip: div[@title]'&gt;div tag: div div div div&lt;/div&gt;" +
  "&lt;div style='padding: 2 24;'&gt;&lt;img src='"+ image +"' alt='16x16 favicon' /&gt;&amp;nbsp;" +
  "&lt;a href='http://terai.xrea.jp/'&gt;Java Swing Tips&lt;/a&gt;&lt;/div&gt;" +
  "&lt;/body&gt;&lt;/html&gt;";
</code></pre>

- 上: `span`タグの`title`属性を`ToolTip`で表示
    - `HTMLEditorKit`の`LinkController`クラスを参考に`JEditorPane#getToolTipText(MouseEvent)`をオーバーライド
- 下: `dvi`タグの`title`属性を`ToolTip`で表示
    - `ImageView#getToolTipText(...)`を参考
    - `HyperlinkListener`を追加

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class TooltipEditorKit extends HTMLEditorKit {
  @Override public ViewFactory getViewFactory() {
    return new HTMLFactory() {
      @Override public View create(Element elem) {
        AttributeSet attrs = elem.getAttributes();
        Object elementName = attrs.getAttribute(
            AbstractDocument.ElementNameAttribute);
        Object o = (elementName != null)
          ? null : attrs.getAttribute(StyleConstants.NameAttribute);
        if(o instanceof HTML.Tag) {
          HTML.Tag kind = (HTML.Tag) o;
          if(kind == HTML.Tag.DIV) {
            return new BlockView(elem, View.Y_AXIS) {
              @Override public String getToolTipText(
                  float x, float y, Shape allocation) {
                String s = super.getToolTipText(x, y, allocation);
                if(s==null) {
                  s = (String)getElement().getAttributes().getAttribute(
                      HTML.Attribute.TITLE);
                }
                return s;
              }
            };
          }
        }
        return super.create(elem);
      }
    };
  }
}
</code></pre>

### 参考リンク
- [JEditorPaneにリンクを追加](http://terai.xrea.jp/Swing/HyperlinkListener.html)

<!-- dummy comment line for breaking list -->

### コメント
