---
layout: post
category: swing
folder: SortColumnColor
title: JTableでソート中のカラムセル色
tags: [JTable, TableCellRenderer, TableRowSorter]
author: aterai
pubdate: 2008-04-07T12:47:33+09:00
description: どのカラムでソートされているかを表示するために、セルの背景色を変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTZ75OnPI/AAAAAAAAAkU/k4lx4c2XKK8/s800/SortColumnColor.png
comments: true
---
## 概要
どのカラムでソートされているかを表示するために、セルの背景色を変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTZ75OnPI/AAAAAAAAAkU/k4lx4c2XKK8/s800/SortColumnColor.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  private final Color evenColor = new Color(255, 250, 250);
  @Override public Component prepareRenderer(
      TableCellRenderer tcr, int row, int column) {
    Component c = super.prepareRenderer(tcr, row, column);
    if (isRowSelected(row)) {
      c.setForeground(getSelectionForeground());
      c.setBackground(getSelectionBackground());
    } else {
      c.setForeground(getForeground());
      c.setBackground(isSortingColumn(column) ? evenColor
                                              : getBackground());
    }
    return c;
  }
  private boolean isSortingColumn(int column) {
    RowSorter&lt;? extends TableModel&gt; sorter = getRowSorter();
    if (Objects.nonNull(sorter)) {
      List&lt;? extends RowSorter.SortKey&gt; keys = sorter.getSortKeys();
      if (keys.isEmpty()) {
        return false;
      }
      if (column == convertColumnIndexToView(keys.get(0).getColumn())) {
        return true;
      }
    }
    return false;
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JTable#getSortKeys()#getSortKeys()`で、ソート中のカラムを取得し、第一キーのカラムセル色を変更しています。

## コメント
- このサンプルでは、`NimbusLookAndFeel`などの場合、`BooleanCellRenderer`(`JCheckBox`を使った`Boolean`用のデフォルトセルレンダラー)を使った列の背景色を変更できない。 -- *aterai* 2013-01-15 (火) 16:33:54

<!-- dummy comment line for breaking list -->
