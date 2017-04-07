---
layout: post
category: swing
folder: DisableColumnSelection
title: JTableの列を編集可、かつ選択不可に設定
tags: [JTable, ListSelectionModel]
author: aterai
pubdate: 2016-06-20T00:15:58+09:00
description: JTableの指定した列を編集は可能、ただし選択することができなくなるように設定します。
image: https://lh3.googleusercontent.com/-goXZsRlvEdI/V2a1zMod1iI/AAAAAAAAOcA/ZX8_9YIkBwYS45vkDbZRBa6wf2PyjUS1QCCo/s800/DisableColumnSelection.png
comments: true
---
## 概要
`JTable`の指定した列を編集は可能、ただし選択することができなくなるように設定します。

{% download https://lh3.googleusercontent.com/-goXZsRlvEdI/V2a1zMod1iI/AAAAAAAAOcA/ZX8_9YIkBwYS45vkDbZRBa6wf2PyjUS1QCCo/s800/DisableColumnSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table1 = new JTable(model) {
  @Override public void changeSelection(
      int rowIndex, int columnIndex, boolean toggle, boolean extend) {
    if (convertColumnIndexToModel(columnIndex) != 0) {
      return;
    }
    super.changeSelection(rowIndex, columnIndex, toggle, extend);
  }
  @Override public Component prepareRenderer(
      TableCellRenderer renderer, int row, int column) {
    if (convertColumnIndexToModel(column) != 0) {
      return renderer.getTableCellRendererComponent(
          this, getValueAt(row, column), false, false, row, column);
    }
    return super.prepareRenderer(renderer, row, column);
  }
  //TEST:
  //@Override public Component prepareEditor(TableCellEditor editor, int row, int column) {
  //  Component c = super.prepareEditor(editor, row, column);
  //  c.setBackground(getBackground());
  //  return c;
  //}
};

JTable table2 = new JTable(model) {
  @Override public void changeSelection(
      int rowIndex, int columnIndex, boolean toggle, boolean extend) {
    if (convertColumnIndexToModel(columnIndex) != 0) {
      return;
    }
    super.changeSelection(rowIndex, columnIndex, toggle, extend);
  }
};
table2.setCellSelectionEnabled(true);
table2.getColumnModel().setSelectionModel(new DefaultListSelectionModel() {
  @Override public boolean isSelectedIndex(int index) {
    return table2.convertColumnIndexToModel(index) == 0;
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JTable#changeSelection(...)`をオーバーライドするなどの方法で、`0`列目以外を編集は可能だが、、選択不可となるように設定しています。

- 上: `Override JTable#prepareRenderer(...)`
    - `JTable#prepareRenderer(...)`をオーバーライドし、`0`列目以外は選択状態を描画しないように設定
    - `Boolean`のデフォルトセルエディタ(`JCheckBox`)の背景色を修正していないので、クリック時に選択されたように見えてしまう場合がある(<kbd>Ctrl+A</kbd>などで全選択した後など)
- 下: `table.setCellSelectionEnabled(true);` + `Override ListSelectionModel#isSelectedIndex(...)`
    - カラムモデルに`ListSelectionModel#isSelectedIndex(...)`をオーバーライドした`ListSelectionModel`を設定し、`0`列目以外は選択されないように設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableで選択可能な列を制限する](http://ateraimemo.com/Swing/ColumnSelectability.html)
    - こちらは編集、選択ともに不可の列を設定する場合のサンプル
- [java - JTable disable Column Selection - Stack Overflow](https://stackoverflow.com/questions/37690017/jtable-disable-column-selection/37741006#37741006)

<!-- dummy comment line for breaking list -->

## コメント
