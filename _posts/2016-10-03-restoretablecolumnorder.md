---
layout: post
category: swing
folder: RestoreTableColumnOrder
title: JTableのTableColumnの表示順を初期状態に戻す
tags: [JTable, JTableHeader, TableColumn, TableColumnModel]
author: aterai
pubdate: 2016-10-03T00:51:19+09:00
description: JTableのTableColumnの表示順が入れ替えられていた場合、それを初期状態(モデル順)に戻します。
image: https://drive.google.com/uc?export=view&amp;id=1uR48L0Uvm0mBLPOYXx8IR1VJYp0KVzuiAQ
comments: true
---
## 概要
`JTable`の`TableColumn`の表示順が入れ替えられていた場合、それを初期状態(モデル順)に戻します。

{% download https://drive.google.com/uc?export=view&amp;id=1uR48L0Uvm0mBLPOYXx8IR1VJYp0KVzuiAQ %}

## サンプルコード
<pre class="prettyprint"><code>TableColumnModel m = table.getColumnModel();
if (m instanceof SortableTableColumnModel) {
    ((SortableTableColumnModel) m).restoreColumnOrder();
}
//...
class SortableTableColumnModel extends DefaultTableColumnModel {
  public void restoreColumnOrder() {
    Collections.sort(
        tableColumns,
        Comparator.comparingInt(TableColumn::getModelIndex));
    fireColumnMoved(new TableColumnModelEvent(this, 0, tableColumns.size()));
  }
}
</code></pre>

## 解説
上記のサンプルでは、`DefaultTableColumnModel`の`protected Vector<TableColumn> tableColumns;`を`TableColumn`のモデル・インデックス(`TableColumn#getModelIndex()`で取得可能)で直接ソートすることで、入れ替え前の初期状態を復元しています。

- `tableColumns`は`protected`なので、ソートは`DefaultTableColumnModel`を継承するクラス内で実行する
    - `JTable#createDefaultColumnModel()`をオーバーライドしてこの`TableColumnModel`を使用する
    - ソート後、`fireColumnMoved(...)`で`TableColumn`の移動を通知し、再描画を実行する必要がある
- 直接`tableColumns`をソートするのではなく、以下のように`TableColumnModel#moveColumn(...)`メソッドなどを使用してソートする方法もある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public static void sortTableColumn(TableColumnModel model) {
  //selection sort
  int n = model.getColumnCount();
  for (int i = 0; i &lt; n - 1; i++) {
    TableColumn c = (TableColumn) model.getColumn(i);
    for (int j = i + 1; j &lt; n; j++) {
      TableColumn p = (TableColumn) model.getColumn(j);
      if (c.getModelIndex() - p.getModelIndex() &gt; 0) {
        model.moveColumn(j, i);
        i -= 1;
        break;
      }
    }
  }
}
</code></pre>

## コメント
