---
layout: post
title: JTableがデフォルトでソートする列を設定する
category: swing
folder: DefaultSortingColumn
tags: [JTable, RowSorter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-06-06

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
上記のサンプルでは、`RowSorter#setSortKeys(...)`を使って、指定の列のソート順序(ここでは、`0`列目を`SortOrder.DESCENDING`で降順)のリストを設定しています。

- - - -
- `RowSorter#setSortKeys(null)`で、ソート無し状態になる
    - [TableRowSorterのSortKeysをクリアする](http://terai.xrea.jp/Swing/ClearSortingState.html)

<!-- dummy comment line for breaking list -->

- - - -
`table.getRowSorter().toggleSortOrder(index)`を一回で昇順、二回で降順に設定する方法もあります。

## 参考リンク
- [TableRowSorterのSortKeysをクリアする](http://terai.xrea.jp/Swing/ClearSortingState.html)

<!-- dummy comment line for breaking list -->

## コメント
