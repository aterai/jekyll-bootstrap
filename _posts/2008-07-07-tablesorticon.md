---
layout: post
title: JTableのソートアイコンを変更
category: swing
folder: TableSortIcon
tags: [JTable, JTableHeader, Icon, UIManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-07-07

## JTableのソートアイコンを変更
`JTable`のソートアイコンを非表示にしたり、別の画像に変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTUsaUYVkI/AAAAAAAAAmc/34Qz14LqOGc/s800/TableSortIcon.png)

### サンプルコード
<pre class="prettyprint"><code>UIManager.put("Table.ascendingSortIcon",  new IconUIResource(emptyIcon));
UIManager.put("Table.descendingSortIcon", new IconUIResource(emptyIcon));
</code></pre>

### 解説
上記のサンプルでは、`UIManager`を使用して、以下のようなサイズ`0`の`Icon`や、透過`png`画像などを`JTable`のヘッダに表示されるソートアイコンを変更しています。

<pre class="prettyprint"><code>private static final Icon emptyIcon = new Icon() {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {}
  @Override public int getIconWidth()  { return 0; }
  @Override public int getIconHeight() { return 0; }
};
</code></pre>

### コメント
