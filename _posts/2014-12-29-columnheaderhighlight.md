---
layout: post
category: swing
folder: ColumnHeaderHighlight
title: JTableHeaderのハイライト表示
tags: [JTable, JTableHeader, TableCellRenderer, ListSelectionModel]
author: aterai
pubdate: 2014-12-29T00:02:59+09:00
description: JTableのセルが選択されている場合、そのセルが存在するカラムヘッダにフォーカスを設定します。
image: https://lh6.googleusercontent.com/-g01DwekSNRs/VKAYFMHxxEI/AAAAAAAANtw/OwiMQuJ3gQY/s800/ColumnHeaderHighlight.png
comments: true
---
## 概要
`JTable`のセルが選択されている場合、そのセルが存在するカラムヘッダにフォーカスを設定します。

{% download https://lh6.googleusercontent.com/-g01DwekSNRs/VKAYFMHxxEI/AAAAAAAANtw/OwiMQuJ3gQY/s800/ColumnHeaderHighlight.png %}

## サンプルコード
<pre class="prettyprint"><code>class ColumnHeaderRenderer implements TableCellRenderer {
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected,
      boolean hasFocus, int row, int column) {
    TableCellRenderer r = table.getTableHeader().getDefaultRenderer();
    ListSelectionModel csm = table.getColumnModel().getSelectionModel();
    boolean f = csm.getLeadSelectionIndex() == column ? true : hasFocus;
    return r.getTableCellRendererComponent(table, value, isSelected, f, row, column);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTable`のセルが選択されてリードインデックスが存在する(`-1`ではない)場合はフォーカスありで自身を描画するヘッダセルレンダラーを作成し、これを`TableColumn#setHeaderRenderer(...)`ですべてのカラムに設定しています。

- `JTable`内にあるセルの選択状態が変更されても、`JTableHeader`の描画には影響しない
    - このため、`TableColumnModel`から取得した`SelectionModel`に`ListSelectionListener`を追加して、リードインデックスの移動イベントが発生するたび、`JTableHeader#repaint()`を呼び出して`JTableHeader`のフォーカス変更を描画し直すように設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.getColumnModel().getSelectionModel().addListSelectionListener(e -&gt; {
  header.repaint();
});
</code></pre>

## 参考リンク
- [TableColumn#setHeaderRenderer(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/table/TableColumn.html#setHeaderRenderer-javax.swing.table.TableCellRenderer-)

<!-- dummy comment line for breaking list -->

## コメント
