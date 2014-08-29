---
layout: post
title: JTableHeaderにJPopupMenuを追加してソート
category: swing
folder: RowSorterPopupMenu
tags: [JTable, JTableHeader, JPopupMenu, PopupMenuListener, TableRowSorter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-12-07

## JTableHeaderにJPopupMenuを追加してソート
`JTableHeader`に`JPopupMenu`を追加してソートします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSY9WWpNI/AAAAAAAAAis/Z0YqvftAIh8/s800/RowSorterPopupMenu.png %}

### サンプルコード
<pre class="prettyprint"><code>private class TablePopupMenu extends JPopupMenu {
  private final List&lt;SortAction&gt; actions = Arrays.asList(
    new SortAction(SortOrder.ASCENDING),
    new SortAction(SortOrder.DESCENDING));
    //new SortAction(SortOrder.UNSORTED));
  public TablePopupMenu() {
    super();
    for(Action a:actions) add(a);
  }
  @Override public void show(Component c, int x, int y) {
    JTableHeader h = (JTableHeader)c;
    int i = h.columnAtPoint(new Point(x, y));
    i = h.getTable().convertColumnIndexToModel(i);
    for(SortAction a:actions) a.setIndex(i);
    super.show(c, x, y);
  }
}
private class SortAction extends AbstractAction{
  private final SortOrder dir;
  public SortAction(SortOrder dir) {
    super(dir.toString());
    this.dir = dir;
  }
  private int index = -1;
  public void setIndex(int index) {
    this.index = index;
  }
  @Override public void actionPerformed(ActionEvent e) {
    table.getRowSorter().setSortKeys(Arrays.asList(
      new RowSorter.SortKey(index, dir)));
  }
}
</code></pre>

### 解説
上記のサンプルでは、マウスカーソルの下にある`JTableHeader`カラムをクリック(`WindowsLookAndFeel`:右クリック)することで、`JPopupMenu`を表示してソートすることができます。

- 左クリックではソートしない

<!-- dummy comment line for breaking list -->

- - - -
ソートしたあとで、`JTableHeader`のフォーカスペイントをクリアするために以下のような`PopupMenuListener`を追加しています。

<pre class="prettyprint"><code>JPopupMenu pop = new TablePopupMenu();
final JTableHeader header = table.getTableHeader();
header.setComponentPopupMenu(pop);
pop.addPopupMenuListener(new PopupMenuListener() {
  @Override public void popupMenuCanceled(PopupMenuEvent e) {}
  @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
    //System.out.println("popupMenuWillBecomeInvisible");
    header.setDraggedColumn(null);
    //header.setResizingColumn(null);
    header.repaint();
  }
  @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {}
});
</code></pre>

### コメント
