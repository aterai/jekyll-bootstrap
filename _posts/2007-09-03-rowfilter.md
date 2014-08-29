---
layout: post
title: RowFilterでJTableの行をフィルタリング
category: swing
folder: RowFilter
tags: [JTable, TableRowSorter, RowFilter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-09-03

## RowFilterでJTableの行をフィルタリング
`JDK 6`で導入された`TableRowSorter`に`RowFilter`を設定して、行のフィルタリングを行います。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTST-FvjRI/AAAAAAAAAik/ZbU9nuVVCiI/s800/RowFilter.png %}

### サンプルコード
<pre class="prettyprint"><code>final TableRowSorter&lt;? extends TableModel&gt; sorter = new TableRowSorter&lt;&gt;(model);
final Set&lt;RowFilter&lt;? super TestModel, ? super Integer&gt;&gt; filters = new HashSet&lt;&gt;(2);
final RowFilter&lt;TableModel,Integer&gt; filter1 = new RowFilter&lt;TableModel,Integer&gt;() {
  @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    TableModel model = entry.getModel();
    Test t = model.getTest(entry.getIdentifier());
    return !t.getComment().trim().isEmpty();
  }
};
final RowFilter&lt;TableModel,Integer&gt; filter2 = new RowFilter&lt;TableModel,Integer&gt;() {
  @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    return entry.getIdentifier() % 2 == 0;
  }
};
sorter.setRowFilter(RowFilter.andFilter(filters));
//sorter.setRowFilter(filter1);
</code></pre>

### 解説
上記のサンプルは、以下のような複数の行フィルタを、`and`条件で`JTable`に適用することができます。

- コメントが空でない行のみ表示
- 行番号が偶数の場合のみ表示
    - 行番号はソートされている場合でも、元のモデルのインデックスで判断する

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Splash Screens and Java SE 6, and Sorting and Filtering Tables Tech Tips](http://web.archive.org/web/20090419180550/http://java.sun.com/developer/JDCTechTips/2005/tt1115.html)
- [Sorting and Filtering (How to Use Tables)](http://docs.oracle.com/javase/tutorial/uiswing/components/table.html#sorting)

<!-- dummy comment line for breaking list -->

### コメント
- 「`IndexOutOfBoundsException`が発生する…」は、[TableRowSorterでJTableのソート](http://terai.xrea.jp/Swing/TableRowSorter.html)に移動しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-02-04 (金) 15:19:12

<!-- dummy comment line for breaking list -->

