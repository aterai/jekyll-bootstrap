---
layout: post
category: swing
folder: DefaultSortingColumn
title: JTableがデフォルトでソートする列を設定する
tags: [JTable, RowSorter]
author: aterai
pubdate: 2011-06-06T18:40:01+09:00
description: JTableがデフォルトでソートする列とその方向を設定します。
image: https://lh5.googleusercontent.com/-qvzRq_TxwSg/Texuvm22ELI/AAAAAAAAA84/DhfjZ3TEATk/s800/DefaultSortingColumn.png
comments: true
---
## 概要
`JTable`がデフォルトでソートする列とその方向を設定します。

{% download https://lh5.googleusercontent.com/-qvzRq_TxwSg/Texuvm22ELI/AAAAAAAAA84/DhfjZ3TEATk/s800/DefaultSortingColumn.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model);
table.setAutoCreateRowSorter(true);
int index = 0;
//table.getRowSorter().toggleSortOrder(index); //SortOrder.ASCENDING
table.getRowSorter().setSortKeys(
    Arrays.asList(new RowSorter.SortKey(index, SortOrder.DESCENDING)));
</code></pre>

## 解説
上記のサンプルでは、マウスでヘッダをクリックすることなく、起動後の初期状態で`JTable`のソートを実行する列を指定しています。

`RowSorter#setSortKeys(...)`を使用するので、列のソート順序(昇順か降順、ここでは、`0`列目を`SortOrder.DESCENDING`で降順)も指定することができます。

- メモ
    - `table.getRowSorter().toggleSortOrder(index)`を`1`回で昇順、`2`回で降順に設定する方法もある
    - `RowSorter#setSortKeys(null)`で、ソート無し状態になる
        - [TableRowSorterのSortKeysをクリアする](http://ateraimemo.com/Swing/ClearSortingState.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TableRowSorterのSortKeysをクリアする](http://ateraimemo.com/Swing/ClearSortingState.html)

<!-- dummy comment line for breaking list -->

## コメント
