---
layout: post
title: JEditorPaneで改行を表示
category: swing
folder: ParagraphMark
tags: [JEditorPane, StyledEditorKit]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-06-11

## JEditorPaneで改行を表示
`JEditorPane`で改行記号を表示します。[Swing - JTextPane View Problem](https://forums.oracle.com/thread/1374478)から、ソースコードの大部分を引用しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.ggpht.com/_9Z4BYR88imo/TQTQ3cf9HLI/AAAAAAAAAgQ/gIbt2d-Hz7k/s800/ParagraphMark.png)

### サンプルコード
<pre class="prettyprint"><code>class MyEditorKit extends StyledEditorKit {
  @Override public ViewFactory getViewFactory() {
    return new MyViewFactory();
  }
}

class MyViewFactory implements ViewFactory {
  @Override public View create(Element elem) {
    String kind = elem.getName();
    if(kind!=null) {
      if(kind.equals(AbstractDocument.ContentElementName)) {
        return new LabelView(elem);
      }else if(kind.equals(AbstractDocument.ParagraphElementName)) {
        return new MyParagraphView(elem);
      }else if(kind.equals(AbstractDocument.SectionElementName)) {
        return new BoxView(elem, View.Y_AXIS);
      }else if(kind.equals(StyleConstants.ComponentElementName)) {
        return new ComponentView(elem);
      }else if(kind.equals(StyleConstants.IconElementName)) {
        return new IconView(elem);
      }
    }
    return new LabelView(elem);
  }
}

class MyParagraphView extends ParagraphView {
  private static final Color pc = new Color(120, 130, 110);
  public MyParagraphView(Element elem) {
    super(elem);
  }
  @Override public void paint(Graphics g, Shape allocation) {
    super.paint(g, allocation);
    paintCustomParagraph(g, allocation);
  }
  private void paintCustomParagraph(Graphics g, Shape a) {
    try {
      Shape paragraph = modelToView(getEndOffset(), a, Position.Bias.Backward);
      Rectangle r = (paragraph==null)?a.getBounds():paragraph.getBounds();
      int x = r.x;
      int y = r.y;
      int h = r.height;
      Color old = g.getColor();
      g.setColor(pc);
      //paragraph mark
      g.drawLine(x+1, y+h/2, x+1, y+h-4);
      g.drawLine(x+2, y+h/2, x+2, y+h-5);
      g.drawLine(x+3, y+h-6, x+3, y+h-6);
      g.setColor(old);
    }catch(Exception e) { e.printStackTrace(); }
  }
}
</code></pre>

### 解説
`StyledEditorKit`を継承する`EditorKit`を作成し、これを`JEditorPane#setEditorKit`メソッドで、`JEditorPane`に設定しています。

この`EditorKit`は、`Element`が段落(`AbstractDocument.ParagraphElementName`)の場合、独自の改行記号を追加で描画する`View`を返す`ViewFactory`を生成しています。

### 参考リンク
- [Swing - JTextPane View Problem](https://forums.oracle.com/thread/1374478)
- [JTextPaneで全角スペースやタブを可視化](http://terai.xrea.jp/Swing/WhitespaceMark.html)

<!-- dummy comment line for breaking list -->

### コメント
- 行の折り返しが発生すると、改行記号が縦長になるバグを修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-09-21 (金) 17:05:03

<!-- dummy comment line for breaking list -->
