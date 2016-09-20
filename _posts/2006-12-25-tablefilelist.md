---
layout: post
category: swing
folder: TableFileList
title: JTableで文字列をクリックした場合だけセルを選択状態にする
tags: [JTable, TableCellRenderer]
author: aterai
pubdate: 2006-12-25T16:51:36+09:00
description: JTableの文字列以外の場所がクリックされた場合、そのセルが選択されないようにします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUdT6R-SI/AAAAAAAAAmE/AYebcaiE77Y/s800/TableFileList.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2010/01/make-explorer-like-jtable-file-list.html
    lang: en
comments: true
---
## 概要
`JTable`の文字列以外の場所がクリックされた場合、そのセルが選択されないようにします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUdT6R-SI/AAAAAAAAAmE/AYebcaiE77Y/s800/TableFileList.png %}

## サンプルコード
<pre class="prettyprint"><code>//SwingUtilities2.pointOutsidePrefSize(...)
private static Rectangle getCellRect2(JTable table, int row, int col) {
  TableCellRenderer tcr = table.getCellRenderer(row, col);
  Object value = table.getValueAt(row, col);
  Component cell = tcr.getTableCellRendererComponent(table, value, false, false, row, col);
  Dimension itemSize = cell.getPreferredSize();
  Rectangle cellBounds = table.getCellRect(row, col, false);
  cellBounds.width = itemSize.width;
  return cellBounds;
//   FontMetrics fm = table.getFontMetrics(table.getFont());
//   Object o = table.getValueAt(row, col);
//   int w = fm.stringWidth(o.toString()) + 16 + 2 + 2;
//   Rectangle rect = table.getCellRect(row, col, true);
//   rect.setSize(w, rect.height);
//   return rect;
}
</code></pre>

## 解説
上記のサンプルでは、`Name`カラムのセル中にあるアイコンと文字列の上でクリックされた場合のみ、そのセルが選択されるようになっています。

- `JTable.putClientProperty("Table.isFileList", Boolean.TRUE)`で、`0`列目の文字列以外がクリックされても選択されないように変更
    - `WindowsLookAndFeel`のみ？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのセルをエクスプローラ風に表示する](http://ateraimemo.com/Swing/ExplorerLikeTable.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JTable#columnAtPoint(Point)`メソッドをオーバーライドする方法では、`CPU`が`100%`になってしまうので、クリック、ドラッグした場合だけ、評価するように修正しました。 -- *aterai* 2007-04-16 (月) 18:46:39
- `JTable#getToolTipText(MouseEvent)`メソッドをオーバーライドして、`Name`カラムのセルの余白では、ツールチップも表示しないように変更しました。 -- *aterai* 2007-04-16 (月) 18:49:02
- `table.putClientProperty("Table.isFileList", Boolean.TRUE);`を使えば、`MouseListener`などもすべて必要なさそう…。 -- *aterai* 2010-01-01 (金) 02:02:50
    - `putClientProperty("Table.isFileList", Boolean.TRUE)`を使用するように変更、[JListのアイテムを範囲指定で選択](http://ateraimemo.com/Swing/RubberBanding.html)での範囲選択機能を追加。 -- *aterai* 2010-01-05 (火) 16:07:48
- <kbd>Ctrl+A</kbd>などの`JTable#selectAll()`で、`Comment`カラムが選択できるのを修正。 -- *aterai* 2010-08-25 (水) 18:41:45

<!-- dummy comment line for breaking list -->
