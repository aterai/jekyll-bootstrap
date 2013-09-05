---
layout: post
title: JTableで文字列をクリックした場合だけセルを選択状態にする
category: swing
folder: TableFileList
tags: [JTable, TableCellRenderer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-12-25

## JTableで文字列をクリックした場合だけセルを選択状態にする
`JTable`の文字列以外の場所がクリックされた場合、そのセルが選択されないようにします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTUdT6R-SI/AAAAAAAAAmE/AYebcaiE77Y/s800/TableFileList.png)

### サンプルコード
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

### 解説
上記のサンプルでは、`Name`カラムのセル中にあるアイコンと文字列の上でクリックされた場合のみ、そのセルが選択されるようになっています。

- ~~`JTable#columnAtPoint(Point)`メソッドをオーバーライドし `MouseAdapter`を設定し、`Name`カラムのセルの文字列上でクリックされたかどうかを判別~~
- ~~クリックされたポイントがそのセルの文字列上に無い場合、別のセル(幅`0`のダミーカラム)がクリックされたように偽装し、現在の選択状態を解除~~
- `JTable.putClientProperty("Table.isFileList", Boolean.TRUE)`で、`0`列目の文字列以外がクリックされても選択されないように変更
    - `WindowsLookAndFeel`のみ？
- ~~範囲選択の場合は、文字列の幅を自前で計算~~

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableのセルをエクスプローラ風に表示する](http://terai.xrea.jp/Swing/ExplorerLikeTable.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JTable#columnAtPoint(Point)`メソッドをオーバーライドする方法では、`CPU`が`100%`になってしまうので、クリック、ドラッグした場合だけ、評価するように修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-04-16 (月) 18:46:39
- `JTable#getToolTipText(MouseEvent)`メソッドをオーバーライドして、`Name`カラムのセルの余白では、ツールチップも表示しないように変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-04-16 (月) 18:49:02
- `table.putClientProperty("Table.isFileList", Boolean.TRUE);`を使えば、`MouseListener`などもすべて必要なさそう…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-01 (金) 02:02:50
    - `putClientProperty("Table.isFileList", Boolean.TRUE)`を使用するように変更、[JListのアイテムを範囲指定で選択](http://terai.xrea.jp/Swing/RubberBanding.html)での範囲選択機能を追加。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-05 (火) 16:07:48
- <kbd>Ctrl</kbd>+<kbd>A</kbd>などの`JTable#selectAll()`で、`Comment`カラムが選択できるのを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-08-25 (水) 18:41:45

<!-- dummy comment line for breaking list -->
