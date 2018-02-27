---
layout: post
category: swing
folder: TriStateSorting
title: TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更
tags: [JTable, TableRowSorter]
author: aterai
pubdate: 2008-09-15T17:36:51+09:00
description: JDK 6で導入されたTableRowSorterのソートを、TableSorter.javaのようにヘッダクリックで昇順、降順、初期状態に切り替わるように設定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWVWrGvdI/AAAAAAAAApE/-DL1kAZzGsM/s800/TriStateSorting.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/09/jdk6-cycle-through-ascending-descending.html
    lang: en
comments: true
---
## 概要
`JDK 6`で導入された`TableRowSorter`のソートを、`TableSorter.java`のようにヘッダクリックで昇順、降順、初期状態に切り替わるように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWVWrGvdI/AAAAAAAAApE/-DL1kAZzGsM/s800/TriStateSorting.png %}

## サンプルコード
<pre class="prettyprint"><code>TableModel model = makeTestTableModel();
JTable table = new JTable(model);
TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model) {
  @Override public void toggleSortOrder(int column) {
    if (column &gt;= 0 &amp;&amp; column &lt; getModelWrapper().getColumnCount() &amp;&amp; isSortable(column)) {
      List&lt;SortKey&gt; keys = new ArrayList&lt;&gt;(getSortKeys());
      if (!keys.isEmpty()) {
        SortKey sortKey = keys.get(0);
        if (sortKey.getColumn() == column &amp;&amp; sortKey.getSortOrder() == SortOrder.DESCENDING) {
          setSortKeys(null);
          return;
        }
      }
    }
    super.toggleSortOrder(column);
  }
};
table.setRowSorter(sorter);
</code></pre>

## 解説
上記のサンプルでは、`TableRowSorter#toggleSortOrder(int)`メソッドをオーバーライドして、クリックした列がソートの第`1`キー、かつソート順序が`DESCENDING`の場合、ソートキーをクリアしています。このため、同じカラムヘッダを連続して`3`回クリックすると、昇順(`ASCENDING`)、降順(`DESCENDING`)、初期状態(`UNSORTED`)と遷移して元の状態に戻ります。

## 参考リンク
- [DefaultRowSorter#toggleSortOrder(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/DefaultRowSorter.html#toggleSortOrder-int-)
- [TableRowSorterでJTableのソート](https://ateraimemo.com/Swing/TableRowSorter.html)
- [TableRowSorterのSortKeysをクリアする](https://ateraimemo.com/Swing/ClearSortingState.html)
- [Java Swing Tips: Apply sort order cycle with ascending, descending, and unsorted in TableRowSorter with multi-key sorting](https://java-swing-tips.blogspot.com/2017/08/apply-sort-order-cycle-with-ascending.html)
    - `setSortKeys(null)`ですべてのソートキーをクリアするのではなく、他のソートキーは維持したまま昇順、降順、初期状態を遷移するサンプル(ssrさんがメールで投稿)

<!-- dummy comment line for breaking list -->

## コメント
- スクリーンショットを更新 -- *aterai* 2008-09-25 (木) 14:23:27

<!-- dummy comment line for breaking list -->
