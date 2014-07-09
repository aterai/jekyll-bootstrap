---
layout: post
title: JTableのリサイズで最後のTableColumnのみリサイズする
category: swing
folder: ResizingColumnAndTable
tags: [JTable, JTableHeader, TableColumn]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-05-26

## JTableのリサイズで最後のTableColumnのみリサイズする
`JTable`がリサイズされた場合、最後にある`TableColumn`がその幅の変更を吸収するように設定します。主に、[java - JTable columns doesnt resize probably when JFrame resize - Stack Overflow](http://stackoverflow.com/questions/23201818/jtable-columns-doesnt-resize-probably-when-jframe-resize)の回答からソースを引用しています。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-uhbVwRqsa2g/U4HyPhrI8PI/AAAAAAAACF8/OJXWaFVxavE/s800/ResizingColumnAndTable.png)

### サンプルコード
<pre class="prettyprint"><code>private final JTable table = new JTable(100, 3) {
  private transient ComponentListener resizeHandler;
  @Override public void updateUI() {
    removeComponentListener(resizeHandler);
    super.updateUI();
    resizeHandler = new ComponentAdapter() {
      @Override public void componentResized(ComponentEvent e) {
        JTable table = (JTable) e.getComponent();
        JTableHeader tableHeader = table.getTableHeader();
        if (tableHeader != null) {
          tableHeader.setResizingColumn(null);
        }
      }
    };
    addComponentListener(resizeHandler);
  }
  //http://stackoverflow.com/questions/16368343/jtable-resize-only-selected-column-when-container-size-changes
  //http://stackoverflow.com/questions/23201818/jtable-columns-doesnt-resize-probably-when-jframe-resize
  @Override public void doLayout() {
    if (tableHeader != null &amp;&amp; autoResizeMode != AUTO_RESIZE_OFF &amp;&amp; check.isSelected()) {
      TableColumn resizingColumn = tableHeader.getResizingColumn();
      if (resizingColumn == null) {
        TableColumnModel tcm = getColumnModel();
        int lastColumn = tcm.getColumnCount() - 1;
        tableHeader.setResizingColumn(tcm.getColumn(lastColumn));
      }
    }
    super.doLayout();
  }
};
</code></pre>

### 解説
上記のサンプルでは、`JTable#doLayout()`をオーバーライドして、`JFrame`がリサイズされた、`JTable`、`JTableHeader`もリサイズされたら、`JTableHeader.setResizingColumn(...)`で最後の`TableColumn`を設定し、幅の変更をすべて吸収するようにしています。

- 注:
    - `table.setAutoResizeMode(JTable.AUTO_RESIZE_LAST_COLUMN);`を設定しても、`JTableHeader`自体のリサイズではすべての`TableColumn`の幅が均等に変化する
    - 列を入れ替えた場合でも、表示上最後にある`TableColumn`がリサイズされる
    - チェックボックスで設定を切り替えているため、`JTable`に`ComponentListener`を追加して、変更ごとに`JTableHeader.setResizingColumn(null)`でリセット
    - 以下のように、`JTable#doLayout()`をオーバーライドではなく、`ComponentListener`の追加でも同様の動作をするように設定することができるが、リサイズ開始時に最後の`TableColumn`にも幅の変更が適用されてしまう(先に`JTable#doLayout()`が実行される)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JTable table2 = new JTable(100, 3);
table2.getTableHeader().addComponentListener(new ComponentAdapter() {
  @Override public void componentResized(ComponentEvent e) {
    JTableHeader tableHeader = (JTableHeader) e.getComponent();
    if (tableHeader == null) {
      return;
    }
    if (check.isSelected()) {
      TableColumnModel tcm = tableHeader.getTable().getColumnModel();
      int lastColumn = tcm.getColumnCount() - 1;
      tableHeader.setResizingColumn(tcm.getColumn(lastColumn));
    } else {
      tableHeader.setResizingColumn(null);
    }
  }
});
</code></pre>

### 参考リンク
- [java - JTable columns doesnt resize probably when JFrame resize - Stack Overflow](http://stackoverflow.com/questions/23201818/jtable-columns-doesnt-resize-probably-when-jframe-resize)
- [java - JTable resize only selected column when container size changes - Stack Overflow](http://stackoverflow.com/questions/16368343/jtable-resize-only-selected-column-when-container-size-changes)

<!-- dummy comment line for breaking list -->

### コメント