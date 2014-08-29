---
layout: post
title: JTableの複数キーを使ったソートをヘッダに表示する
category: swing
folder: MultisortHeaderRenderer
tags: [JTable, JTableHeader, TableRowSorter, Icon]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-10-14

## JTableの複数キーを使ったソートをヘッダに表示する
`JTable`の複数キーを使ったソートの状態をヘッダ上に別途表示します。

{% download https://lh3.googleusercontent.com/-QNe3lJ3oXH0/Ulqu3vaS91I/AAAAAAAAB3U/Tb2kXiKV8Fs/s800/MultisortHeaderRenderer.png %}

### サンプルコード
<pre class="prettyprint"><code>class MultisortHeaderRenderer implements TableCellRenderer {
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected,
      boolean hasFocus, int row, int column) {
    if(table.getRowSorter()!=null) {
      List&lt;?&gt; keys = table.getRowSorter().getSortKeys();
      int max = keys.size();
      for(int i=0; i&lt;max; i++) {
        TableRowSorter.SortKey sortKey = (TableRowSorter.SortKey)keys.get(i);
        if(column==sortKey.getColumn()) {
          String k = sortKey.getSortOrder()==SortOrder.ASCENDING
            ? "\u25B4 " : "\u25BE ";
          value = "&lt;html&gt;"+value.toString()+" &lt;small color='gray'&gt;"+k+(i+1);
        }
      }
    }
    TableCellRenderer r = table.getTableHeader().getDefaultRenderer();
    return r.getTableCellRendererComponent(
        table, value, isSelected, hasFocus, row, column);
  }
}
</code></pre>

### 解説
`JTable`の`TableRowSorter`は、デフォルトで最大数`3`の`SortKey`が設定されているため、複数キーを使ったソートが可能ですが、`JTableHeader`には第一ソートキーの状態だけが表示されます。
このサンプルでは、ヘッダのセルレンダラー内部でソートキーを取得し、その状態を文字列にしてヘッダタイトルに追記表示することで識別できるようにしています。

- - - -
- [Multisort Table Header Cell Renderer « Java Tips Weblog](http://tips4java.wordpress.com/2010/08/29/multisort-table-header-cell-renderer/)
    - 第二キー以下を薄く表示するサンプルがあります。
    - `Windows 7`でデフォルトの`WindowsLookAndFeel`が使用するヘッダレンダラー(ソートのマークが文字列の右ではなく上部に表示される)と併用したい場合、少し面倒な修正が必要になります。
        - この修正を行ったレンダラーを他の`LookAndFeel`で使用すると第一ソートキーが非表示になります。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Multisort Table Header Cell Renderer « Java Tips Weblog](http://tips4java.wordpress.com/2010/08/29/multisort-table-header-cell-renderer/)
- [TableRowSorterでJTableのソート](http://terai.xrea.jp/Swing/TableRowSorter.html)
- [JTableのソートアイコンを変更](http://terai.xrea.jp/Swing/TableSortIcon.html)

<!-- dummy comment line for breaking list -->

### コメント
