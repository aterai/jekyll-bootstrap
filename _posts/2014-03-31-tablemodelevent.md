---
layout: post
title: JTableのモデルが変更されたことをイベントで受け取る
category: swing
folder: TableModelEvent
tags: [JTable, TableModelListener, TableModelEvent, JCheckBox]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-03-31

## JTableのモデルが変更されたことをイベントで受け取る
`JTable`のモデルの変更を受け取って`JTableHeader`に追加した`JCheckBox`を更新します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/-Mndxsu0wtCM/Uzg00YuVfyI/AAAAAAAACCw/HoRS9CVP_-o/s800/TableModelEvent.png)

### サンプルコード
<pre class="prettyprint"><code>class HeaderCheckBoxHandler implements TableModelListener {
  private final JTable table;
  private final int targetColumnIndex;
  public HeaderCheckBoxHandler(JTable table, int index) {
    this.table = table;
    this.targetColumnIndex = index;
  }
  @Override public void tableChanged(TableModelEvent e) {
    int vci = table.convertColumnIndexToView(targetColumnIndex);
    TableColumn column = table.getColumnModel().getColumn(vci);
    Object status = column.getHeaderValue();
    TableModel m = table.getModel();
    if (e.getType() == TableModelEvent.DELETE) {
      if (m.getRowCount() == 0) {
        column.setHeaderValue(Status.DESELECTED);
      } else if (Status.INDETERMINATE.equals(status)) {
        boolean selected = true;
        boolean deselected = true;
        for (int i = 0; i &lt; m.getRowCount(); i++) {
          Boolean b = (Boolean) m.getValueAt(i, targetColumnIndex);
          selected &amp;= b;
          deselected &amp;= !b;
        }
        if (deselected) {
          column.setHeaderValue(Status.DESELECTED);
        } else if (selected) {
          column.setHeaderValue(Status.SELECTED);
        } else {
          return;
        }
      }
    } else if (e.getType() == TableModelEvent.INSERT
               &amp;&amp; !Status.INDETERMINATE.equals(status)) {
      boolean selected = Status.DESELECTED.equals(status);
      boolean deselected = Status.SELECTED.equals(status);
      for (int i = e.getFirstRow(); i &lt;= e.getLastRow(); i++) {
        Boolean b = (Boolean) m.getValueAt(i, targetColumnIndex);
        selected &amp;= b;
        deselected &amp;= !b;
      }
      if (selected &amp;&amp; m.getRowCount() == 1) {
        column.setHeaderValue(Status.SELECTED);
      } else if (selected || deselected) {
        column.setHeaderValue(Status.INDETERMINATE);
      }
    } else if (e.getType() == TableModelEvent.UPDATE
               &amp;&amp; e.getColumn() == targetColumnIndex) {
      if (Status.INDETERMINATE.equals(status)) {
        boolean selected = true;
        boolean deselected = true;
        for (int i = 0; i &lt; m.getRowCount(); i++) {
          Boolean b = (Boolean) m.getValueAt(i, targetColumnIndex);
          selected &amp;= b;
          deselected &amp;= !b;
          if (selected == deselected) {
            return;
          }
        }
        if (deselected) {
          column.setHeaderValue(Status.DESELECTED);
        } else if (selected) {
          column.setHeaderValue(Status.SELECTED);
        } else {
          return;
        }
      } else {
        column.setHeaderValue(Status.INDETERMINATE);
      }
    }
    JTableHeader h = table.getTableHeader();
    h.repaint(h.getHeaderRect(vci));
  }
}
</code></pre>

### 解説
上記のサンプルでは、`0`行目の値(`boolean`)の変更、行の追加、削除を受け取って`JTableHeader`のチェック状態を更新する`TableModelListener`を作成して、これを`TableModel#addTableModelListener(...)`で設定しています。

- `e.getType() == TableModelEvent.DELETE`: 行の削除
    - 削除によって行数が`0`になった場合は、`JTableHeader`は未選択状態
    - `JTableHeader`が選択状態、または未選択状態の場合、削除によってその状態は変化しない
    - `JTableHeader`が不定状態の場合は、全行を検索して選択状態を変更するかどうかを調査する
- `e.getType() == TableModelEvent.INSERT`: 行の追加
    - `JTableHeader`がすでに不定状態の場合は、追加される行の選択状態にかかわらず、その状態は変化しない
    - `JTableHeader`が不定状態でない場合は、追加される行と`JTableHeader`の選択状態を合わせて調査する
- `e.getType() == TableModelEvent.UPDATE`: `0`列目の更新
    - `JTableHeader`が不定状態の場合は、全行を検索して選択状態を変更するかどうかを調査する
    - `JTableHeader`が不定状態でない場合は、この更新によって`JTableHeader`は不定状態になる

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableHeaderにJCheckBoxを追加してセルの値を切り替える](http://terai.xrea.jp/Swing/TableHeaderCheckBox.html)

<!-- dummy comment line for breaking list -->

### コメント
- 修正: `src.zip`などがアップロードされていない -- [aterai](http://terai.xrea.jp/aterai.html) 2014-05-09 (金) 17:17:04

<!-- dummy comment line for breaking list -->

