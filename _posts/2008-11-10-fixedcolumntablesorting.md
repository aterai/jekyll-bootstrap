---
layout: post
category: swing
folder: FixedColumnTableSorting
title: JTableの列固定とソート
tags: [JTable, TableRowSorter, ChangeListener, JScrollPane, JViewport]
author: aterai
pubdate: 2008-11-10T14:26:25+09:00
description: 列固定したJTableで、JDK 6で導入されたTableRowSorterを使った行ソートを行います。
comments: true
---
## 概要
列固定した`JTable`で、`JDK 6`で導入された`TableRowSorter`を使った行ソートを行います。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMzes1hqI/AAAAAAAAAZw/-m-PZSFzYAk/s800/FixedColumnTableSorting.png %}

## サンプルコード
<pre class="prettyprint"><code>fixedTable = new JTable(model);
table      = new JTable(model);
fixedTable.setSelectionModel(table.getSelectionModel());
fixedTable.setUpdateSelectionOnSort(false);
//table.setUpdateSelectionOnSort(true);

for (int i = model.getColumnCount() - 1; i &gt;= 0; i--) {
  if (i &lt; 2) {
    table.removeColumn(table.getColumnModel().getColumn(i));
    fixedTable.getColumnModel().getColumn(i).setResizable(false);
  } else {
    fixedTable.removeColumn(fixedTable.getColumnModel().getColumn(i));
  }
}

fixedTable.setRowSorter(sorter);
fixedTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
fixedTable.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);

table.setRowSorter(sorter);
table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);

final JScrollPane scroll = new JScrollPane(table);
JViewport viewport = new JViewport();
viewport.setView(fixedTable);
viewport.setPreferredSize(fixedTable.getPreferredSize());
scroll.setRowHeader(viewport);
//scroll.setRowHeaderView(fixedTable);
//fixedTable.setPreferredScrollableViewportSize(fixedTable.getPreferredSize());
scroll.setCorner(JScrollPane.UPPER_LEFT_CORNER, fixedTable.getTableHeader());
scroll.getViewport().setBackground(Color.WHITE);
viewport.setBackground(Color.WHITE);
//&lt;blockquote cite="http://tips4java.wordpress.com/2008/11/05/fixed-column-table/"&gt;
//@auther Rob Camick
//@title Fixed Column Table ≪ Java Tips Weblog
scroll.getRowHeader().addChangeListener(new ChangeListener() {
  @Override public void stateChanged(ChangeEvent e) {
    JViewport viewport = (JViewport) e.getSource();
    scroll.getVerticalScrollBar().setValue(viewport.getViewPosition().y);
  }
});
//&lt;/blockquote&gt;
add(scroll);
</code></pre>

## 解説
左の固定テーブル(`fixedTable`)と、右のテーブル(`table`)に同じ`RowSorter`を設定することで、列固定表でもソートできるようにしています。
ただし、上記のサンプルでは、ソート中に行の追加を行うと例外が発生するので、追加の前に`sorter.setSortKeys(null);`で`SortKeys`をクリアしています。

<pre class="prettyprint"><code>add(new JButton(new AbstractAction("add") {
  @Override public void actionPerformed(ActionEvent e) {
    //List&lt;? extends RowSorter.SortKey&gt; keys = sorter.getSortKeys();
    sorter.setSortKeys(null);
    for (int i = 0; i &lt; 100; i++) {
      model.addRow(new Object[] {i, i + 1, "A" + i, "B" + i});
    }
    //sorter.setSortKeys(keys);
  }
}), BorderLayout.SOUTH);
</code></pre>

- - - -
~~行を追加したとき、うまく描画されない場合があるので、以下のような`JPanel`をラッパーとして使用しています。~~

- 以下を取り違えていたため、描画がおかしくなっていた
    - `JScrollPane#setRowHeaderView(Component)`
    - `JScrollPane#setRowHeader(JViewport)`

<!-- dummy comment line for breaking list -->

- - - -
固定列でキーボードなどによるスクロールに対応するために以下のような`ChangeListener`を追加しています。

- 参考:[Fixed Column Table ≪ Java Tips Weblog](http://tips4java.wordpress.com/2008/11/05/fixed-column-table/)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>scroll.getRowHeader().addChangeListener(new ChangeListener() {
  @Override public void stateChanged(ChangeEvent e) {
    JViewport viewport = (JViewport) e.getSource();
    scroll.getVerticalScrollBar().setValue(viewport.getViewPosition().y);
  }
});
</code></pre>

## 参考リンク
- [FixedColumnExample.java](http://www.google.com/search?q=FixedColumnExample.java)
- [Fixed Column Table ≪ Java Tips Weblog](http://tips4java.wordpress.com/2008/11/05/fixed-column-table/)

<!-- dummy comment line for breaking list -->

## コメント
- <kbd>Tab</kbd>キーによるフォーカスの移動は…、まぁいいかな。 -- *aterai* 2008-11-10 (月) 14:26:25
- 固定列は、数字でソートするように変更。 -- *aterai* 2008-11-10 (月) 15:27:19
- どちらか片方の`JTable`を `setUpdateSelectionOnSort(false);`としてソート後、選択状態がおかしくならないように修正。 -- *aterai* 2010-10-23 (土) 03:13:02
- 下記サイトは別の手法で列を固定しています。ご参考まで。[Freezable JTables (are they extreme?) | Java.net](http://weblogs.java.net/blog/elevy/archive/2009/01/freezable_jtabl.html) -- *panda* 2010-12-22 (水) 15:30:06
    - 情報どうもです。ポップアップで固定する列を決めると、固定列の右が水平スクロールで移動できるのですね。最初、固定の確認でヘッダ列をリサイズしてたので迷いました(^^;。固定中は、`table.getTableHeader().setResizingAllowed(false); table.getTableHeader().setReorderingAllowed(false);`とかで、列のリサイズ、移動を禁止したほうがいいかも。でも、ソートや行選択などが簡単にできるのは便利ですね。 -- *aterai* 2010-12-22 (水) 17:32:51

<!-- dummy comment line for breaking list -->
