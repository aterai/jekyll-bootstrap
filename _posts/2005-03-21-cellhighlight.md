---
layout: post
category: swing
folder: CellHighlight
title: JTableのセルのハイライト
tags: [JTable, TableCellRenderer, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2005-03-21T07:27:38+09:00
description: JTableのセル上にマウスカーソルが存在する場合、その背景色を変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIqY941CI/AAAAAAAAATI/gk-sbbRE5gw/s800/CellHighlight.png
comments: true
---
## 概要
`JTable`のセル上にマウスカーソルが存在する場合、その背景色を変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIqY941CI/AAAAAAAAATI/gk-sbbRE5gw/s800/CellHighlight.png %}

## サンプルコード
<pre class="prettyprint"><code>class HighlightListener extends MouseAdapter {
  private int row = -1;
  private int col = -1;
  private final JTable table;
  public HighlightListener(JTable table) {
    this.table = table;
  }
  public boolean isHighlightableCell(int row, int column) {
    return this.row == row &amp;&amp; this.col == column;
  }
  @Override public void mouseMoved(MouseEvent e) {
    Point pt = e.getPoint();
    row = table.rowAtPoint(pt);
    col = table.columnAtPoint(pt);
    if (row &lt; 0 || col &lt; 0) {
      row = -1;
      col = -1;
    }
    table.repaint();
  }
  @Override public void mouseExited(MouseEvent e) {
    row = -1;
    col = -1;
    table.repaint();
  }
}
</code></pre>
<pre class="prettyprint"><code>class HighlightRenderer extends DefaultTableCellRenderer {
  private final HighlightListener highlighter;
  public HighlightRenderer(JTable table) {
    super();
    highlighter = new HighlightListener(table);
    table.addMouseListener(highlighter);
    table.addMouseMotionListener(highlighter);
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
    setHorizontalAlignment((value instanceof Number) ? RIGHT : LEFT);
    if (highlighter.isHighlightableCell(row, column)) {
      setBackground(Color.RED);
    } else {
      setBackground(isSelected ? table.getSelectionBackground() : table.getBackground());
    }
    return this;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTable`に`MouseListener`、`MouseMotionListener`を追加してマウスカーソルが乗っているセルを取得し、セルレンダラーでこれを参照してその背景色を変更しています。

- - - -
`JTable#prepareRenderer(...)`メソッドをオーバーライドする方法もあります。

<pre class="prettyprint"><code>class HighlightableTable extends JTable {
  private final HighlightListener highlighter;
  public HighlightableTable(TableModel model) {
    super(model);
    highlighter = new HighlightListener(this);
    addMouseListener(highlighter);
    addMouseMotionListener(highlighter);
  }
  @Override public Component prepareRenderer(TableCellRenderer r, int row, int column) {
    Component c = super.prepareRenderer(r, row, column);
    if (highlighter.isHighlightableCell(row, column)) {
      c.setBackground(Color.RED);
    } else if (isRowSelected(row)) {
      c.setBackground(getSelectionBackground());
    } else {
      c.setBackground(Color.WHITE);
    }
    return c;
  }
}
</code></pre>

## 参考リンク
- [JListのセルをカーソル移動でロールオーバー](https://ateraimemo.com/Swing/RollOverListener.html)

<!-- dummy comment line for breaking list -->

## コメント
- ソースコードの整理、スクリーンショットの更新 -- *aterai* 2008-03-14 (金) 16:38:10

<!-- dummy comment line for breaking list -->
