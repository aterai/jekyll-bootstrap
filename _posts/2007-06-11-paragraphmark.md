---
layout: post
category: swing
folder: ParagraphMark
title: JEditorPaneで改行を表示
tags: [JEditorPane, StyledEditorKit]
author: aterai
pubdate: 2007-06-11T17:28:09+09:00
description: JEditorPaneのパラグラフ終了位置に改行を意味する図形を追加表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQ3cf9HLI/AAAAAAAAAgQ/gIbt2d-Hz7k/s800/ParagraphMark.png
comments: true
---
## 概要
`JEditorPane`のパラグラフ終了位置に改行を意味する図形を追加表示します。[Swing - JTextPane View Problem](https://community.oracle.com/thread/1374478)から、ソースコードの大部分を引用しています。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQ3cf9HLI/AAAAAAAAAgQ/gIbt2d-Hz7k/s800/ParagraphMark.png %}

## サンプルコード
<pre class="prettyprint"><code>class MyEditorKit extends StyledEditorKit {
  @Override public ViewFactory getViewFactory() {
    return new MyViewFactory();
  }
}

class MyViewFactory implements ViewFactory {
  @Override public View create(Element elem) {
    String kind = elem.getName();
    if (kind != null) {
      if (kind.equals(AbstractDocument.ContentElementName)) {
        return new LabelView(elem);
      } else if (kind.equals(AbstractDocument.ParagraphElementName)) {
        return new ParagraphWithEopmView(elem);
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
}

class ParagraphWithEopmView extends ParagraphView {
  private static final Color pc = new Color(120, 130, 110);
  public ParagraphWithEopmView(Element elem) {
    super(elem);
  }
  @Override public void paint(Graphics g, Shape allocation) {
    super.paint(g, allocation);
    paintCustomParagraph(g, allocation);
  }
  private void paintCustomParagraph(Graphics g, Shape a) {
    try {
      Shape paragraph = modelToView(getEndOffset(), a, Position.Bias.Backward);
      Rectangle r = (paragraph == null) ? a.getBounds() : paragraph.getBounds();
      int x = r.x;
      int y = r.y;
      int h = r.height;
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setColor(MARK_COLOR);
      // paragraph mark
      g2.drawLine(x + 1, y + h / 2, x + 1, y + h - 4);
      g2.drawLine(x + 2, y + h / 2, x + 2, y + h - 5);
      g2.drawLine(x + 3, y + h - 6, x + 3, y + h - 6);
      g2.dispose();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
</code></pre>

## 解説
`StyledEditorKit`を継承する`EditorKit`を作成し、これを`JEditorPane#setEditorKit`メソッドで、`JEditorPane`に設定しています。

この`EditorKit`は、`Element`がパラグラフ(`AbstractDocument.ParagraphElementName`)の場合、改行記号を末尾に追加で描画する`View`を返す`ViewFactory`を生成します。

## 参考リンク
- [Swing - JTextPane View Problem](https://community.oracle.com/thread/1374478)
- [JTextPaneで全角スペースやタブを可視化](https://ateraimemo.com/Swing/WhitespaceMark.html)

<!-- dummy comment line for breaking list -->

## コメント
- 行の折り返しが発生すると、改行記号が縦長になるバグを修正。 -- *aterai* 2007-09-21 (金) 17:05:03

<!-- dummy comment line for breaking list -->
