---
layout: post
title: JTableをソートした後の選択状態
category: swing
folder: UpdateSelectionOnSort
tags: [JTable, TableRowSorter, JTableHeader, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-03-24

## JTableをソートした後の選択状態
`JDK 1.6`で導入された`RowSorter`を使って、`JTable`をソートした場合、直前の選択状態がどう変化するかテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTWaXC_E3I/AAAAAAAAApM/H9h2pJw-VSQ/s800/UpdateSelectionOnSort.png)

### サンプルコード
<pre class="prettyprint"><code>table.setUpdateSelectionOnSort(true);
</code></pre>

### 解説
- `UpdateSelectionOnSort`
    - ソート後の選択状態は、`JTable#setUpdateSelectionOnSort`メソッドで切り替えることが出来ます。
    - `setUpdateSelectionOnSort(true)`
        - ソート前と、「同じ内容の行」が選択された状態になる(デフォルト)
    - `setUpdateSelectionOnSort(false)`
        - ソート前と、「表示上同じ行」が選択された状態になる

<!-- dummy comment line for breaking list -->

- `ClearSelectionOnSort`
    - メソッドが用意されているわけではないので、選択状態をクリアする場合は、`TableRowSorter#toggleSortOrder(int)`をオーバーライドしたり、以下のように`JTableHeader`に`MouseListener`を追加して、`table.clearSelection()`する必要があります。
    - チェックなし
        - 選択状態を維持(デフォルト)
    - チェックあり
        - ソート後は選択状態をクリア
        - `JDK 1.5`などで`TableSorter.java`を使用した場合の動作と同じになるように

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.getTableHeader().addMouseListener(new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent e) { //mousePressed(MouseEvent e) {
    if(table.isEditing()) table.getCellEditor().stopCellEditing();
    table.clearSelection();
  }
});
</code></pre>

### コメント
