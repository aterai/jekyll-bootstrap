---
layout: post
category: swing
folder: PointInsidePrefSize
title: JTableのセル内でリンクだけHover可能にする
tags: [JTable, TableCellRenderer, MouseListener, URL]
author: aterai
pubdate: 2011-08-29T14:18:50+09:00
description: JTableのセル内ではなく、内部のリンク上にカーソルがきた場合だけHoverするように設定します。
image: https://lh3.googleusercontent.com/-OQfktkzVBD4/Tlsepf4ePZI/AAAAAAAABBQ/bikhWupFHEk/s800/PointInsidePrefSize.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/02/hyperlink-in-jtable-cell.html
    lang: en
comments: true
---
## 概要
`JTable`のセル内ではなく、内部のリンク上にカーソルがきた場合だけ`Hover`するように設定します。

{% download https://lh3.googleusercontent.com/-OQfktkzVBD4/Tlsepf4ePZI/AAAAAAAABBQ/bikhWupFHEk/s800/PointInsidePrefSize.png %}

## サンプルコード
<pre class="prettyprint"><code>//@see SwingUtilities2.pointOutsidePrefSize(...)
private static boolean pointInsidePrefSize(JTable table, Point p) {
  int row = table.rowAtPoint(p);
  int col = table.columnAtPoint(p);
  TableCellRenderer tcr = table.getCellRenderer(row, col);
  Object value = table.getValueAt(row, col);
  Component cell = tcr.getTableCellRendererComponent(
    table, value, false, false, row, col);
  Dimension itemSize = cell.getPreferredSize();
  Insets i = ((JComponent) cell).getInsets();
  Rectangle cellBounds = table.getCellRect(row, col, false);
  cellBounds.width = itemSize.width - i.right - i.left;
  cellBounds.translate(i.left, i.top);
  return cellBounds.contains(p);
}
private boolean isRollover = false;
private static boolean isURLColumn(JTable table, int column) {
  return column &gt;= 0 &amp;&amp; table.getColumnClass(column).equals(URL.class);
}
@Override public void mouseMoved(MouseEvent e) {
  JTable table = (JTable) e.getSource();
  Point pt = e.getPoint();
  int prev_row = row;
  int prev_col = col;
  boolean prev_ro = isRollover;
  row = table.rowAtPoint(pt);
  col = table.columnAtPoint(pt);
  isRollover = isURLColumn(table, col) &amp;&amp; pointInsidePrefSize(table, pt);
  if ((row == prev_row &amp;&amp; col == prev_col &amp;&amp; isRollover == prev_ro) ||
      (!isRollover &amp;&amp; !prev_ro)) {
    return;
  }
  // &gt;&gt;&gt;&gt; HyperlinkCellRenderer.java
  Rectangle repaintRect;
  if (isRollover) {
    Rectangle r = table.getCellRect(row, col, false);
    repaintRect = prev_ro ?
      r.union(table.getCellRect(prev_row, prev_col, false)) : r;
  } else { //if (prev_ro) {
    repaintRect = table.getCellRect(prev_row, prev_col, false);
  }
  table.repaint(repaintRect);
  // &lt;&lt;&lt;&lt;
  //table.repaint();
}
@Override public void mouseExited(MouseEvent e)  {
  JTable table = (JTable) e.getSource();
  if (isURLColumn(table, col)) {
    table.repaint(table.getCellRect(row, col, false));
    row = -1;
    col = -1;
    isRollover = false;
  }
}
@Override public void mouseClicked(MouseEvent e) {
  JTable table = (JTable) e.getSource();
  Point pt = e.getPoint();
  int ccol = table.columnAtPoint(pt);
  if (isURLColumn(table, ccol) &amp;&amp; pointInsidePrefSize(table, pt)) {
    int crow = table.rowAtPoint(pt);
    URL url = (URL) table.getValueAt(crow, ccol);
    System.out.println(url);
    try {
      Desktop.getDesktop().browse(url.toURI());
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
}
</code></pre>

## 解説
`SwingUtilities2.pointOutsidePrefSize(...)`を参考にして、セルの表示に使用するコンポーネント(`JLabel`)の推奨サイズの範囲内にカーソルがあるかどうかを比較するメソッドを作成しています。`JTable`に追加した`MouseListener`でこれを使用し、`URL`の文字列を`Hover`状態に変更するか、またはクリックされたかなどを判断しています。

## 参考リンク
- [JTableのセルにHyperlinkを表示](https://ateraimemo.com/Swing/HyperlinkInTableCell.html)
- [Htmlで修飾した文字列のクリップ](https://ateraimemo.com/Swing/ClippedHtmlLabel.html)
- [JTableで文字列をクリックした場合だけセルを選択状態にする](https://ateraimemo.com/Swing/TableFileList.html)

<!-- dummy comment line for breaking list -->

## コメント
- `SwingSet3`の`HyperlinkCellRenderer.java`を参考にして、再描画するセルの範囲を最適化、ついでに`HyperlinkCellRenderer#checkIfPointInsideHyperlink(Point)`ではセルコンポーネントの内余白(`Insets`)が考慮されていないので修正。 -- *aterai* 2011-09-16 (金) 18:45:29

<!-- dummy comment line for breaking list -->
