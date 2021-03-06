---
layout: post
category: swing
folder: TableBackground
title: JTableの背景色を変更
tags: [JTable, JViewport, JScrollPane, JColorChooser]
author: aterai
pubdate: 2004-08-02T01:28:45+09:00
description: JTableを追加したJViewportがセルで隠れていない部分の色を変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUV7me60I/AAAAAAAAAl4/PQqRFaxI6XA/s800/TableBackground.png
comments: true
---
## 概要
`JTable`を追加した`JViewport`がセルで隠れていない部分の色を変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUV7me60I/AAAAAAAAAl4/PQqRFaxI6XA/s800/TableBackground.png %}

## サンプルコード
<pre class="prettyprint"><code>//JScrollPane scroll = new JScrollPane(table);
scroll.getViewport().add(table);
scroll.getViewport().setOpaque(true);
scroll.getViewport().setBackground(Color.WHITE);
//table.getParent().setBackground(Color.WHITE);
</code></pre>

## 解説
このページのタイトルなどで「`JTable`の背景色」としている部分は、実際は`JTable`の背景色ではなく、`JTable`を追加した`JViewport`がセルで隠れていない領域を表しています。

このため、上記のスクリーンショットのように色をつけたい場合は、`JTable`自身の背景色を設定するのではなく、`JViewport`の背景色を設定する必要があります。サンプルコードでは`JScrollPane`から`JViewport`を取得していますが、`JTable#getParent()`メソッドからも`JViewport`を取得できます。

上記のサンプルでは、背景色を不透明にするを選択して背景色を設定すると`JViewport`の背景色が変更されます。

- - - -
セルの背景色を変更する場合は、`TableCellRenderer`を使用([TableCellRendererでセルの背景色を変更](https://ateraimemo.com/Swing/StripeTable.html))します。

- - - -
ヘッダの背景色(カラムをマウスでドラッグ中に表示される)を変更する場合は、空の`JViewport`を`JScrollPane`のカラムヘッダに追加して、その背景色を変更します。

<pre class="prettyprint"><code>scroll.setColumnHeader(new JViewport());
//or scroll.setColumnHeaderView(new JLabel());
scroll.getColumnHeader().setBackground(Color.RED);
</code></pre>

- - - -
`JDK 1.6.0`で追加された`JTable#setFillsViewportHeight`メソッドを使用して`JTable`を`JViewport`の高さまで拡張しておけば、直接`JTable`の背景色を設定するだけでこのサンプルと同様の状態になります。(参考: [JTable自体の高さを拡張](https://ateraimemo.com/Swing/FillsViewportHeight.html))。

## 参考リンク
- [JTable自体の高さを拡張](https://ateraimemo.com/Swing/FillsViewportHeight.html)
- [TableCellRendererでセルの背景色を変更](https://ateraimemo.com/Swing/StripeTable.html)
- [JTableに行ヘッダを追加](https://ateraimemo.com/Swing/TableRowHeader.html)

<!-- dummy comment line for breaking list -->

## コメント
