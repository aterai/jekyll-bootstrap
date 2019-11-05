---
layout: post
category: swing
folder: WholeLineHighlightPainter
title: JEditorPaneで選択ハイライトの描画範囲を変更する
tags: [JEditorPane, DefaultCaret, StyledEditorKit, HighlightPainter]
author: aterai
pubdate: 2019-09-16T01:29:20+09:00
description: JEditorPaneのCaretを変更して改行のみのパラグラフ上でも選択ハイライトが描画されるよう変更します。
image: https://drive.google.com/uc?id=1bwJ-w1zk4C_2cpxyF6t0Ky6K3Grn1Z8T
hreflang:
    href: https://java-swing-tips.blogspot.com/2019/09/change-drawing-area-of-selected.html
    lang: en
comments: true
---
## 概要
`JEditorPane`の`Caret`を変更して改行のみのパラグラフ上でも選択ハイライトが描画されるよう変更します。

{% download https://drive.google.com/uc?id=1bwJ-w1zk4C_2cpxyF6t0Ky6K3Grn1Z8T %}

## サンプルコード
<pre class="prettyprint"><code>class ParagraphMarkHighlightPainter extends DefaultHighlightPainter {
  protected ParagraphMarkHighlightPainter(Color color) {
    super(color);
  }

  @Override public Shape paintLayer(
      Graphics g, int offs0, int offs1,
      Shape bounds, JTextComponent c, View view) {
    Shape s = super.paintLayer(g, offs0, offs1, bounds, c, view);
    Rectangle r = s.getBounds();
    if (r.width - 1 &lt;= 0) {
      g.fillRect(r.x + r.width, r.y, r.width + r.height / 2, r.height);
    }
    return s;
  }
}

class WholeLineHighlightPainter extends DefaultHighlightPainter {
  protected WholeLineHighlightPainter(Color color) {
    super(color);
  }

  @Override public Shape paintLayer(
      Graphics g, int offs0, int offs1,
      Shape bounds, JTextComponent c, View view) {
    Rectangle rect = bounds.getBounds();
    rect.width = c.getSize().width;
    return super.paintLayer(g, offs0, offs1, rect, c, view);
  }
}
</code></pre>

## 解説
- `DefaultHighlightPainter`
    - 改行マークのみのパラグラフは`1px`のみ選択ハイライト描画される
- `ParagraphMarkHighlightPainter`
    - 改行マークのみのパラグラフ上にも選択ハイライトを行の高さの半分描画する
- `WholeLineHighlightPainter`
    - 文字列選択が改行以降も継続する場合は行全体を選択ハイライト描画する
    - `JEditorPane`ではなく、`JTextArea`の場合は`DefaultHighlighter#setDrawsLayeredHighlights(false)`が使用可能
        - [DefaultHighlighterの描画方法を変更する](https://ateraimemo.com/Swing/DrawsLayeredHighlights.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextComponentの選択ハイライトを変更](https://ateraimemo.com/Swing/SelectionHighlightPainter.html)
- [JEditorPaneで改行を表示](https://ateraimemo.com/Swing/ParagraphMark.html)
- [JTextAreaでのCaretによる選択状態表示を維持する](https://ateraimemo.com/Swing/CaretSelectionHighlight.html)
- [DefaultHighlighterの描画方法を変更する](https://ateraimemo.com/Swing/DrawsLayeredHighlights.html)

<!-- dummy comment line for breaking list -->

## コメント
