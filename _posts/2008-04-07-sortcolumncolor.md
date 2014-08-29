---
layout: post
title: JTableでソート中のカラムセル色
category: swing
folder: SortColumnColor
tags: [JTable, TableCellRenderer, TableRowSorter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-04-07

## JTableでソート中のカラムセル色
どのカラムでソートされているかを表示するために、セルの背景色を変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTZ75OnPI/AAAAAAAAAkU/k4lx4c2XKK8/s800/SortColumnColor.png %}

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  private final Color evenColor = new Color(255, 250, 250);
  @Override public Component prepareRenderer(
      TableCellRenderer tcr, int row, int column) {
    Component c = super.prepareRenderer(tcr, row, column);
    if(isRowSelected(row)) {
      c.setForeground(getSelectionForeground());
      c.setBackground(getSelectionBackground());
    }else{
      c.setForeground(getForeground());
      c.setBackground(isSortingColumn(column) ? evenColor
                                              : getBackground());
    }
    return c;
  }
  private boolean isSortingColumn(int column) {
    RowSorter sorter = getRowSorter();
    if(sorter!=null) {
      java.util.List list = sorter.getSortKeys();
      if(list.size()&gt;0) {
        RowSorter.SortKey key0 = (RowSorter.SortKey)list.get(0);
        if(column==convertColumnIndexToView(key0.getColumn())) {
          return true;
        }
      }
    }
    return false;
  }
};
</code></pre>

### 解説
上記のサンプルでは、`JTable#getSortKeys()#getSortKeys()`で、ソート中のカラムを取得し、第一キーのカラムセル色を変更しています。

### コメント
- このサンプルでは、`NimbusLookAndFeel`などの場合、`BooleanCellRenderer`(`JCheckBox`を使った`Boolean`用のデフォルトセルレンダラー)を使った列の背景色を変更できない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-01-15 (火) 16:33:54

<!-- dummy comment line for breaking list -->

