---
layout: post
title: JTableのセルがクリップされている場合のみJToolTipを表示
category: swing
folder: ClippedCellTooltips
tags: [JTable, JTableHeader, TableCellRenderer, JToolTip]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-10-12

## JTableのセルがクリップされている場合のみJToolTipを表示
`JTable`のセルがクリップされている場合のみ`JToolTip`を表示します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJNQAyg-I/AAAAAAAAAUA/F6oQbiUShl4/s800/ClippedCellTooltips.png)

### サンプルコード
<pre class="prettyprint"><code>class ToolTipHeaderRenderer implements TableCellRenderer {
  private final Icon icon = UIManager.getIcon("Table.ascendingSortIcon");
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value,boolean isSelected,boolean hasFocus,int row,int column) {
    TableCellRenderer renderer = table.getTableHeader().getDefaultRenderer();
    JLabel l = (JLabel)renderer.getTableCellRendererComponent(
      table, value, isSelected, hasFocus, row, column);
    Insets i = l.getInsets();
    Rectangle rect = table.getCellRect(row, column, false);
    rect.width -= i.left + i.right;
    RowSorter&lt;? extends TableModel&gt; sorter = table.getRowSorter();
    if(sorter!=null &amp;&amp; !sorter.getSortKeys().isEmpty()
                    &amp;&amp; sorter.getSortKeys().get(0).getColumn()==column) {
      rect.width -= icon.getIconWidth() + 2; //XXX
    }
    FontMetrics fm = l.getFontMetrics(l.getFont());
    String str = value.toString();
    int cellTextWidth = fm.stringWidth(str);
    l.setToolTipText(cellTextWidth&gt;rect.width?str:null);
    return l;
  }
}
</code></pre>

### 解説
- ヘッダセル
    - `TableCellRenderer`で、セルの幅と文字列の長さを比較して、`ToolTip`を設定
    - ソートアイコンと文字列の間の`gap`が不明?

<!-- dummy comment line for breaking list -->

- セル
    - `JTable#prepareRenderer`メソッドをオーバーライドし、セルの幅と文字列の長さを比較して、`ToolTip`を設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public Component prepareRenderer(TableCellRenderer tcr, int row, int column) {
    Component c = super.prepareRenderer(tcr, row, column);
    if(c instanceof JComponent) {
       JComponent l = (JComponent)c;
       Object o = getValueAt(row, column);
       Insets i = l.getInsets();
       Rectangle rect = getCellRect(row, column, false);
       rect.width -= i.left + i.right;
       FontMetrics fm = l.getFontMetrics(l.getFont());
       String str = o.toString();
       int cellTextWidth = fm.stringWidth(str);
       l.setToolTipText(cellTextWidth&gt;rect.width?str:null);
    }
    return c;
  }
};
</code></pre>

### 参考リンク
- [JTableHeaderのTooltipsを列ごとに変更](http://terai.xrea.jp/Swing/HeaderTooltips.html)
- [JTableのTooltipsを行ごとに変更](http://terai.xrea.jp/Swing/RowTooltips.html)

<!-- dummy comment line for breaking list -->

### コメント
