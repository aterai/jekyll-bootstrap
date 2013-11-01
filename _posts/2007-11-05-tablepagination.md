---
layout: post
title: RowFilterでJTableのページ分割
category: swing
folder: TablePagination
tags: [JTable, RowFilter, JRadioButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-11-05

## RowFilterでJTableのページ分割
`JDK 6`で導入された`RowFilter`を使って、`JTable`の行を`Pagination`風に分割して表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUiUh8yiI/AAAAAAAAAmM/eY1zd24d0ac/s800/TablePagination.png)

### サンプルコード
<pre class="prettyprint"><code>private static int LR_PAGE_SIZE = 5;

private final String[] columnNames = {"Year", "String", "Comment"};
private final DefaultTableModel model = new DefaultTableModel(null, columnNames) {
  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return (column==0)?Integer.class:Object.class;
  }
};
private final TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model);
private final Box box = Box.createHorizontalBox();
private void initLinkBox(final int itemsPerPage, final int currentPageIndex) {
  //assert currentPageIndex&gt;0;
  sorter.setRowFilter(new RowFilter&lt;TableModel,Integer&gt;() {
    @Override public boolean include(Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
      int ti = currentPageIndex-1
      int ei = entry.getIdentifier();
      return (ti*itemsPerPage&lt;=ei &amp;&amp; ei&lt;ti*itemsPerPage+itemsPerPage);
    }
  };
}
  ArrayList&lt;JRadioButton&gt; l = new ArrayList&lt;JRadioButton&gt;();

  int startPageIndex = currentPageIndex-LR_PAGE_SIZE;
  if(startPageIndex&lt;=0) startPageIndex = 1;

//#if 0
  //int maxPageIndex = (model.getRowCount()/itemsPerPage)+1;
//#else
  /* "maxPageIndex" gives one blank page if the module of the division is not zero.
   *   pointed out by erServi
   * e.g. rowCount=100, maxPageIndex=100
   */
  int rowCount = model.getRowCount();
  int maxPageIndex = (rowCount/itemsPerPage) + (rowCount%itemsPerPage==0?0:1);
//#endif
  int endPageIndex = currentPageIndex+LR_PAGE_SIZE-1;
  if(endPageIndex&gt;maxPageIndex) endPageIndex = maxPageIndex;

  if(currentPageIndex&gt;1)
    l.add(makePrevNextRadioButton(itemsPerPage, currentPageIndex-1, "Prev"));
  for(int i=startPageIndex;i&lt;=endPageIndex;i++)
    l.add(makeRadioButton(itemsPerPage, currentPageIndex, i));
  if(currentPageIndex&lt;maxPageIndex)
    l.add(makePrevNextRadioButton(itemsPerPage, currentPageIndex+1, "Next"));

  box.removeAll();
  ButtonGroup bg = new ButtonGroup();
  box.add(Box.createHorizontalGlue());
  for(JRadioButton r:l) {
    box.add(r); bg.add(r);
  }
  box.add(Box.createHorizontalGlue());
  box.revalidate();
  box.repaint();
  l.clear();
}
private JRadioButton makeRadioButton(
      final int itemsPerPage, final int current, final int target) {
  JRadioButton radio = new JRadioButton(""+target);
  radio.setForeground(Color.BLUE);
  radio.setUI(ui);
  if(target==current) {
    radio.setSelected(true);
    radio.setForeground(Color.BLACK);
  }
  radio.addActionListener(new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      initLinkBox(itemsPerPage, target);
    }
  });
  return radio;
}
private JRadioButton makePrevNextRadioButton(
      final int itemsPerPage, final int target, String title) {
  JRadioButton radio = new JRadioButton(title);
  radio.setForeground(Color.BLUE);
  radio.setUI(ui);
  radio.addActionListener(new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      initLinkBox(itemsPerPage, target);
    }
  });
  return radio;
}

** 解説 [#uc3887af]
上記のサンプルは、検索サイトなどでよく使われている、`Pagination`を`JTable`で行っています。

%%ただし、ページ数が大量にある場合の処理や、前へ、次へなどの実装は無視して、%%

ある位置から一定の行数だけ表示するフィルタを予め作成し、これを上部の`JRadioButton`(`BasicRadioButtonUI`を継承して見た目だけリンク風になるよう変更している)で切り替えています。

また、モデルのインデックス順でフィルタリングしているため、ソートを行っても表示される行の範囲内で変化します。

- 参考:[[JTableのRowFilterを一旦解除してソート&gt;Swing/ResetRowFilter]], [http://terai.xrea.jp/data/swing/TablePaginationTest.java TablePaginationTest.java]

//**参考リンク
** コメント [#n7c8e61e]
- `Prev`、`Next`ボタンなどを追加して、Google風の`Pagination`を行うように変更しました。 -- [[aterai]] &amp;new{2008-03-26 (水) 20:28:31};
- ブログで指摘されていた恥ずかしいバグ(`paint`メソッドでコンポーネントの状態を変更し、無限ループ、`CPU100%`)を修正 -- [[aterai]] &amp;new{2008-09-07 (日) 00:08:50};
- [http://java-swing-tips.blogspot.com/2008/03/jtable-pagination-example-using.html blogspot]で、無駄な空白ページができるバグを指摘してもらったので、こちらも修正しました。 -- [[aterai]] &amp;new{2011-08-15 (月) 15:54:08};
- 先頭と最後にジャンプするボタンを追加。 -- [[aterai]] &amp;new{2013-11-01 (金) 16:09:21};

#comment
</code></pre>
