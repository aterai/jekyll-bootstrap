---
layout: post
category: swing
folder: RowTooltips
title: JTableのTooltipsを行ごとに変更
tags: [JTable, JToolTip, TableCellRenderer]
author: aterai
pubdate: 2005-03-28T02:50:10+09:00
description: JTableのTooltipsが、カーソルのある行の内容などを表示するように設定します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSbfFU7HI/AAAAAAAAAiw/EPWumbZCrr0/s800/RowTooltips.png
comments: true
---
## 概要
`JTable`の`Tooltips`が、カーソルのある行の内容などを表示するように設定します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSbfFU7HI/AAAAAAAAAiw/EPWumbZCrr0/s800/RowTooltips.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public String getToolTipText(MouseEvent e) {
    int row = convertRowIndexToModel(rowAtPoint(e.getPoint()));
    TableModel m = getModel();
    return "&lt;html&gt;" + m.getValueAt(row, 1) + "&lt;br&gt;"
                    + m.getValueAt(row, 2) + "&lt;/html&gt;";
  }
};
</code></pre>

## 解説
`JTable#getToolTipText()`メソッドをオーバーライドして、カーソルがある行の情報を表示しています。

- `JTable#convertRowIndexToModel(...)`メソッドを使用して`viewRowIndex`を`modelRowIndex`に変更し、モデルから行情報を取得
- 第`1`列、第`2`列を`html`タグを使ってそれぞれ`ToolTipText`として設定

<!-- dummy comment line for breaking list -->

- - - -
以下のように、`setToolTipText(...)`メソッドを使用して、各行に`ToolTipText`を設定する方法もあります。

- `JTable#prepareRenderer(...)`メソッド内で`setToolTipText(...)`を使用する
    
    <pre class="prettyprint"><code>JTable table = new JTable() {
      @Override public Component prepareRenderer(
          TableCellRenderer tcr, int row, int column) {
        Component c = super.prepareRenderer(tcr, row, column);
        if (c instanceof JComponent) {
          int mr = convertRowIndexToModel(row);
          int mc = convertColumnIndexToModel(column);
          Object o = getModel().getValueAt(mr, mc);
          String s = (o != null) ? o.toString() : null;
          ((JComponent) c).setToolTipText(s.isEmpty() ? null : s);
        }
        return c;
      }
    };
</code></pre>
- `TableCellRenderer#getTableCellRendererComponent(...)`メソッド内で`setToolTipText(...)`を使用する
    
    <pre class="prettyprint"><code>table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer() {
      @Override public Component getTableCellRendererComponent(
          JTable table, Object value, boolean isSelected,
          boolean hasFocus, int row, int column) {
        super.getTableCellRendererComponent(
          table, value, isSelected, hasFocus, row, column);
        // ...
        this.setToolTipText(...);
        return this;
      }
    });
</code></pre>
- * 参考リンク [#reference]
- [How to Use Tables (The Java™ Tutorials > Creating a GUI with JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/table.html#celltooltip)
- [JTableHeaderのTooltipsを列ごとに変更](https://ateraimemo.com/Swing/HeaderTooltips.html)
- [JTableのセルがクリップされている場合のみJToolTipを表示](https://ateraimemo.com/Swing/ClippedCellTooltips.html)

<!-- dummy comment line for breaking list -->

## コメント
- 名前もコメントも空の場合は、空のツールチップが表示されないように、`null`を返すようにした方がいいかも。 -- *aterai* 2007-04-04 (水) 19:26:19

<!-- dummy comment line for breaking list -->
