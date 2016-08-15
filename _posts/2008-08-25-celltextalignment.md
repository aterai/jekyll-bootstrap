---
layout: post
category: swing
folder: CellTextAlignment
title: JTableのセル文字揃え
tags: [JTable, TableCellRenderer, Alignment]
author: aterai
pubdate: 2008-08-25T14:45:47+09:00
description: JTableのセルに表示されている文字列の揃えを変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIs6qWcBI/AAAAAAAAATM/AnH_ZWdWA5o/s800/CellTextAlignment.png
comments: true
---
## 概要
`JTable`のセルに表示されている文字列の揃えを変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIs6qWcBI/AAAAAAAAATM/AnH_ZWdWA5o/s800/CellTextAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>TableColumn col = table.getColumnModel().getColumn(1);
col.setCellRenderer(new HorizontalAlignmentTableRenderer());
//...
class HorizontalAlignmentTableRenderer extends DefaultTableCellRenderer {
  @Override public Component getTableCellRendererComponent(JTable table,
        Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    Component c = super.getTableCellRendererComponent(
        table, value, isSelected, hasFocus, row, column);
    if (c instanceof JLabel) {
      initLabel((JLabel) c, row);
    }
    return c;
  }
  private void initLabel(JLabel l, int row) {
    if (leftRadio.isSelected()) {
      l.setHorizontalAlignment(SwingConstants.LEFT);
    } else if (centerRadio.isSelected()) {
      l.setHorizontalAlignment(SwingConstants.CENTER);
    } else if (rightRadio.isSelected()) {
      l.setHorizontalAlignment(SwingConstants.RIGHT);
    } else if (customRadio.isSelected()) {
      l.setHorizontalAlignment(row % 3 == 0 ? SwingConstants.LEFT:
                               row % 3 == 1 ? SwingConstants.CENTER:
                                              SwingConstants.RIGHT);
    }
  }
}
</code></pre>

## 解説
- ラジオボタンで、`JTable`の第一列のセル文字列の揃えを変更
    - `left`: 左揃え
    - `center`: 中央揃え
    - `right`: 右揃え
    - `custom`: 行ごとに左、中央、右揃えを変更
- メモ
    - セルエディタなどにラジオボタンを配置する場合は、[JTableのセル中にJRadioButtonを配置](http://ateraimemo.com/Swing/RadioButtonsInTableCell.html)

<!-- dummy comment line for breaking list -->

- - - -
- `JTable`は、`Object`、`Number`、`Boolean`クラスのデフォルトセルレンダラーを持っているため、モデルが各列のクラスを正しく返すように、`TableModel#getColumnClass(int)`をオーバーライドすることで、そのクラスのデフォルトセルレンダラーが使用される
    - `Object`: `SwingConstants.LEFT`(文字列などは左揃え)
    - `Number`: `SwingConstants.RIGHT`(数字は右揃え)
    - `Boolean`: `JCheckBox`, `CENTER`(チェックボックスは中央揃え)
- `DefaultTableModel#TableModel#getColumnClass(int)`のデフォルトは、すべての列のクラスとして、`Object.class`を返す
- 各クラスのデフォルトセルレンダラーが使用されるのは、列にセルレンダラーが割り当てられていない場合に限られる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//JTableの手抜きサンプルなら、以下のようにオーバーライドするのが簡単？(モデルが空になる場合、例外が発生する可能性がある)
String[] columnNames = {"String", "Integer", "Boolean"};
Object[][] data = {
  {"AAA", 1, true},
  {"BBB", 2, false},
};
DefaultTableModel model = new DefaultTableModel(data, columnNames) {
  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return getValueAt(0, column).getClass();
  }
};
JTable table = new JTable(model);
</code></pre>

クラスのデフォルトセルレンダラーではなく、任意の列にセルレンダラーを割り当てて、例えば中央揃えにしたい場合は、以下のように設定します。

<pre class="prettyprint"><code>DefaultTableCellRenderer r = new DefaultTableCellRenderer();
r.setHorizontalAlignment(SwingConstants.CENTER);
table.getColumnModel().getColumn(2).setCellRenderer(r);
</code></pre>

## 参考リンク
- [JTableHeaderの字揃え](http://ateraimemo.com/Swing/HorizontalAlignmentHeaderRenderer.html)
    - ヘッダの文字揃えに関するテストは、上記の場所に移動

<!-- dummy comment line for breaking list -->

## コメント
