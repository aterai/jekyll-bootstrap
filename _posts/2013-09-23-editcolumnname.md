---
layout: post
title: JTableのColumn名を変更する
category: swing
folder: EditColumnName
tags: [JTable, JTableHeader, TableColumn, DefaultTableModel, JPopupMenu]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-09-23

## JTableのColumn名を変更する
`JTable`の`Column`名を`JPopupMenu`を使用して変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-axnByzuSfvw/Uj9Bj3mhK0I/AAAAAAAAB2U/GgzDuKdOje8/s800/EditColumnName.png)

### サンプルコード
<pre class="prettyprint"><code>private final JMenuItem editItem1 = new JMenuItem(
    new AbstractAction("Edit: setHeaderValue") {
  @Override public void actionPerformed(ActionEvent e) {
    JTableHeader header = (JTableHeader)getInvoker();
    TableColumn column = header.getColumnModel().getColumn(index);
    String name = column.getHeaderValue().toString();
    textField.setText(name);
    int result = JOptionPane.showConfirmDialog(
        header.getTable(), textField, getValue(NAME).toString(),
        JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
    if(result==JOptionPane.OK_OPTION) {
      String str = textField.getText().trim();
      if(!str.equals(name)) {
        column.setHeaderValue(str);
        header.repaint();
      }
    }
  }
});
</code></pre>

### 解説
- `Edit: setHeaderValue`
    - `TableColumn#getHeaderValue()`でカラム名を取得して、`TableColumn#setHeaderValue(String)`で変更
    - モデルの`ColumnIdentifier`は、変更されない
- `Edit: setColumnIdentifiers`
    - `DefaultTableModel#setColumnIdentifiers(Object[])`でモデルの列識別子を置き換え、`JTableHeader`を作り直しているため、列の入れ替えなどは初期化される
    - ドラッグ中のカラムが存在する状態で、`DefaultTableModel#setColumnIdentifiers(Object[])`を実行すると、`ArrayIndexOutOfBoundsException: -1`が発生する
        - このサンプルでは、`JTableHeader#setDraggedColumn(null);`で、ドラッグ中のカラムをクリアしている
        - `DefaultTableModel#setColumnIdentifiers(Object[])`を使用する場合は、`table.getTableHeader().setReorderingAllowed(false);`とドラッグによる列の順序変更を禁止しておいた方が良いかもしれない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private final JMenuItem editItem2 = new JMenuItem(
        new AbstractAction("Edit: setColumnIdentifiers") {
  @Override public void actionPerformed(ActionEvent e) {
    final JTableHeader header = (JTableHeader)getInvoker();
    final JTable table = header.getTable();
    final DefaultTableModel model = (DefaultTableModel)table.getModel();
    String name = table.getColumnName(index);
    textField.setText(name);
    int result = JOptionPane.showConfirmDialog(
        table, textField, getValue(NAME).toString(),
        JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
    if(result==JOptionPane.OK_OPTION) {
      String str = textField.getText().trim();
      if(!str.equals(name)) {
        columnNames[table.convertColumnIndexToModel(index)] = str;
        header.setDraggedColumn(null); //XXX
        model.setColumnIdentifiers(columnNames);
      }
    }
  }
});
</code></pre>

### 参考リンク
- [JTableHeaderにJPopupMenuを追加してソート](http://terai.xrea.jp/Swing/RowSorterPopupMenu.html)

<!-- dummy comment line for breaking list -->

### コメント