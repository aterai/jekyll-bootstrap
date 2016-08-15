---
layout: post
category: swing
folder: LineSpacing
title: JEditorPaneやJTextPaneに行間を設定する
tags: [JEditorPane, JTextPane, StyledEditorKit]
author: aterai
pubdate: 2009-11-02T12:51:40+09:00
description: JEditorPaneやJTextPaneに行間を設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPYZn_u9I/AAAAAAAAAd4/5-1ThpWwM5U/s800/LineSpacing.png
comments: true
---
## 概要
`JEditorPane`や`JTextPane`に行間を設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPYZn_u9I/AAAAAAAAAd4/5-1ThpWwM5U/s800/LineSpacing.png %}

## サンプルコード
<pre class="prettyprint"><code>class BottomInsetEditorKit extends StyledEditorKit {
  @Override public ViewFactory getViewFactory() {
    return new ViewFactory() {
      @Override public View create(Element elem) {
        String kind = elem.getName();
        if (kind != null) {
          if (kind.equals(AbstractDocument.ContentElementName)) {
            return new LabelView(elem);
          } else if (kind.equals(AbstractDocument.ParagraphElementName)) {
            return new javax.swing.text.ParagraphView(elem) {
              @Override protected short getBottomInset() { return 5; }
            };
          } else if (kind.equals(AbstractDocument.SectionElementName)) {
            return new BoxView(elem, View.Y_AXIS);
          } else if (kind.equals(StyleConstants.ComponentElementName)) {
            return new ComponentView(elem);
          } else if (kind.equals(StyleConstants.IconElementName)) {
            return new IconView(elem);
          }
        }
        return new LabelView(elem);
      }
    };
  }
}
</code></pre>

## 解説
- 上: `StyleConstants.setLineSpacing`で、行間を指定した`AttributeSet`を作成し、`JTextPane#setParagraphAttributes`で設定
    - フォントサイズ相対の行間になる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>SimpleAttributeSet a = new SimpleAttributeSet();
StyleConstants.setLineSpacing(a, .5f);
//StyleConstants.setSpaceAbove(a, 5f);
//StyleConstants.setSpaceBelow(a, 5f);
//StyleConstants.setLeftIndent(a, 5f);
//StyleConstants.setRightIndent(a, 5f);
editor1.setParagraphAttributes(a, true);
setDummyText(editor1);
</code></pre>

- 下: `ParagraphView#getBottomInset`をオーバーライドして、固定の行間をピクセルで指定
    - フォントサイズに関係なく、アキ`5px`

<!-- dummy comment line for breaking list -->

- - - -
- スタイルシートで`line-height`を指定しても反映されない(`line-height`は、モデル化されているが、現在は描画されない)
    - [対応しているCSSプロパティ一覧 - CSS (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/CSS.html)
- ブロックレベルで一行だけ固定の行間が指定したい場合は、`margin-bottom`が使用可能

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>StyleSheet styleSheet = new StyleSheet();
styleSheet.addRule("body {font-size: 24pt; line-height: 2.0}");
styleSheet.addRule(".test {margin-bottom: 2pt; padding-bottom: 1px; }");
//XXX: styleSheet.addRule("span {color: white; display:inline-block; margin-bottom: 10pt;}");
HTMLEditorKit htmlEditorKit = new HTMLEditorKit();
htmlEditorKit.setStyleSheet(styleSheet);
editor1.setEditorKit(htmlEditorKit);
editor1.setText("&lt;html&gt;&lt;body&gt;&lt;div class='test'&gt;12&lt;br /&gt;a&lt;br /&gt;n&lt;font size='32'&gt;123&lt;br /&gt;sd&lt;/font&gt;&lt;/div&gt;&lt;/body&gt;&lt;/html&gt;");
</code></pre>

## コメント
