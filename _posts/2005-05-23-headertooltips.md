---
layout: post
title: JTableHeaderのTooltipsを列ごとに変更
category: swing
folder: HeaderTooltips
tags: [JTable, JTableHeader, JToolTip]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-05-23

## JTableHeaderのTooltipsを列ごとに変更
`JTableHeader`の`Tooltips`が、カーソルのある列の内容などを表示するようにします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNx5xm6BI/AAAAAAAAAbU/LCSjxDNp8p0/s800/HeaderTooltips.png)

### サンプルコード
<pre class="prettyprint"><code>JTableHeader header = new JTableHeader(table.getColumnModel()) {
  @Override public String getToolTipText(MouseEvent e) {
    int c = columnAtPoint(e.getPoint());
    return getTable().getColumnName(c)
      +"################################";
  }
};
table.setTableHeader(header);
</code></pre>

### 解説
上記のサンプルでは、`JTableHeader#getToolTipText`メソッドをオーバーライドして、マウスカーソルの下にあるカラムヘッダの名前などを`Tooltips`として返すようにしています。

### 参考リンク
- [JTableのTooltipsを行ごとに変更](http://terai.xrea.jp/Swing/RowTooltips.html)
- [JTableのセルがクリップされている場合のみJToolTipを表示](http://terai.xrea.jp/Swing/ClippedCellTooltips.html)

<!-- dummy comment line for breaking list -->

### コメント
- 文字列がクリップされている場合だけ、`JToolTip`を表示する -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-07 (水) 01:00:19
    - [JTableのセルがクリップされている場合のみJToolTipを表示](http://terai.xrea.jp/Swing/ClippedCellTooltips.html)に移動 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-12 (月) 17:43:41

<!-- dummy comment line for breaking list -->

