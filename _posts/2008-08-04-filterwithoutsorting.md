---
layout: post
title: JTableのRowSorterをフィルタありソート不可にする
category: swing
folder: FilterWithoutSorting
tags: [JTable, TableRowSorter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-08-04

## JTableのRowSorterをフィルタありソート不可にする
フィルタありでソート不可の`TableRowSorter`を作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMr425A3I/AAAAAAAAAZk/ZFpsuUZWGcQ/s800/FilterWithoutSorting.png)

### サンプルコード
<pre class="prettyprint"><code>final TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model) {
  @Override public boolean isSortable(int column) {
    return false;
  }
};
sorter.setRowFilter(new RowFilter&lt;TableModel,Integer&gt;() {
  @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    return entry.getIdentifier() % 2 == 0;
  }
});
</code></pre>

### 解説
上記のサンプルでは、行ファルタだけ利用して、行のソートは出来なくしておきたいので、`sorter`に以下のような設定をしています。

- `DefaultRowSorter#setRowFilter(RowFilter)`で偶数行だけ表示するフィルターを設定
- `DefaultRowSorter#isSortable(int)`をオーバーライドして常に`false`を返す

<!-- dummy comment line for breaking list -->

- - - -
`DefaultRowSorter#setSortable(int, boolean)`を使用して、一部の列だけソート不可にすることもできます。

### 参考リンク
- [DefaultRowSorter (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/DefaultRowSorter.html)
- [JTableHeaderのカラムを選択不可にする](http://terai.xrea.jp/Swing/DisabledHeader.html)

<!-- dummy comment line for breaking list -->

### コメント
