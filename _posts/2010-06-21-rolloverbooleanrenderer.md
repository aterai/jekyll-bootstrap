---
layout: post
title: JCheckBoxのセルをロールオーバーする
category: swing
folder: RolloverBooleanRenderer
tags: [JTable, JCheckBox, MouseListener, TableCellRenderer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-06-21

## JCheckBoxのセルをロールオーバーする
`JTable`のセルに`JCheckBox`を使用したときでも、マウスカーソルでロールオーバーするように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSCUU481I/AAAAAAAAAiI/LzyeHFbwP40/s800/RolloverBooleanRenderer.png)

### サンプルコード
<pre class="prettyprint"><code>class RolloverBooleanRenderer extends JCheckBox implements TableCellRenderer, UIResource {
  private static final Border noFocusBorder = new EmptyBorder(1, 1, 1, 1);
  private final HighlightListener highlighter;
  public RolloverBooleanRenderer(HighlightListener highlighter) {
    super();
    this.highlighter = highlighter;
    setHorizontalAlignment(JLabel.CENTER);
    setBorderPainted(true);
    setRolloverEnabled(true);
    setOpaque(true);
  }
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
                               boolean isSelected, boolean hasFocus, int row, int column) {
    if(highlighter.isHighlightableCell(row, column)) {
      getModel().setRollover(true);
    }else{
      getModel().setRollover(false);
    }
    if(isSelected) {
      setForeground(table.getSelectionForeground());
      super.setBackground(table.getSelectionBackground());
    }else{
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    setSelected((value != null &amp;&amp; ((Boolean)value).booleanValue()));
    if(hasFocus) {
      setBorder(UIManager.getBorder("Table.focusCellHighlightBorder"));
    }else{
      setBorder(noFocusBorder);
    }
    return this;
  }
}
</code></pre>

### 解説
- 上: デフォルト
- 下: `JTable#setDefaultRenderer`メソッドで、`Object`, `Number`, `Boolean`クラスそれぞれに、マウスカーソルに反応するレンダラーを設定
    - これらは、`JTable$BooleanRenderer`クラスなどを参考に作成
    - `JCheckBox`のロールオーバーは、`JCheckBox#getModel()#setRollover(boolean)`メソッドを使用

<!-- dummy comment line for breaking list -->

### コメント
