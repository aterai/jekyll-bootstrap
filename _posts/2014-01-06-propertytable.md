---
layout: post
category: swing
folder: PropertyTable
title: JTableでプロパティ一覧表を作成する
tags: [JTable, TableCellRenderer, TableCellEditor, JColorChooser]
author: aterai
pubdate: 2014-01-06T00:25:50+09:00
description: JTableの行ごとにクラスに応じたセルエディタなどを適用することで、プロパティ一覧表を作成します。
image: https://lh4.googleusercontent.com/-ZueCWsZFbOQ/UslO6WVldNI/AAAAAAAAB9g/53vsd2t0OPo/s800/PropertyTable.png
comments: true
---
## 概要
`JTable`の行ごとにクラスに応じたセルエディタなどを適用することで、プロパティ一覧表を作成します。

{% download https://lh4.googleusercontent.com/-ZueCWsZFbOQ/UslO6WVldNI/AAAAAAAAB9g/53vsd2t0OPo/s800/PropertyTable.png %}

## サンプルコード
<pre class="prettyprint"><code>String[] columnNames = {"Type", "Value"};
Object[][] data = {
  {"String",  "text"      },
  {"Date",    new Date()  },
  {"Integer", 12          },
  {"Double",  3.45        },
  {"Boolean", Boolean.TRUE},
  {"Color",   Color.RED   }
};
JTable table = new JTable(data, columnNames) {
  private Class editingClass;
  private Class getClassAt(int row, int column) {
    int mc = convertColumnIndexToModel(column);
    int mr = convertRowIndexToModel(row);
    return getModel().getValueAt(mr, mc).getClass();
  }

  @Override public TableCellRenderer getCellRenderer(int row, int column) {
    // editingClass = null;
    if (convertColumnIndexToModel(column) == 1) {
      // System.out.println("getCellRenderer");
      return getDefaultRenderer(getClassAt(row, column));
    } else {
      return super.getCellRenderer(row, column);
    }
  }

  @Override public TableCellEditor getCellEditor(int row, int column) {
    if (convertColumnIndexToModel(column) == 1) {
      // System.out.println("getCellEditor");
      editingClass = getClassAt(row, column);
      return getDefaultEditor(editingClass);
    } else {
      editingClass = null;
      return super.getCellEditor(row, column);
    }
  }

  // https://stackoverflow.com/questions/1464691/property-list-gui-component-in-swing
  // This method is also invoked by the editor when the value in the editor
  // component is saved in the TableModel. The class was saved when the
  // editor was invoked so the proper class can be created.
  @Override public Class getColumnClass(int column) {
    // return editingClass != null ? editingClass : super.getColumnClass(column);
    if (convertColumnIndexToModel(column) == 1) {
      // System.out.println("getColumnClass");
      return editingClass;
    } else {
      return super.getColumnClass(column);
    }
  }
};
table.setAutoCreateRowSorter(true);
table.setDefaultRenderer(Color.class, new ColorRenderer());
table.setDefaultEditor(Color.class, new ColorEditor());
table.setDefaultEditor(Date.class, new DateEditor());
</code></pre>

## 解説
上記のサンプルでは、`JTable#getCellRenderer(...)`、`JTable#getCellEditor(...)`をオーバーライドして実際のモデル値からクラスを取得し、そのクラスに応じて行ごとに使用するセルレンダラー、セルエディタを変更しています。

- セルレンダラー
    - `String`クラスと`Date`クラスはデフォルトの`DefaultTableCellRenderer`を使用
    - `Integer`クラスと`Double`クラスはデフォルトの`JTable$NumberRenderer`を使用
    - `Color`クラスはアイコンで色を表示するセルレンダラーを作成して`Table#setDefaultRenderer(Color.class, new ColorRenderer())`で設定
- セルエディタ
    - `String`クラスはデフォルトの`JTable$GenericEditor`を使用
    - `Integer`クラスと`Double`クラスはデフォルトの`JTable$NumberEditor`を使用
    - `Boolean`クラスはデフォルトの`JTable$BooleanEditor`を使用
    - `Date`クラスは`JSpinner`でセルエディタを作成して`JTable#setDefaultEditor(Class, TableCellEditor)`で設定
        - 参考: [CellEditorをJSpinnerにして日付を変更](https://ateraimemo.com/Swing/DateCellEditor.html)
    - `Color`クラスは`JColorChooser`を開く`JButton`でセルエディタを作成して`JTable#setDefaultEditor(Class, TableCellEditor)`で設定
        - 参考: [TableDialogEditDemo](https://docs.oracle.com/javase/tutorial/uiswing/examples/components/index.html#TableDialogEditDemo)
- - - -
- `JTable#getColumnClass(int)`メソッドの引数は列のみのため、`1`列目の場合は`JTable#getCellEditor(...)`で取得したクラスを返すようにオーバーライド
    - 参考: [java - Property list GUI component in Swing - Stack Overflow](https://stackoverflow.com/questions/1464691/property-list-gui-component-in-swing)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Property list GUI component in Swing - Stack Overflow](https://stackoverflow.com/questions/1464691/property-list-gui-component-in-swing)
- [CellEditorをJSpinnerにして日付を変更](https://ateraimemo.com/Swing/DateCellEditor.html)
- [TableDialogEditDemo](https://docs.oracle.com/javase/tutorial/uiswing/examples/components/index.html#TableDialogEditDemo)

<!-- dummy comment line for breaking list -->

## コメント
