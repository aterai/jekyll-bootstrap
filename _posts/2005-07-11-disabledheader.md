---
layout: post
category: swing
folder: DisabledHeader
title: JTableHeaderのカラムを選択不可にする
tags: [JTable, JTableHeader, TableSorter]
author: aterai
pubdate: 2005-07-11T09:12:06+09:00
description: JTableHeaderのカラムを選択不可にして、ソートなどを禁止します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK7ZrULPI/AAAAAAAAAWw/fwuY_EwXQsM/s800/DisabledHeader.png
comments: true
---
## 概要
`JTableHeader`のカラムを選択不可にして、ソートなどを禁止します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK7ZrULPI/AAAAAAAAAWw/fwuY_EwXQsM/s800/DisabledHeader.png %}

## サンプルコード
<pre class="prettyprint"><code>public class SortButtonRenderer extends JButton implements TableCellRenderer {
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected,
      boolean hasFocus, int row, int column) {
    JButton button = this;
    if (!isEnabledAt(column)) {
      button.setText((value == null) ? "" : value.toString());
      button.getModel().setEnabled(false);
      return button;
    }
    // ...

private final HashMap dmap = new HashMap();
public boolean isEnabledAt(int col) {
  Integer oi = Integer.valueOf(col);
  if (dmap.containsKey(oi)) {
    Boolean b = (Boolean) dmap.get(oi);
    return b.booleanValue();
  } else {
    return true;
  }
}
</code></pre>

## 解説
サンプルでは、`0`列目のカラムヘッダを常に選択不可に、`3`列目はチェックボックスで選択できるかどうかを切り替えるようにしています。

`HashMap`に選択不可にするカラムヘッダを設定し、レンダラーがヘッダを描画するときにそれを`setEnabled(false)`しています。

`TableSorter.java`を使用してソートしている場合は、`TableSorter`のインナークラスの`MouseHandler`を、例えば以下のように変更すると、任意のカラムをクリックしてもソートされなくなります。

<pre class="prettyprint"><code>private class MouseHandler extends MouseAdapter {
  @Override public void mouseClicked(MouseEvent e) {
    JTableHeader h = (JTableHeader) e.getSource();
    TableColumnModel columnModel = h.getColumnModel();
    int viewColumn = columnModel.getColumnIndexAtX(e.getX());
    int column = columnModel.getColumn(viewColumn).getModelIndex();
    // ここを変更
    if (isSortableIndex(column)) { // column != -1 ) {
      int status = getSortingStatus(column);
      if (!e.isControlDown()) {
        cancelSorting();
      }
      status = status + (e.isShiftDown() ? -1 : 1);
      status = (status + 4) % 3 - 1; // signed mod, returning {-1, 0, 1}
      setSortingStatus(column, status);
    }
  }
}
</code></pre>

- - - -
`JDK 1.6.0`で導入された、`TableRowSorter`を使っている場合は、ソート不可にするカラムを`DefaultRowSorter#setSortable(int, boolean)`で指定し、表示を以下のようなレンダラーで切り替えます(参考: [TableRowSorterでJTableのソート](https://ateraimemo.com/Swing/TableRowSorter.html))。

<pre class="prettyprint"><code>final JTableHeader hd = table.getTableHeader();
final TableCellRenderer headerRenderer = hd.getDefaultRenderer();
hd.setDefaultRenderer(new TableCellRenderer() {
  @Override public Component getTableCellRendererComponent(JTable tbl, Object val,
      boolean isS, boolean hasF, int row, int col) {
    JLabel lbl = (JLabel) headerRenderer.getTableCellRendererComponent(
      tbl, val, isS, hasF, row, col);
    int modelColumnIndex = tbl.convertColumnIndexToModel(col);
    lbl.setForeground(sorter.isSortable(modelColumnIndex) ? Color.BLACK : Color.GRAY);
    return lbl;
  }
});
</code></pre>

## 参考リンク
- [DefaultRowSorter#setSortable(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/DefaultRowSorter.html#setSortable-int-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
