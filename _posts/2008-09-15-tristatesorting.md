---
layout: post
title: TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更
category: swing
folder: TriStateSorting
tags: [JTable, TableRowSorter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-09-15

## TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更
`JDK 6`で導入された`TableRowSorter`のソートを、`TableSorter.java`のようにヘッダクリックで昇順、降順、初期状態に切り替わるように設定します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWVWrGvdI/AAAAAAAAApE/-DL1kAZzGsM/s800/TriStateSorting.png)

### サンプルコード
<pre class="prettyprint"><code>TableModel model = makeTestTableModel();
JTable table = new JTable(model);
TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model) {
  @Override public void toggleSortOrder(int column) {
    if(column&gt;=0 &amp;&amp; column&lt;getModelWrapper().getColumnCount() &amp;&amp; isSortable(column)) {
      List&lt;SortKey&gt; keys = new ArrayList&lt;SortKey&gt;(getSortKeys());
      if(!keys.isEmpty()) {
        SortKey sortKey = keys.get(0);
        if(sortKey.getColumn()==column &amp;&amp; sortKey.getSortOrder()==SortOrder.DESCENDING) {
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

### 解説
上記のサンプルでは、`TableRowSorter#toggleSortOrder(int)`をオーバーライドして、クリックした列がソートの第一キーで、ソート順序が`DESCENDING`の場合、ソートキーをクリアしています。このため、同じヘッダを三回クリックすると、昇順(`ASCENDING`)、降順(`DESCENDING`)、初期状態(`UNSORTED`)と遷移して元に戻るようになっています。

### 参考リンク
- [TableRowSorterでJTableのソート](http://terai.xrea.jp/Swing/TableRowSorter.html)
- [TableRowSorterのSortKeysをクリアする](http://terai.xrea.jp/Swing/ClearSortingState.html)

<!-- dummy comment line for breaking list -->

### コメント
- スクリーンショットを更新 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-09-25 (木) 14:23:27

<!-- dummy comment line for breaking list -->

