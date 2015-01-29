---
layout: post
category: swing
folder: RadioButtonCellEditor
title: JTableのセルにJRadioButton
tags: [JTable, JRadioButton, TableCellRenderer, TableCellEditor]
author: aterai
pubdate: 2011-04-25T17:34:01+09:00
description: JTableのセルにJRadioButtonを配置し、全体で一つだけ選択できるように設定します。
comments: true
---
## 概要
`JTable`のセルに`JRadioButton`を配置し、全体で一つだけ選択できるように設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TbUwB1XoMEI/AAAAAAAAA6M/5VwHykCV4OI/s800/RadioButtonCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>DefaultTableModel model = new DefaultTableModel(data, columnNames) {
  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return getValueAt(0, column).getClass();
  }
  @Override public void setValueAt(Object v, int row, int column) {
    if (v instanceof Boolean) {
      for (int i = 0; i &lt; getRowCount(); i++) {
        super.setValueAt(i == row, i, column);
      }
    } else {
      super.setValueAt(v, row, column);
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、`2`列目のカラムクラスを`Boolean`に設定し、`JRadioButton`を継承するセルレンダラ、セルエディタを使って`Boolean`値の表示、編集を行っています。

`ButtonGroup`を使用することが出来ないので、ある`2`列目セルの値を`TRUE`にすると、ほかの行の`2`列目セルの値がすべて`FALSE`になるよう、`TableModel#setValueAt(...)`メソッドをオーバーライドしています。

## 参考リンク
- [JTableのセル中にJRadioButtonを配置](http://ateraimemo.com/Swing/RadioButtonsInTableCell.html)
    - 一つのセルの中に複数の`JRadioButton`を配置(`ButtonGroup`を使用して、セル中で一つだけ選択可能)。

<!-- dummy comment line for breaking list -->

## コメント
