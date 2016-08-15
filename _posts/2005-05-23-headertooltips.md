---
layout: post
category: swing
folder: HeaderTooltips
title: JTableHeaderのTooltipsを列ごとに変更
tags: [JTable, JTableHeader, JToolTip]
author: aterai
pubdate: 2005-05-23
description: JTableHeaderのTooltipsが、カーソルのある列の内容などを表示するようにします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNx5xm6BI/AAAAAAAAAbU/LCSjxDNp8p0/s800/HeaderTooltips.png
comments: true
---
## 概要
`JTableHeader`の`Tooltips`が、カーソルのある列の内容などを表示するようにします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNx5xm6BI/AAAAAAAAAbU/LCSjxDNp8p0/s800/HeaderTooltips.png %}

## サンプルコード
<pre class="prettyprint"><code>JTableHeader header = new JTableHeader(table.getColumnModel()) {
  @Override public String getToolTipText(MouseEvent e) {
    int c = columnAtPoint(e.getPoint());
    return getTable().getColumnName(c) + DUMMY_LONG_TEXT;
  }
};
table.setTableHeader(header);
</code></pre>

## 解説
上記のサンプルでは、`JTableHeader#getToolTipText`メソッドをオーバーライドして、マウスカーソルの下にあるカラムヘッダの名前などを`Tooltips`として返すようにしています。

## 参考リンク
- [JTableのTooltipsを行ごとに変更](http://ateraimemo.com/Swing/RowTooltips.html)
- [JTableのセルがクリップされている場合のみJToolTipを表示](http://ateraimemo.com/Swing/ClippedCellTooltips.html)

<!-- dummy comment line for breaking list -->

## コメント
- 文字列がクリップされている場合だけ、`JToolTip`を表示する -- *aterai* 2009-10-07 (水) 01:00:19
    - [JTableのセルがクリップされている場合のみJToolTipを表示](http://ateraimemo.com/Swing/ClippedCellTooltips.html)に移動 -- *aterai* 2009-10-12 (月) 17:43:41

<!-- dummy comment line for breaking list -->
