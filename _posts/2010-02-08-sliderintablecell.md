---
layout: post
title: JTableのCellEditorとCellRendererにJSliderを使用する
category: swing
folder: SliderInTableCell
tags: [JTable, TableCellEditor, TableCellRenderer, JSlider, ChangeListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-02-08

## JTableのCellEditorとCellRendererにJSliderを使用する
`JTable`の`CellEditor`と`CellRenderer`に`JSlider`を使用するように設定します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTK5HPd3I/AAAAAAAAAj8/qhIGBo92NNE/s800/SliderInTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>class SliderRednerer extends JSlider implements TableCellRenderer {
  public SliderRednerer() {
    super();
    setName("Table.cellRenderer");
    setOpaque(true);
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    Integer i = (Integer)value;
    setBackground(isSelected?table.getSelectionBackground():table.getBackground());
    setValue(i.intValue());
    return this;
  }
  //Overridden for performance reasons. ----&gt;
  @Override public void firePropertyChange(String p, boolean ov, boolean nv) {}
//......
</code></pre>

<pre class="prettyprint"><code>class SliderEditor extends JSlider implements TableCellEditor {
  public SliderEditor(final JTable table) {
    super();
    setOpaque(true);
    addChangeListener(new ChangeListener() {
      @Override public void stateChanged(ChangeEvent e) {
        EventQueue.invokeLater(new Runnable() {
          @Override public void run() {
            int row = table.convertRowIndexToModel(table.getEditingRow());
            table.getModel().setValueAt(getValue(), row, 0);
            table.getModel().setValueAt(getValue(), row, 1);
          }
        });
      }
    });
  }
  @Override public Component getTableCellEditorComponent(JTable table,
      Object value, boolean isSelected, int row, int column) {
    Integer i = (Integer)value;
    this.setBackground(table.getSelectionBackground());
    this.setValue(i.intValue());
    return this;
  }
  @Override public Object getCellEditorValue() {
    return Integer.valueOf(getValue());
  }
    //Copid from AbstractCellEditor
//......
</code></pre>

### 解説
上記のサンプルでは、`1`列目のセルエディタ、レンダラーに`JSlider`を使用するように設定しています。このスライダーの値を変更すると、同じ行の`0`列目の値も変更されるように、セルエディタに`ChangeListener`を追加しています。

### コメント
- メモ: [Bug ID: 6348946 JSlider's thumb moves in the wrong direction when used as a JTable cell editor.](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6348946) via. [Swing - How to insert a JComponent into a cell of JTable](https://forums.oracle.com/thread/2153323) -- [aterai](http://terai.xrea.jp/aterai.html) 2011-01-16 (日) 02:25:31

<!-- dummy comment line for breaking list -->

