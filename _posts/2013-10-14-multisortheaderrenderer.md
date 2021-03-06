---
layout: post
category: swing
folder: MultisortHeaderRenderer
title: JTableの複数キーを使ったソートをヘッダに表示する
tags: [JTable, JTableHeader, TableRowSorter, Icon]
author: aterai
pubdate: 2013-10-14T00:15:08+09:00
description: JTableの複数キーを使ったソートの状態をヘッダ上に別途表示します。
image: https://lh3.googleusercontent.com/-QNe3lJ3oXH0/Ulqu3vaS91I/AAAAAAAAB3U/Tb2kXiKV8Fs/s800/MultisortHeaderRenderer.png
comments: true
---
## 概要
`JTable`の複数キーを使ったソートの状態をヘッダ上に別途表示します。

{% download https://lh3.googleusercontent.com/-QNe3lJ3oXH0/Ulqu3vaS91I/AAAAAAAAB3U/Tb2kXiKV8Fs/s800/MultisortHeaderRenderer.png %}

## サンプルコード
<pre class="prettyprint"><code>class MultisortHeaderRenderer implements TableCellRenderer {
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    String str = Objects.toString(value, "");
    RowSorter&lt;? extends TableModel&gt; sorter = table.getRowSorter();
    if (Objects.nonNull(sorter)) {
      List&lt;? extends TableRowSorter.SortKey&gt; keys = sorter.getSortKeys();
      for (int i = 0; i &lt; keys.size(); i++) {
        TableRowSorter.SortKey sortKey = keys.get(i);
        if (column == sortKey.getColumn()) {
          String k = sortKey.getSortOrder() == SortOrder.ASCENDING ? "\u25B4 "
                                                                   : "\u25BE ";
          str = String.format("&lt;html&gt;%s&lt;small color='gray'&gt;%s%d", str, k, i + 1);
        }
      }
    }
    TableCellRenderer r = table.getTableHeader().getDefaultRenderer();
    return r.getTableCellRendererComponent(
        table, str, isSelected, hasFocus, row, column);
  }
}
</code></pre>

## 解説
- デフォルト
    - `JTable`の`TableRowSorter`は、デフォルトで最大数`3`の`SortKey`が設定可能
    - このため複数キーを使ったソートを実行できる
    - ただしソートアイコンは第`1`ソートキーの状態のみ`JTableHeader`に表示される
- 上記サンプル
    - `JTableHeader`のセルレンダラーでソートキーを取得し、その状態を文字列にしてヘッダタイトルに追記表示することで存在するソートキーをすべて表示

<!-- dummy comment line for breaking list -->

- - - -
- [Multisort Table Header Cell Renderer « Java Tips Weblog](https://tips4java.wordpress.com/2010/08/29/multisort-table-header-cell-renderer/)
    - 第`2`キー以下を薄く表示するサンプル
    - `Windows 7`でデフォルトの`WindowsLookAndFeel`が使用するヘッダセルレンダラー(ソートのマークが文字列の右ではなく上部に表示される)と併用したい場合は修正が必要
        - この修正を行ったレンダラーを他の`LookAndFeel`で使用すると第`1`ソートキーが非表示になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Multisort Table Header Cell Renderer « Java Tips Weblog](https://tips4java.wordpress.com/2010/08/29/multisort-table-header-cell-renderer/)
- [TableRowSorterでJTableのソート](https://ateraimemo.com/Swing/TableRowSorter.html)
- [JTableのソートアイコンを変更](https://ateraimemo.com/Swing/TableSortIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
