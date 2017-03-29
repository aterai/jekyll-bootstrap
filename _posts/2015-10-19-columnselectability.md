---
layout: post
category: swing
folder: ColumnSelectability
title: JTableで選択可能な列を制限する
tags: [JTable, TableColumn]
author: aterai
pubdate: 2015-10-19T00:12:40+09:00
description: JTableの任意の列でマウスクリックなどによる選択ができないように制限します。
image: https://lh3.googleusercontent.com/-kvjA0RzkNxQ/ViOrBhPfAiI/AAAAAAAAOEc/meMBIUCKAmc/s800-Ic42/ColumnSelectability.png
comments: true
---
## 概要
`JTable`の任意の列でマウスクリックなどによる選択ができないように制限します。

{% download https://lh3.googleusercontent.com/-kvjA0RzkNxQ/ViOrBhPfAiI/AAAAAAAAOEc/meMBIUCKAmc/s800-Ic42/ColumnSelectability.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  private boolean isColumnSelectable(int column) {
    return convertColumnIndexToModel(column) == 0;
  }
  @Override public void changeSelection(
      int rowIndex, int columnIndex, boolean toggle, boolean extend) {
    if (!isColumnSelectable(columnIndex)) {
      return;
    }
    super.changeSelection(rowIndex, columnIndex, toggle, extend);
  }
  @Override public boolean isCellEditable(int row, int column) {
    return isColumnSelectable(column);
  }
  @Override public Component prepareRenderer(
      TableCellRenderer renderer, int row, int column) {
    if (isColumnSelectable(column)) {
      return super.prepareRenderer(renderer, row, column);
    } else {
      return renderer.getTableCellRendererComponent(
          this, getValueAt(row, column), false, false, row, column);
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、第`0`列目のみ選択・編集可能にし、残りの列はマウスクリックやカーソル移動などで選択できないように、`JTable#changeSelection(...)`、`JTable#changeSelection(...)`をオーバーライドしています。

- `JTable#isCellEditable(...)`は、編集不可にするためにオーバーライド
    - 選択不可で編集可能な列も設定可能
- `JTable#prepareRenderer(...)`は、列を並べ替えた場合、フォーカスが選択不可の列に移動することを避けるためにオーバーライド
    - `table.getTableHeader().setReorderingAllowed(false);`として列の並べ替えを禁止している場合は不要
- メモ: `table.putClientProperty("Table.isFileList", Boolean.TRUE);`で、第`0`列目の文字列のみ選択可能になる
    - [JTableで文字列をクリックした場合だけセルを選択状態にする](http://ateraimemo.com/Swing/TableFileList.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableで文字列をクリックした場合だけセルを選択状態にする](http://ateraimemo.com/Swing/TableFileList.html)
- [JTableの列を編集可、かつ選択不可に設定](http://ateraimemo.com/Swing/DisableColumnSelection.html)
    - こちらは、選択不可だが、編集は可能な列を設定する場合のサンプル

<!-- dummy comment line for breaking list -->

## コメント
