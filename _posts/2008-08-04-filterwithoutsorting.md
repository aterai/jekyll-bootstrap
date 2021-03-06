---
layout: post
category: swing
folder: FilterWithoutSorting
title: JTableのRowSorterをフィルタありソート不可にする
tags: [JTable, TableRowSorter]
author: aterai
pubdate: 2008-08-04T00:17:37+09:00
description: フィルタありでソート不可のTableRowSorterを作成します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMr425A3I/AAAAAAAAAZk/ZFpsuUZWGcQ/s800/FilterWithoutSorting.png
comments: true
---
## 概要
フィルタありでソート不可の`TableRowSorter`を作成します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMr425A3I/AAAAAAAAAZk/ZFpsuUZWGcQ/s800/FilterWithoutSorting.png %}

## サンプルコード
<pre class="prettyprint"><code>final TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;&gt;(model) {
  @Override public boolean isSortable(int column) {
    return false;
  }
};
sorter.setRowFilter(new RowFilter&lt;TableModel, Integer&gt;() {
  @Override public boolean include(Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    return entry.getIdentifier() % 2 == 0;
  }
});
</code></pre>

## 解説
上記のサンプルでは、行のフィルタリングのみ有効にして行のソートは不可にしたいので、`TableRowSorter`に以下のような設定をしています。

- `DefaultRowSorter#setRowFilter(RowFilter)`で偶数行だけ表示するフィルタを設定
- `DefaultRowSorter#isSortable(int)`をオーバーライドして常に`false`を返す

<!-- dummy comment line for breaking list -->

- - - -
- `DefaultRowSorter#setSortable(int, boolean)`メソッドを使用して一部の列だけソート不可にする方法もある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultRowSorter (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/DefaultRowSorter.html)
- [JTableHeaderのカラムを選択不可にする](https://ateraimemo.com/Swing/DisabledHeader.html)

<!-- dummy comment line for breaking list -->

## コメント
