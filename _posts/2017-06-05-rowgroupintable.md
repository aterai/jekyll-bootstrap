---
layout: post
category: swing
folder: RowGroupInTable
title: JTableで同一内容のセルを空表示にしてグループ化を表現する
tags: [JTable, TableRowSorter, TableCellRenderer]
author: aterai
pubdate: 2017-06-05T16:09:45+09:00
description: JTableで直上のセルと同一内容のセルを空表示にして、行のグループ化を表現します。
image: https://drive.google.com/uc?id=1BtPc00VYQd5w5UwghwQc6KYrIoZCZ0W_EQ
comments: true
---
## 概要
`JTable`で直上のセルと同一内容のセルを空表示にして、行のグループ化を表現します。

{% download https://drive.google.com/uc?id=1BtPc00VYQd5w5UwghwQc6KYrIoZCZ0W_EQ %}

## サンプルコード
<pre class="prettyprint"><code>String colors = "colors";
String sports = "sports";
String food   = "food";
addRowData(model, new RowData(colors, "blue",     1));
addRowData(model, new RowData(colors, "violet",   2));
addRowData(model, new RowData(colors, "red",      3));
addRowData(model, new RowData(colors, "yellow",   4));
addRowData(model, new RowData(sports, "baseball", 23));
addRowData(model, new RowData(sports, "soccer",   22));
addRowData(model, new RowData(sports, "football", 21));
addRowData(model, new RowData(sports, "hockey",   20));
addRowData(model, new RowData(food,   "hot dogs", 10));
addRowData(model, new RowData(food,   "pizza",    11));
addRowData(model, new RowData(food,   "ravioli",  12));
addRowData(model, new RowData(food,   "bananas",  13));
// ...
class RowDataRenderer implements TableCellRenderer {
  private final TableCellRenderer renderer = new DefaultTableCellRenderer();
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    JLabel label = (JLabel) renderer.getTableCellRendererComponent(
        table, value, isSelected, hasFocus, row, column);
    label.setHorizontalAlignment(SwingConstants.LEFT);
    RowData data = (RowData) value;
    switch (table.convertColumnIndexToModel(column)) {
    case 0:
      String str = data.getGroup();
      if (row &gt; 0) {
        RowData prev = (RowData) table.getValueAt(row - 1, column);
        if (Objects.equals(prev.getGroup(), str)) {
          label.setText(" ");
          break;
        }
      }
      label.setText("+ " + str);
      break;
    case 1:
      label.setText(data.getName());
      break;
    case 2:
      label.setHorizontalAlignment(SwingConstants.RIGHT);
      label.setText(Integer.toString(data.getCount()));
      break;
    default:
      break;
    }
    return label;
  }
}
</code></pre>

## 解説
- `TableModel`
    - データとしてすべての列に`RowData`のインスタンスのコピーを設定
    - セルレンダラーで、第`0`列目に`RowData.getGroup()`の値、第`1`列目に`RowData.getName()`の値、第`2`列目に`RowData.getCount()`の値を表示するよう設定
- `RowDataRenderer`
    - `JTable`の第`0`列目で、表示上の直上のセルと`RowData.getGroup()`で取得した値が同一の場合、その値ではなく空白文字を表示するよう設定
        - 表示上の`0`行目には直上セルは存在しないので、常にそのまま`RowData.getGroup()`の値を表示する
- `TableRowSorter`
    - ソートでグループ化が変化しないように、グループ化しない第`1`列目と第`2`列目は、まず第`0`列目をソートしてからその列の比較を行う以下のような`Comparator`を使用する
        
        <pre class="prettyprint"><code>TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;&gt;(table.getModel());
        Comparator&lt;RowData&gt; c = Comparator.comparing(RowData::getGroup);
        sorter.setComparator(0, c);
        sorter.setComparator(1, c.thenComparing(RowData::getName));
        sorter.setComparator(2, c.thenComparing(RowData::getCount));
        table.setRowSorter(sorter);
</code></pre>
    - * 参考リンク [#reference]
- [java - Swing - sort a JTable's rows but keep them grouped by one column and only show the value once on top of each group - Stack Overflow](https://stackoverflow.com/questions/43011596/swing-sort-a-jtables-rows-but-keep-them-grouped-by-one-column-and-only-show-t)
- [JTableでファイルとディレクトリを別々にソート](https://ateraimemo.com/Swing/FileDirectoryComparator.html)

<!-- dummy comment line for breaking list -->

## コメント
