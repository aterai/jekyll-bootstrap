---
layout: post
category: swing
folder: CheckedRowColor
title: JTableのセルにJCheckBoxを表示して行背景色を変更
tags: [JTable, JCheckBox, TableModelListener, TableCellRenderer, TableCellEditor]
author: aterai
pubdate: 2008-07-14T14:18:45+09:00
description: JTableのセルに表示されているJCheckBoxがチェックされていれば、その行の背景色を変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTI7wkSMbI/AAAAAAAAATk/uGVLWCqLJUI/s800/CheckedRowColor.png
comments: true
---
## 概要
`JTable`のセルに表示されている`JCheckBox`がチェックされていれば、その行の背景色を変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTI7wkSMbI/AAAAAAAAATk/uGVLWCqLJUI/s800/CheckedRowColor.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public Component prepareEditor(
        TableCellEditor editor, int row, int column) {
    Component cmp = super.prepareEditor(editor, row, column);
    if (convertColumnIndexToModel(column) == BOOLEAN_COLUMN) {
      JCheckBox c = (JCheckBox) cmp;
      c.setBackground(c.isSelected() ? Color.ORANGE : getBackground());
    }
    return cmp;
  }
  @Override public Component prepareRenderer(
        TableCellRenderer renderer, int row, int column) {
    Component c = super.prepareRenderer(renderer, row, column);
    Boolean isChecked = (Boolean) model.getValueAt(
      convertRowIndexToModel(row), BOOLEAN_COLUMN);
    c.setForeground(getForeground());
    c.setBackground(isChecked ? Color.ORANGE : getBackground());
    return c;
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JTable`の`prepareEditor`、`prepareRenderer`をオーバーライドして編集中のセルエディタ(`JCheckBox`)や同じ行の背景色を変更しています。

- - - -
デフォルトのセルレンダラーの場合、例えばチェックボックスがクリックされてモデルが更新されるとその対応するセルのみ再描画されます。このサンプルでは対象セルだけではなく、そのセルが存在する行全体の背景色を変更しているので、`TableModelListener`でモデルの更新を検出し、以下のように`JTable#repaint(...)`メソッドを使って行を再描画しています。

<pre class="prettyprint"><code>model.addTableModelListener(new TableModelListener() {
  @Override public void tableChanged(TableModelEvent e) {
    if (e.getType() == TableModelEvent.UPDATE) {
      //rowRepaint(table, table.convertRowIndexToView(e.getFirstRow()));
      Rectangle r = table.getCellRect(table.convertRowIndexToView(e.getFirstRow()), 0, true);
      r.width  = table.getWidth();
      //table.repaint(); //table全体をリペイントする必要はないので
      table.repaint(r);  //一行だけリペイント
    }
  }
});
</code></pre>

## 参考リンク
- [JTable#prepareRenderer(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#prepareRenderer-javax.swing.table.TableCellRenderer-int-int-)
- [Swing - JTable-Row color issue](https://community.oracle.com/thread/1361072)

<!-- dummy comment line for breaking list -->

## コメント
- ごちそうさまでした。 -- *tanuchan* 2009-12-14 (Mon) 04:22:08
    - まいどありです。 -- *aterai* 2009-12-16 (水) 21:25:57
- メモ: [Bug ID: 6711682 JCheckBox in JTable: checkbox doesn't alaways respond to the first mouse click](https://bugs.openjdk.java.net/browse/JDK-6711682) -- *aterai* 2010-07-26 (月) 14:18:03

<!-- dummy comment line for breaking list -->
