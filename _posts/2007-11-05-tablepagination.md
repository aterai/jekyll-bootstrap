---
layout: post
category: swing
folder: TablePagination
title: RowFilterでJTableのページ分割
tags: [JTable, RowFilter, JRadioButton]
author: aterai
pubdate: 2007-11-05T14:35:32+09:00
description: JDK 6で導入されたRowFilterを使って、JTableの行をPagination風に分割して表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUiUh8yiI/AAAAAAAAAmM/eY1zd24d0ac/s800/TablePagination.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2008/03/jtable-pagination-example-using.html
    lang: en
comments: true
---
## 概要
`JDK 6`で導入された`RowFilter`を使って、`JTable`の行を`Pagination`風に分割して表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUiUh8yiI/AAAAAAAAAmM/eY1zd24d0ac/s800/TablePagination.png %}

## サンプルコード
<pre class="prettyprint"><code>private static int LR_PAGE_SIZE = 5;

private final String[] columnNames = {"Year", "String", "Comment"};
private final DefaultTableModel model = new DefaultTableModel(null, columnNames) {
  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return (column == 0) ? Integer.class : Object.class;
  }
};
private TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model);
private Box box = Box.createHorizontalBox();

private void initLinkBox(final int itemsPerPage, final int currentPageIndex) {
  //assert currentPageIndex &gt; 0;
  sorter.setRowFilter(new RowFilter&lt;TableModel, Integer&gt;() {
    @Override
    public boolean include(Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
      int ti = currentPageIndex - 1;
      int ei = entry.getIdentifier();
      return ti * itemsPerPage &lt;= ei &amp;&amp; ei &lt; ti * itemsPerPage + itemsPerPage;
    }
  });

  int startPageIndex = currentPageIndex - LR_PAGE_SIZE;
  if (startPageIndex &lt;= 0) {
    startPageIndex = 1;
  }

//#if 0 //BUG
  //int maxPageIndex = (model.getRowCount() / itemsPerPage) + 1;
//#else
  /* "maxPageIndex" gives one blank page if the module of the division is not zero.
   *   pointed out by erServi
   * e.g. rowCount=100, maxPageIndex=100
   */
  int rowCount = model.getRowCount();
  int v = rowCount % itemsPerPage == 0 ? 0 : 1;
  int maxPageIndex = rowCount / itemsPerPage + v;
//#endif
  int endPageIndex = currentPageIndex + LR_PAGE_SIZE - 1;
  if (endPageIndex &gt; maxPageIndex) {
    endPageIndex = maxPageIndex;
  }

  box.removeAll();
  if (startPageIndex &gt;= endPageIndex) {
    //if I only have one page, Y don't want to see pagination buttons
    //suggested by erServi
    return;
  }

  ButtonGroup bg = new ButtonGroup();
  JRadioButton f = makePrevNextRadioButton(
      itemsPerPage, 1, "|&lt;", currentPageIndex &gt; 1);
  box.add(f);
  bg.add(f);
  JRadioButton p = makePrevNextRadioButton(
      itemsPerPage, currentPageIndex - 1, "&lt;", currentPageIndex &gt; 1);
  box.add(p);
  bg.add(p);
  box.add(Box.createHorizontalGlue());
  for (int i = startPageIndex; i &lt;= endPageIndex; i++) {
    JRadioButton c = makeRadioButton(itemsPerPage, currentPageIndex, i);
    box.add(c);
    bg.add(c);
  }
  box.add(Box.createHorizontalGlue());
  JRadioButton n = makePrevNextRadioButton(
      itemsPerPage, currentPageIndex + 1, "&gt;", currentPageIndex &lt; maxPageIndex);
  box.add(n);
  bg.add(n);
  JRadioButton l = makePrevNextRadioButton(
      itemsPerPage, maxPageIndex, "&gt;|", currentPageIndex &lt; maxPageIndex);
  box.add(l);
  bg.add(l);
  box.revalidate();
  box.repaint();
}
</code></pre>

## 解説
上記のサンプルは、検索サイトなどでよく使われている、`Pagination`を`JTable`で行っています。

ある位置から一定の行数だけ表示するフィルタを予め作成し、これを上部の`JRadioButton`(`BasicRadioButtonUI`を継承して見た目だけリンク風に変更)で切り替えています。

また、モデルのインデックス順でフィルタリングしているため、ソートを行っても表示される行の範囲内で変化します。

- 参考: [JTableのRowFilterを一旦解除してソート](http://ateraimemo.com/Swing/ResetRowFilter.html)
    - [TablePaginationTest.java](http://ateraimemo.com/data/swing/TablePaginationTest.java)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのPaginationとSwingWorkerでの逐次読み込み](http://ateraimemo.com/Swing/PageInputForPagination.html)

<!-- dummy comment line for breaking list -->

## コメント
- `Prev`、`Next`ボタンなどを追加して、Google風の`Pagination`を行うように変更しました。 -- *aterai* 2008-03-26 (水) 20:28:31
- ブログで指摘されていた恥ずかしいバグ(`paint`メソッドでコンポーネントの状態を変更し、無限ループ、`CPU100%`)を修正 -- *aterai* 2008-09-07 (日) 00:08:50
- [blogspot](http://java-swing-tips.blogspot.com/2008/03/jtable-pagination-example-using.html)で、無駄な空白ページができるバグを指摘してもらったので、こちらも修正しました。 -- *aterai* 2011-08-15 (月) 15:54:08
- 先頭と最後にジャンプするボタンを追加。 -- *aterai* 2013-11-01 (金) 16:09:21

<!-- dummy comment line for breaking list -->
