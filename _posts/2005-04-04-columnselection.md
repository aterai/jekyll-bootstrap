---
layout: post
title: JTableHeaderをクリックしてそのColumnのセルを全選択
category: swing
folder: ColumnSelection
tags: [JTable, JTableHeader, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-04-04

## JTableHeaderをクリックしてそのColumnのセルを全選択
`JTableHeader`をクリックしたとき、その`Column`以下にあるセルを全選択します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJrC8DyhI/AAAAAAAAAUw/SO1wMAudBiE/s800/ColumnSelection.png %}

### サンプルコード
<pre class="prettyprint"><code>final JTable table = new JTable(model);
table.setCellSelectionEnabled(true);
final JTableHeader header = table.getTableHeader();
header.addMouseListener(new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    if(!check.isSelected()) return;
    if(table.isEditing()) {
      table.getCellEditor().stopCellEditing();
    }
    int col = header.columnAtPoint(e.getPoint());
    table.changeSelection(0, col, false, false);
    table.changeSelection(table.getRowCount()-1, col, false, true);
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JTableHeader`にマウスリスナーを追加し、`JTableHeader#columnAtPoint(Point)`メソッドを使って、クリックされた`Column`を取得するようになっています。

`Column`全体の選択は、`changeSelection`メソッドを二回使用することで行っています。

### 参考リンク
- [JTableに行ヘッダを追加](http://terai.xrea.jp/Swing/TableRowHeader.html)
    - 行ヘッダをクリックして行の全選択

<!-- dummy comment line for breaking list -->

### コメント
- メモ: `2008-03-11`に[JTableのセルにあるフォーカスを解除](http://terai.xrea.jp/Swing/AnchorSelection.html)から移動でこのページを作成。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-02-20 (水) 15:21:27

<!-- dummy comment line for breaking list -->

