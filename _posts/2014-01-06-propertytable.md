---
layout: post
title: JTableでプロパティ一覧表を作成する
category: swing
folder: PropertyTable
tags: [JTable, TableCellRenderer, TableCellEditor, JColorChooser]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-01-06

## JTableでプロパティ一覧表を作成する
`JTable`の行ごとにクラスに応じたセルエディタなどを適用することで、プロパティ一覧表を作成します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-ZueCWsZFbOQ/UslO6WVldNI/AAAAAAAAB9g/53vsd2t0OPo/s800/PropertyTable.png)

### サンプルコード
<pre class="prettyprint"><code>String[] columnNames = {"Type", "Value"};
Object[][] data = {
  {"String",  "text"    },
  {"Date",  new Date()  },
  {"Integer", 12      },
  {"Double",  3.45    },
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
    //editingClass = null;
    if(convertColumnIndexToModel(column)==1) {
      //System.out.println("getCellRenderer");
      return getDefaultRenderer(getClassAt(row, column));
    }else{
      return super.getCellRenderer(row, column);
    }
  }
  @Override public TableCellEditor getCellEditor(int row, int column) {
    if(convertColumnIndexToModel(column)==1) {
      //System.out.println("getCellEditor");
      editingClass = getClassAt(row, column);
      return getDefaultEditor(editingClass);
    }else{
      editingClass = null;
      return super.getCellEditor(row, column);
    }
  }
  // http://stackoverflow.com/questions/1464691/property-list-gui-component-in-swing
  // This method is also invoked by the editor when the value in the editor
  // component is saved in the TableModel. The class was saved when the
  // editor was invoked so the proper class can be created.
  @Override public Class getColumnClass(int column) {
    //return editingClass != null ? editingClass : super.getColumnClass(column);
    if(convertColumnIndexToModel(column)==1) {
      //System.out.println("getColumnClass");
      return editingClass;
    }else{
      return super.getColumnClass(column);
    }
  }
};
table.setAutoCreateRowSorter(true);
table.setDefaultRenderer(Color.class, new ColorRenderer());
table.setDefaultEditor(Color.class,   new ColorEditor());
table.setDefaultEditor(Date.class,  new DateEditor());
</code></pre>

### 解説
上記のサンプルでは、`JTable#getCellRenderer(...)`、`JTable#getCellEditor(...)`をオーバーライドして、実際のモデル値からクラスを取得し、そのクラスに応じて行毎に使用するセルレンダラ、セルエディタを変更しています。

- セルレンダラ
    - `String`, `Integer`, `Double`, `Date`, `Boolean`クラスは、それぞれデフォルトの`DefaultTableCellRenderer`, `JTable$NumberRenderer`, `JTable$DoubleRenderer`, `JTable$BooleanRenderer`を使用
    - `Color`クラスは、`table.setDefaultRenderer(Color.class, new ColorRenderer());`で、自作の`ColorRenderer`を使用
- セルエディタ
    - `String`, `Integer`と`Double`, `Boolean`クラスは、それぞれデフォルトの`JTable$GenericEditor`, `JTable$NumberEditor`, `JTable$BooleanEditor`を使用
    - `Date`, `Color`クラスは、`JTable#setDefaultEditor(Class, TableCellEditor)`で、それぞれ対応するセルエディタを用意して使用
        - 参考: [CellEditorをJSpinnerにして日付を変更](http://terai.xrea.jp/Swing/DateCellEditor.html)
        - 参考: [TableDialogEditDemo](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/index.html#TableDialogEditDemo)

<!-- dummy comment line for breaking list -->

- - - -
- `JTable#getColumnClass(int)`メソッドの引数は列のみなので、`1`列目の場合は、`JTable#getCellEditor(...)`で取得したクラスを返すようにオーバーライド
    - 参考: [java - Property list GUI component in Swing - Stack Overflow](http://stackoverflow.com/questions/1464691/property-list-gui-component-in-swing)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [java - Property list GUI component in Swing - Stack Overflow](http://stackoverflow.com/questions/1464691/property-list-gui-component-in-swing)
- [CellEditorをJSpinnerにして日付を変更](http://terai.xrea.jp/Swing/DateCellEditor.html)
- [TableDialogEditDemo](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/index.html#TableDialogEditDemo)

<!-- dummy comment line for breaking list -->

### コメント