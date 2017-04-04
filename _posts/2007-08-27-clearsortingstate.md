---
layout: post
category: swing
folder: ClearSortingState
title: TableRowSorterのSortKeysをクリアする
tags: [JTable, TableRowSorter, JTableHeader, MouseListener]
author: aterai
pubdate: 2007-08-27T12:33:13+09:00
description: JDK 6で導入されたTableRowSorterでの行ソートを、テーブルヘッダのKBD{Shift}+クリックでクリアします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJF8YbgvI/AAAAAAAAAT0/NDSO1fqmVNw/s800/ClearSortingState.png
comments: true
---
## 概要
`JDK 6`で導入された`TableRowSorter`での行ソートを、テーブルヘッダの<kbd>Shift</kbd>+クリックでクリアします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJF8YbgvI/AAAAAAAAAT0/NDSO1fqmVNw/s800/ClearSortingState.png %}

## サンプルコード
<pre class="prettyprint"><code>table.setAutoCreateRowSorter(true);
table.getTableHeader().addMouseListener(new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent e) {
    final RowSorter&lt;? extends TableModel&gt; sorter = table.getRowSorter();
    if (sorter == null || sorter.getSortKeys().isEmpty()) {
      return;
    }
    JTableHeader h = (JTableHeader) e.getComponent();
    TableColumnModel columnModel = h.getColumnModel();
    int viewColumn = columnModel.getColumnIndexAtX(e.getX());
    if (viewColumn &lt; 0) {
      return;
    }
    int column = columnModel.getColumn(viewColumn).getModelIndex();
    if (column != -1 &amp;&amp; e.isShiftDown()) {
      EventQueue.invokeLater(new Runnable() {
        @Override public void run() {
          sorter.setSortKeys(null);
        }
      });
    }
  }
});
</code></pre>

## 解説
ヘッダにマウスリスナーを設定し、<kbd>Shift</kbd>キーを押しながらのクリックの場合は、`TableRowSorter#setSortKeys`メソッドを使って、ソートキーを空にしています。

上記のサンプルでは、以下のような制限があります。

- ソートキーになっていないカラムヘッダを<kbd>Shift</kbd>+クリックした場合でも、ソート状態をクリアする
- ~~行がソートされている場合は、ドラッグ&ドロップで行を入れ替え不可~~ `D&D`機能は削除

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TableSorter.java](https://docs.oracle.com/javase/tutorial/uiswing/examples/components/TableSorterDemoProject/src/components/TableSorter.java)
- [TableRowSorterでJTableのソート](http://ateraimemo.com/Swing/TableRowSorter.html)
- [TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更](http://ateraimemo.com/Swing/TriStateSorting.html)

<!-- dummy comment line for breaking list -->

## コメント
