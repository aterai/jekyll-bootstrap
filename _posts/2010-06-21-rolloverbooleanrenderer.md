---
layout: post
category: swing
folder: RolloverBooleanRenderer
title: JCheckBoxのセルをロールオーバーする
tags: [JTable, JCheckBox, MouseListener, TableCellRenderer]
author: aterai
pubdate: 2010-06-21T15:14:48+09:00
description: JTableのセルにJCheckBoxを使用したときでも、マウスカーソルでロールオーバーするように設定します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSCUU481I/AAAAAAAAAiI/LzyeHFbwP40/s800/RolloverBooleanRenderer.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2010/07/create-jcheckbox-rollover-effect-in.html
    lang: en
comments: true
---
## 概要
`JTable`のセルに`JCheckBox`を使用したときでも、マウスカーソルでロールオーバーするように設定します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSCUU481I/AAAAAAAAAiI/LzyeHFbwP40/s800/RolloverBooleanRenderer.png %}

## サンプルコード
<pre class="prettyprint"><code>class RolloverBooleanRenderer extends JCheckBox implements TableCellRenderer, UIResource {
  private static final Border noFocusBorder = new EmptyBorder(1, 1, 1, 1);
  private final HighlightListener highlighter;
  public RolloverBooleanRenderer(HighlightListener highlighter) {
    super();
    this.highlighter = highlighter;
    setHorizontalAlignment(SwingConstants.CENTER);
    setBorderPainted(true);
    setRolloverEnabled(true);
    setOpaque(true);
  }
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
                               boolean isSelected, boolean hasFocus, int row, int column) {
    if (highlighter.isHighlightableCell(row, column)) {
      getModel().setRollover(true);
    } else {
      getModel().setRollover(false);
    }
    if (isSelected) {
      setForeground(table.getSelectionForeground());
      super.setBackground(table.getSelectionBackground());
    } else {
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    setSelected((value != null &amp;&amp; ((Boolean) value).booleanValue()));
    if (hasFocus) {
      setBorder(UIManager.getBorder("Table.focusCellHighlightBorder"));
    } else {
      setBorder(noFocusBorder);
    }
    return this;
  }
}
</code></pre>

## 解説
- 上: デフォルト
- 下: `JTable#setDefaultRenderer`メソッドで、`Object`, `Number`, `Boolean`クラスそれぞれに、マウスカーソルに反応するセルレンダラーを設定
    - これらは、デフォルトの`JTable$BooleanRenderer`クラスなどを参考に作成
    - `JCheckBox`のロールオーバー表示は、`JCheckBox#getModel()#setRollover(boolean)`メソッドを使用

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableが使用するBooleanCellEditorの背景色を変更](https://ateraimemo.com/Swing/BooleanCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
