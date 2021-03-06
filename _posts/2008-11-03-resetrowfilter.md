---
layout: post
category: swing
folder: ResetRowFilter
title: JTableのRowFilterを一旦解除してソート
tags: [JTable, RowFilter, TableRowSorter]
author: aterai
pubdate: 2008-11-03T16:35:24+09:00
description: JTableのRowFilterを一旦解除してソートし、再びフィルタを設定することで表示される行を更新します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTRuQZLwOI/AAAAAAAAAho/ovjovr-5nuI/s800/ResetRowFilter.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/03/reset-rowfilter-before-sorting.html
    lang: en
comments: true
---
## 概要
`JTable`の`RowFilter`を一旦解除してソートし、再びフィルタを設定することで表示される行を更新します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTRuQZLwOI/AAAAAAAAAho/ovjovr-5nuI/s800/ResetRowFilter.png %}

## サンプルコード
<pre class="prettyprint"><code>final RowFilter&lt;TableModel, Integer&gt; filter = new RowFilter&lt;TableModel, Integer&gt;() {
  @Override public boolean include(Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    int vidx = table.convertRowIndexToView(entry.getIdentifier());
    return vidx &lt; USER_SPECIFIED_NUMBER_OF_ROWS;
  }
};
final TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model) {
  @Override public void toggleSortOrder(int column) {
    if (check.isSelected()) {
      RowFilter&lt;? super TableModel, ? super Integer&gt; f = getRowFilter();
      setRowFilter(null);
      super.toggleSortOrder(column);
      setRowFilter(f);
    } else {
      super.toggleSortOrder(column);
    }
  }
};
table.setRowSorter(sorter);
sorter.setSortKeys(Arrays.asList(new RowSorter.SortKey(1, SortOrder.DESCENDING)));
</code></pre>

## 解説
上記のサンプルでは、☑ `viewRowIndex<5`をチェックすると、ソート状態とは無関係に表示上の`0`から`4`行目までの`5`行のみ表示されるフィルタが掛かります。

- `Custom Sorting`チェック無し
    - ☑ `viewRowIndex<5`のフィルタで`AA-ee`が表示されている場合、`String`列で昇順から降順にソートすると`ee-AA`となる
- `Custom Sorting` チェック有り
    - ☑ `viewRowIndex<5`のフィルタで`AA-ee`が表示されている場合、`String`列で昇順から降順にソートすると`OO-KK`となる
        - `toggleSortOrder`メソッドをオーバーライドして、一旦`TableRowSorter#setRowFilter(null)`を実行して`RowFilter`を解除してから昇順から降順にソート`OO-KK-AA`、その後再び`RowFilter`を設定するので`OO-KK`が表示される

<!-- dummy comment line for breaking list -->

- - - -
以下は、`toggleSortOrder`メソッドをオーバーライドし、すべての行が変更されている可能性があることをリスナーに通知してから、もう一度ソートのやり直しを行う方法です。

<pre class="prettyprint"><code>TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model) {
  @Override public void toggleSortOrder(int column) {
    super.toggleSortOrder(column);
    if (check.isSelected()) {
      model.fireTableDataChanged();
      //??? allRowsChanged();
      //modelRowCount = getModelWrapper().getRowCount();
      sort();
    }
  }
};
</code></pre>

## 参考リンク
- [Specification for the javax.swing.DefaultRowSorter.setSortsOnUpdates/rowsUpdated method is not clear](https://bugs.openjdk.java.net/browse/JDK-6301297)

<!-- dummy comment line for breaking list -->

## コメント
- もっと簡単な方法がありそう・・・。 -- *aterai* 2008-11-03 (月) 16:35:24

<!-- dummy comment line for breaking list -->
