---
layout: post
title: JTableの背景色を変更
category: swing
folder: TableBackground
tags: [JTable, JViewport, JScrollPane]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-08-02

## JTableの背景色を変更
`JTable`を追加した`JViewport`がセルで隠れていない部分の色を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTUV7me60I/AAAAAAAAAl4/PQqRFaxI6XA/s800/TableBackground.png)

### サンプルコード
<pre class="prettyprint"><code>//JScrollPane scroll = new JScrollPane(table);
scroll.getViewport().add(table);
scroll.getViewport().setOpaque(true);
scroll.getViewport().setBackground(Color.WHITE);
//table.getParent().setBackground(Color.WHITE);
</code></pre>

### 解説
このページのタイトルなどで「`JTable`の背景色」としている部分は、実際は`JTable`の背景色ではなく、`JTable`を追加した`JViewport`がセルで隠れていない部分のことです。

このため、上記のスクリーンショットのように色をつけたい場合は、`JTable`自身の背景色を設定するのではなく、`JViewport`の背景色を設定する必要があります。サンプルコードでは`JScrollPane`から`JViewport`を取得していますが、`JTable#getParent()`メソッドからも`JViewport`を取得することができます。

上記のサンプルでは、背景色を不透明にするを選択して背景色を設定してやると、`JViewport`の背景色が変更されます。

セルの背景色を変更する場合は、`TableCellRenderer`を使用([TableCellRendererでセルの背景色を変更](http://terai.xrea.jp/Swing/StripeTable.html))します。

- - - -
`JDK 1.6.0`で追加された`JTable#setFillsViewportHeight`メソッドを使用すると、`JTable`の背景色を設定すれば、`JViewport`の背景色を設定する必要はありません(参考:[JTable自体の高さを拡張](http://terai.xrea.jp/Swing/FillsViewportHeight.html))。

### 参考リンク
- [JTable自体の高さを拡張](http://terai.xrea.jp/Swing/FillsViewportHeight.html)
- [TableCellRendererでセルの背景色を変更](http://terai.xrea.jp/Swing/StripeTable.html)
- [JTableに行ヘッダを追加](http://terai.xrea.jp/Swing/TableRowHeader.html)

<!-- dummy comment line for breaking list -->

### コメント