---
layout: post
category: swing
folder: LineFocusTable
title: JTableのフォーカスを一行全体に適用する
tags: [JTable, Focus, Border]
author: aterai
pubdate: 2006-06-05T12:54:07+09:00
description: JTableのフォーカスをセルではなく、一行全体に掛かっているように表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPOarzqiI/AAAAAAAAAdo/uwFLFlU_EpI/s800/LineFocusTable.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/05/change-border-of-focused-row-in-jtable.html
    lang: en
comments: true
---
## 概要
`JTable`のフォーカスをセルではなく、一行全体に掛かっているように表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPOarzqiI/AAAAAAAAAdo/uwFLFlU_EpI/s800/LineFocusTable.png %}

## サンプルコード
<pre class="prettyprint"><code>enum Type { START, END }

class DotBorder extends EmptyBorder {
  private static final BasicStroke DASHED = new BasicStroke(
      1f, BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER,
      10f, new float[] {1f}, 0f);
  private static final Color DOT_COLOR = new Color(200, 150, 150);
  public final Set&lt;Type&gt; type = EnumSet.noneOf(Type.class);

  protected DotBorder(int top, int left, int bottom, int right) {
    super(top, left, bottom, right);
  }
  @Override public boolean isBorderOpaque() {
    return true;
  }
  @Override public void paintBorder(
      Component c, Graphics g, int x, int y, int w, int h) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.translate(x, y);
    g2.setPaint(DOT_COLOR);
    g2.setStroke(DASHED);
    if (type.contains(Type.START)) {
      g2.drawLine(0, 0, 0, h);
    }
    if (type.contains(Type.END)) {
      g2.drawLine(w - 1, 0, w - 1, h);
    }
    if (c.getBounds().x % 2 == 0) {
      g2.drawLine(0, 0, w, 0);
      g2.drawLine(0, h - 1, w, h - 1);
    } else {
      g2.drawLine(1, 0, w, 0);
      g2.drawLine(1, h - 1, w, h - 1);
    }
    g2.dispose();
  }
}
</code></pre>

## 解説
通常の`JTable`では、`JTable#setRowSelectionAllowed(true)`を設定すると選択状態は一行ごとになりますが、フォーカスはセル単位で描画されます。上記のサンプルでは、セルレンダラーの描画メソッド内で`JTable#getSelectionModel()#getLeadSelectionIndex()`を使用してフォーカスが存在するセルを取得し、独自ラベルを使って最初と最後のセルの垂直の点線、途中のセルの水平点線を追加することでフォーカスが一行全体に適用されているように見せています。

カラム幅を変更するなどの操作を行ってもセル上下の水平点線のつなぎ目でドットが重ならないようにするため、偶数奇数ドット目のどちらで始まっているかを判断して開始位置のオフセットを決定しています。

## 参考リンク
- [JTableの次行にTabキーでフォーカスを移動](https://ateraimemo.com/Swing/SelectNextRow.html)

<!-- dummy comment line for breaking list -->

## コメント
