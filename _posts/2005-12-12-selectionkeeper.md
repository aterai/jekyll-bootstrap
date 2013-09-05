---
layout: post
title: TableSorterでソートしても選択状態を維持
category: swing
folder: SelectionKeeper
tags: [JTable, JTableHeader, TableSorter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-12-12

## TableSorterでソートしても選択状態を維持
`TableSorter.java`を使ってソートしても、行の選択状態を保存しておきます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTS229Uo9I/AAAAAAAAAjc/ay3eckOCWco/s800/SelectionKeeper.png)

### サンプルコード
<pre class="prettyprint"><code>private class MouseHandler extends MouseAdapter {
  public void mouseClicked(MouseEvent e) {
    JTableHeader h = (JTableHeader) e.getSource();
//......
    if (column != -1) {
      int keyCol = 0;
      Vector list = saveSelectedRow(h.getTable(), keyCol);
      int status = getSortingStatus(column);
//......
      setSortingStatus(column, status);
      loadSelectedRow(h.getTable(), list, keyCol);
    }
  }
}
Vector saveSelectedRow(JTable table, int keyCol) {
  Vector list = new Vector();
  int[] ilist = table.getSelectedRows();
  if(ilist==null || ilist.length&lt;=0) return;
  TestModel model = (TestModel)tableModel;
  for(int i=ilist.length-1;i&gt;=0;i--) {
    list.add(model.getValueAt(modelIndex(ilist[i]), keyCol));
  }
  return list;
}
void loadSelectedRow(JTable table, Vector list, int keyCol) {
  if(list==null || list.size()&lt;=0) return;
  for(int i=0;i&lt;tableModel.getRowCount();i++) {
    if(list.contains(tableModel.getValueAt(modelIndex(i), keyCol))) {
      table.getSelectionModel().addSelectionInterval(i, i);
    }
  }
}
//......
</code></pre>

### 解説
`JTableHeader`がクリックされてソートが行われる前に、選択されている行のあるカラムの値を保存し、ソートが終わった後でその値をキーに選択し直しています。あるカラムは、一意で重複しない値をもつ必要があります。

上記のサンプルでは、[TableSorter.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/TableSorterDemoProject/src/components/TableSorter.java)中の`MouseHandler`を変更し、`0`列目の番号をキーにして行の選択状態を保存するようにしています。

`JDK 1.6.0`の`TableRowSorter`でソートを行う場合は、標準で選択状態が保存されるようです([TableRowSorterでJTableのソート](http://terai.xrea.jp/Swing/TableRowSorter.html))。

### コメント