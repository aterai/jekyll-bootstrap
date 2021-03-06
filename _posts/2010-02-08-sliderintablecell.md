---
layout: post
category: swing
folder: SliderInTableCell
title: JTableのCellEditorとCellRendererにJSliderを使用する
tags: [JTable, TableCellEditor, TableCellRenderer, JSlider, ChangeListener]
author: aterai
pubdate: 2010-02-08T14:27:32+09:00
description: JTableのCellEditorとCellRendererにJSliderを使用するように設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTK5HPd3I/AAAAAAAAAj8/qhIGBo92NNE/s800/SliderInTableCell.png
comments: true
---
## 概要
`JTable`の`CellEditor`と`CellRenderer`に`JSlider`を使用するように設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTK5HPd3I/AAAAAAAAAj8/qhIGBo92NNE/s800/SliderInTableCell.png %}

## サンプルコード
<pre class="prettyprint"><code>class SliderRenderer extends JSlider implements TableCellRenderer {
  public SliderRenderer() {
    super();
    setName("Table.cellRenderer");
    setOpaque(true);
  }

  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    Integer i = (Integer) value;
    setBackground(isSelected ? table.getSelectionBackground() : table.getBackground());
    setValue(i.intValue());
    return this;
  }

  //Overridden for performance reasons. ----&gt;
  @Override public void firePropertyChange(String p, boolean ov, boolean nv) {}
  // ...
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
    Integer i = (Integer) value;
    this.setBackground(table.getSelectionBackground());
    this.setValue(i.intValue());
    return this;
  }
  @Override public Object getCellEditorValue() {
    return Integer.valueOf(getValue());
  }
    //Copied from AbstractCellEditor
// ...
</code></pre>

## 解説
- `0`列目
    - 編集不可
- `1`列目
    - `JSlider`を継承するセルエディタ、セルレンダラーを作成して設定
    - このスライダーのセルエディタに`ChangeListener`を追加し、同じ行の`0`列目の値と同期するよう設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [CellEditorをJSpinnerにして日付を変更](https://ateraimemo.com/Swing/DateCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: [Bug ID: 6348946 JSlider's thumb moves in the wrong direction when used as a JTable cell editor.](https://bugs.openjdk.java.net/browse/JDK-6348946) via. [Swing - How to insert a JComponent into a cell of JTable](https://community.oracle.com/thread/2153323) -- *aterai* 2011-01-16 (日) 02:25:31

<!-- dummy comment line for breaking list -->
