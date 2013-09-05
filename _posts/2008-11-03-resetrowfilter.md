---
layout: post
title: JTableのRowFilterを一旦解除してソート
category: swing
folder: ResetRowFilter
tags: [JTable, RowFilter, TableRowSorter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-11-03

## JTableのRowFilterを一旦解除してソート
`JTable`の`RowFilter`を一旦解除してソートし、再びフィルタを設定することで表示される行を更新します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTRuQZLwOI/AAAAAAAAAho/ovjovr-5nuI/s800/ResetRowFilter.png)

### サンプルコード
<pre class="prettyprint"><code>final RowFilter&lt;TableModel, Integer&gt; filter = new RowFilter&lt;TableModel, Integer&gt;() {
  @Override public boolean include(Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    int vidx = table.convertRowIndexToView(entry.getIdentifier());
    return vidx&lt;USER_SPECIFIED_NUMBER_OF_ROWS;
  }
};
final TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model) {
  @Override public void toggleSortOrder(int column) {
    if(check.isSelected()) {
      RowFilter&lt;? super TableModel, ? super Integer&gt; f = getRowFilter();
      setRowFilter(null);
      super.toggleSortOrder(column);
      setRowFilter(f);
    }else{
      super.toggleSortOrder(column);
    }
  }
};
table.setRowSorter(sorter);
sorter.setSortKeys(Arrays.asList(new RowSorter.SortKey(1, SortOrder.DESCENDING)));
</code></pre>

### 解説
上記のサンプルでは、A.`viewRowIndex<5`をチェックすると、ソートされていても表示上の`0`から`4`行目までの`5`行のみ表示されるフィルタがかかります。

- `Costom Sorting`チェック無し
    - Aのフィルタで「AA-ee」が表示されている場合、`String`列で昇順から降順にソートすると「ee-AA」となる

<!-- dummy comment line for breaking list -->

- `Costom Sorting` チェック有り
    - Aのフィルタで「AA-ee」が表示されている場合、`String`列で昇順から降順にソートすると「OO-KK」となる
        - `toggleSortOrder`メソッドをオーバーライドして、一旦`RowFilter`を解除(`setRowFilter(null)`)してから昇順から降順にソート「OO-KK-AA」、その後再び`RowFilter`を設定するので「OO-KK」が表示される

<!-- dummy comment line for breaking list -->

- - - -
以下は、`toggleSortOrder`メソッドをオーバーライドし、すべての行が変更されている可能性があることをリスナーに通知してから、もう一度ソートのやり直しを行う方法です。

<pre class="prettyprint"><code>final TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model) {
  @Override public void toggleSortOrder(int column) {
    super.toggleSortOrder(column);
    if(check.isSelected()) {
      model.fireTableDataChanged();
      //??? allRowsChanged();
      //modelRowCount = getModelWrapper().getRowCount();
      sort();
    }
  }
};
</code></pre>

### 参考リンク
- [Specification for the javax.swing.DefaultRowSorter.setSortsOnUpdates/rowsUpdated method is not clear](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6301297)

<!-- dummy comment line for breaking list -->

### コメント
- もっと簡単な方法がありそう・・・。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-11-03 (月) 16:35:24

<!-- dummy comment line for breaking list -->
