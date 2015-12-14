---
layout: post
category: swing
folder: FixedSummaryRow
title: JTableにソートされないサマリー行を表示する
tags: [JTable, TableRowSorter, RowFilter]
author: aterai
pubdate: 2009-04-27T14:50:32+09:00
description: JTableの行をソートしても、常に最終行にサマリーを表示します。
comments: true
---
## 概要
`JTable`の行をソートしても、常に最終行にサマリーを表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTM63Y0s8I/AAAAAAAAAZ8/o3lbm9QBcIs/s800/FixedSummaryRow.png %}

## サンプルコード
<pre class="prettyprint"><code>public JTable makeTable() {
  final JTable table = new JTable(model);
  final RowFilter&lt;TableModel, Integer&gt; filter = new RowFilter&lt;&gt;() {
    @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
      int i0 = table.convertRowIndexToView(entry.getIdentifier());
      return i0 != 0;
    }
  };
  final TableRowSorter&lt;TableModel&gt; s = new TableRowSorter&lt;TableModel&gt;(model) {
    @Override public void toggleSortOrder(int column) {
      RowFilter&lt;? super TableModel, ? super Integer&gt; f = getRowFilter();
      setRowFilter(null);
      super.toggleSortOrder(column);
      setRowFilter(f);
    }
  };
  s.setRowFilter(filter);
  //s.setSortsOnUpdates(true);
  s.toggleSortOrder(1);
  table.setRowSorter(s);

  TableColumnModel col = table.getColumnModel();
  for (int i = 0; i &lt; col.getColumnCount(); i++) {
    TableCellRenderer r = table.getDefaultRenderer(model.getColumnClass(i));
    col.getColumn(i).setCellRenderer(new TableCellRenderer() {
      @Override public Component getTableCellRendererComponent(
          JTable table, Object value,
          boolean isSelected, boolean hasFocus, int row, int column) {
        JLabel l;
        if (row == model.getRowCount() - 2) {
          int i = getSum(table.convertColumnIndexToModel(column));
          l = (JLabel) r.getTableCellRendererComponent(
              table, i, isSelected, hasFocus, row, column);
          l.setBackground(Color.ORANGE);
        } else {
          l = (JLabel) r.getTableCellRendererComponent(
              table, value, isSelected, hasFocus, row, column);
          l.setBackground(Color.WHITE);
        }
        l.setForeground(Color.BLACK);
        return l;
      }
    });
  }
  return table;
}
</code></pre>

## 解説
上記のサンプルでは、以下のようにしてサマリー行を作成しています。

- モデル(`Integer`)の先頭と末尾にダミー行を追加
    - 値は、`Integer.MIN_VALUE`と、`Integer.MAX_VALUE`でソートしても先頭か末尾にくるようにしておく
- ソートでどちらかが表示上の先頭行になった場合、フィルタでこれを非表示にする

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Sorting Table with Summary Row - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/date/20070812)
- [Swing - Sort rows in JTable except the last row](https://community.oracle.com/thread/1356123)

<!-- dummy comment line for breaking list -->

## コメント
