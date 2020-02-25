---
layout: post
category: swing
folder: EmptiesLastTableRowSorter
title: JTableのソートで空文字列を常に末尾にする
tags: [JTable, TableRowSorter, Comparator]
author: aterai
pubdate: 2020-02-17T15:39:55+09:00
description: JTableの空文字列を昇順・降順のどちらでソートしても常に末尾になるようなComparatorを設定します。
image: https://drive.google.com/uc?id=1l9euW_QP9-mgRVSkxLocJ5XBOWphL8a8
comments: true
---
## 概要
`JTable`の空文字列を昇順・降順のどちらでソートしても常に末尾になるような`Comparator`を設定します。

{% download https://drive.google.com/uc?id=1l9euW_QP9-mgRVSkxLocJ5XBOWphL8a8 %}

## サンプルコード
<pre class="prettyprint"><code>class RowComparator implements Comparator&lt;String&gt; {
  protected final int column;
  private final JTable table;

  protected RowComparator(JTable table, int column) {
    this.table = table;
    this.column = column;
  }

  @Override public int compare(String a, String b) {
    int flag = 1;
    List&lt;? extends RowSorter.SortKey&gt; keys = table.getRowSorter().getSortKeys();
    if (!keys.isEmpty()) {
      RowSorter.SortKey sortKey = keys.get(0);
      if (sortKey.getColumn() == column &amp;&amp; sortKey.getSortOrder() == SortOrder.DESCENDING) {
        flag = -1;
      }
    }
    if (a.isEmpty() &amp;&amp; !b.isEmpty()) {
      return flag;
    } else if (!a.isEmpty() &amp;&amp; b.isEmpty()) {
      return -1 * flag;
    } else {
      return a.compareTo(b);
    }
  }
}
</code></pre>

## 解説
- `Comparator<String>#compare(...)`をオーバーライドして、昇順の場合は「空文字列 < 文字列」、降順の場合は、「空文字列 > 文字列」として、常に空文字列以外が優先される`Comparator`を作成して`TableRowSorter#setComparator(...)`ですべての列に設定
    - `JTable`のソートでは`null`は内部でふるい落とされてしまう
        - `@Override public int compare(String a, String b)`の引数`a`、`b`が`null`になることはない
    - 空文字列ではなく`null`が設定されている場合、表示上は同一だが降順ソートすると`null`が先頭にきてしまう

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableでファイルとディレクトリを別々にソート](https://ateraimemo.com/Swing/FileDirectoryComparator.html)

<!-- dummy comment line for breaking list -->

## コメント
