---
layout: post
title: JTableにソートされないサマリー行を表示する
category: swing
folder: FixedSummaryRow
tags: [JTable, TableRowSorter, RowFilter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-04-27

## JTableにソートされないサマリー行を表示する
`JTable`の行をソートしても、常に最終行にサマリーを表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTM63Y0s8I/AAAAAAAAAZ8/o3lbm9QBcIs/s800/FixedSummaryRow.png)

### サンプルコード
<pre class="prettyprint"><code>public JTable makeTable() {
  final JTable table = new JTable(model);
  final RowFilter&lt;TableModel,Integer&gt; filter = new RowFilter&lt;TableModel,Integer&gt;() {
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
  for(int i=0;i&lt;col.getColumnCount();i++) {
    final TableCellRenderer r = table.getDefaultRenderer(model.getColumnClass(i));
    col.getColumn(i).setCellRenderer(new TableCellRenderer() {
      public Component getTableCellRendererComponent(JTable table, Object value,
                       boolean isSelected, boolean hasFocus, int row, int column) {
        JLabel l;
        if(row==model.getRowCount()-2) {
          int i = getSum(table.convertColumnIndexToModel(column));
          l = (JLabel)r.getTableCellRendererComponent(
                table, i, isSelected, hasFocus, row, column);
          l.setBackground(Color.ORANGE);
        }else{
          l = (JLabel)r.getTableCellRendererComponent(
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

### 解説
上記のサンプルでは、以下のようにしてサマリー行を作成しています。

- モデルの先頭と末尾にダミー行を追加
    - 値は、`Integer.MIN_VALUE`と、`Integer.MAX_VALUE`でソートしても先頭か末尾にくるようにしておく
- ソートでどちらかが先頭行(表示上)になった場合、フィルターでこれを非表示にする

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Sorting Table with Summary Row - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/date/20070812)
- [Swing - Sort rows in JTable except the last row](https://forums.oracle.com/thread/1356123)

<!-- dummy comment line for breaking list -->

### コメント
