---
layout: post
category: swing
folder: RowFilter
title: RowFilterでJTableの行をフィルタリング
tags: [JTable, TableRowSorter, RowFilter]
author: aterai
pubdate: 2007-09-03T15:45:16+09:00
description: JDK 6で導入されたTableRowSorterにRowFilterを設定して、行のフィルタリングを行います。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTST-FvjRI/AAAAAAAAAik/ZbU9nuVVCiI/s800/RowFilter.png
comments: true
---
## 概要
`JDK 6`で導入された`TableRowSorter`に`RowFilter`を設定して、行のフィルタリングを行います。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTST-FvjRI/AAAAAAAAAik/ZbU9nuVVCiI/s800/RowFilter.png %}

## サンプルコード
<pre class="prettyprint"><code>final TableRowSorter&lt;? extends TableModel&gt; sorter = new TableRowSorter&lt;&gt;(model);
final Set&lt;RowFilter&lt;? super TestModel, ? super Integer&gt;&gt; filters = new HashSet&lt;&gt;(2);
final RowFilter&lt;TableModel, Integer&gt; filter1 = new RowFilter&lt;TableModel, Integer&gt;() {
  @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    TableModel model = entry.getModel();
    Test t = model.getTest(entry.getIdentifier());
    return !t.getComment().trim().isEmpty();
  }
};
final RowFilter&lt;TableModel, Integer&gt; filter2 = new RowFilter&lt;TableModel, Integer&gt;() {
  @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    return entry.getIdentifier() % 2 == 0;
  }
};
sorter.setRowFilter(RowFilter.andFilter(filters));
//sorter.setRowFilter(filter1);
</code></pre>

## 解説
上記のサンプルは、以下のような複数の行フィルタを、`and`条件で`JTable`に適用することができます。

- コメント列の値が空でない行のみ表示
- 行番号が偶数の場合のみ表示
    - 行番号はソートされている場合でも、元のモデルのインデックスで判断する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Splash Screens and Java SE 6, and Sorting and Filtering Tables Tech Tips](http://web.archive.org/web/20090419180550/http://java.sun.com/developer/JDCTechTips/2005/tt1115.html)
- [Sorting and Filtering (How to Use Tables)](https://docs.oracle.com/javase/tutorial/uiswing/components/table.html#sorting)
- [TableRowSorter (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/table/TableRowSorter.html)

<!-- dummy comment line for breaking list -->

## コメント
- 「`IndexOutOfBoundsException`が発生する…」は、[TableRowSorterでJTableのソート](https://ateraimemo.com/Swing/TableRowSorter.html)に移動しました。 -- *aterai* 2011-02-04 (金) 15:19:12

<!-- dummy comment line for breaking list -->
