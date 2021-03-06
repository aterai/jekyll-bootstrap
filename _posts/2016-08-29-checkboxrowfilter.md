---
layout: post
category: swing
folder: CheckBoxRowFilter
title: JTable内のチェックされた行のみ別のJTableに表示するフィルタを作成する
tags: [JTable, JCheckBox, RowFilter, TableRowSorter]
author: aterai
pubdate: 2016-08-29T01:50:21+09:00
description: JTableの各行に配置したJCheckBoxが選択されている場合、その行を別のJTableに表示するRowFilterを作成します。
image: https://drive.google.com/uc?id=1NvW9GHFg1_ENevzp5ohu8q4HugyKpkpZdw
comments: true
---
## 概要
`JTable`の各行に配置した`JCheckBox`が選択されている場合、その行を別の`JTable`に表示する`RowFilter`を作成します。

{% download https://drive.google.com/uc?id=1NvW9GHFg1_ENevzp5ohu8q4HugyKpkpZdw %}

## サンプルコード
<pre class="prettyprint"><code>TableModel model = new DefaultTableModel(data, columnNames) {
  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return getValueAt(0, column).getClass();
  }
};
JTable selector = new JTable(model);
selector.setAutoCreateRowSorter(true);
selector.getColumnModel().getColumn(0).setMaxWidth(32);

JTable viewer = new JTable(model) {
  @Override public boolean isCellEditable(int row, int column) {
    return false;
  }
};
viewer.setAutoCreateRowSorter(true);
TableColumnModel cm = viewer.getColumnModel();
cm.removeColumn(cm.getColumn(0));

TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;&gt;(model);
viewer.setRowSorter(sorter);
sorter.setRowFilter(new RowFilter&lt;TableModel, Integer&gt;() {
  @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    return Objects.equals(entry.getModel().getValueAt(
        entry.getIdentifier(), 0), Boolean.TRUE);
  }
});
model.addTableModelListener(e -&gt; {
  if (e.getType() == TableModelEvent.UPDATE) {
    sorter.allRowsChanged();
    // sorter.modelStructureChanged();
  }
});
</code></pre>

## 解説
上記のサンプルでは、選択用と表示用の`2`つの`JTable`を作成しています。どちらの`JTable`もモデルは同じものを共有していますが、以下のような異なる設定をしています。

- 選択用の`JTable`:
    - `0`列目の値(`Boolean`)を`JCheckBox`で編集可能になるよう設定
- 表示用の`JTable`:
    - `JTable#isCellEditable(...)`をオーバーライドしてモデルではなく`JTable`側で編集不可を設定
    - `Boolean`値を持つモデルの`0`列目(表示は`JCheckBox`)を`TableColumnModel#removeColumn(...)`メソッドで非表示に設定
    - `RowFilter#include(...)`をオーバーライドして、`0`列目の値が`Boolean.TRUE`の場合、その行を表示する`RowFilter`を作成して設定
- 共有の`TableModel`:
    - `TableModelListener`を設定し、`JCheckBox`の選択などでモデルが更新された場合、`TableRowSorter#allRowsChanged()`を実行してフィルタリングの更新を行う

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのRowFilterを一旦解除してソート](https://ateraimemo.com/Swing/ResetRowFilter.html)

<!-- dummy comment line for breaking list -->

## コメント
