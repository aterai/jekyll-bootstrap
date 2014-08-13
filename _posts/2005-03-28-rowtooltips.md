---
layout: post
title: JTableのTooltipsを行ごとに変更
category: swing
folder: RowTooltips
tags: [JTable, JToolTip, TableCellRenderer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-03-28

## JTableのTooltipsを行ごとに変更
`JTable`の`Tooltips`が、カーソルのある行の内容などを表示するようにします。


{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSbfFU7HI/AAAAAAAAAiw/EPWumbZCrr0/s800/RowTooltips.png %}

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public String getToolTipText(MouseEvent e) {
    int row = convertRowIndexToModel(rowAtPoint(e.getPoint()));
    TableModel m = getModel();
    return "&lt;html&gt;"+m.getValueAt(row, 1)+"&lt;br&gt;"
                   +m.getValueAt(row, 2)+"&lt;/html&gt;";
  }
};
</code></pre>

### 解説
`JTable`の`getToolTipText`メソッドをオーバーライドして、カーソルがある行の情報を表示しています。

- `JTable#convertRowIndexToModel`メソッドを使って`viewRowIndex`を`modelRowIndex`に変更し、モデルから行情報を取得
- 第`1`列、第`2`列を`html`タグを使ってそれぞれ`Tooltips`に設定

<!-- dummy comment line for breaking list -->



- - - -
以下のように、`JTable#prepareRenderer`メソッドや、`CellRenderer`などで`setToolTipText`を使用する方法でも、ツールチップを設定することができます。

<pre class="prettyprint"><code>JTable table = new JTable() {
  @Override public Component prepareRenderer(
        TableCellRenderer tcr, int row, int column) {
    Component c = super.prepareRenderer(tcr, row, column);
    if(c instanceof JComponent) {
      int mr = convertRowIndexToModel(row);
      int mc = convertColumnIndexToModel(column);
      Object o = getModel().getValueAt(mr, mc);
      String s = (o!=null)?o.toString():null;
      ((JComponent)c).setToolTipText(s.isEmpty()?null:s);
    }
    return c;
  }
};
</code></pre>
<pre class="prettyprint"><code>table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer() {
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected,
      boolean hasFocus, int row, int column) {
    super.getTableCellRendererComponent(
      table, value, isSelected, hasFocus, row, column);
    //...
    this.setToolTipText(...);
    return this;
  }
});
</code></pre>

### 参考リンク
- [How to Use Tables (The Java™ Tutorials > Creating a GUI with JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/table.html#celltooltip)
- [JTableHeaderのTooltipsを列ごとに変更](http://terai.xrea.jp/Swing/HeaderTooltips.html)
- [JTableのセルがクリップされている場合のみJToolTipを表示](http://terai.xrea.jp/Swing/ClippedCellTooltips.html)

<!-- dummy comment line for breaking list -->

### コメント
- 名前もコメントも空の場合は、空のツールチップが表示されないように、`null`を返すようにした方がいいかも。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-04-04 (水) 19:26:19

<!-- dummy comment line for breaking list -->

