---
layout: post
title: JTableのカラム幅を一部だけ固定する
category: swing
folder: FixedWidthColumn
tags: [JTable, JTableHeader, TableColumn]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-02-02

## 概要
`JTable`のヘッダでカラム幅を一部だけ固定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTM9YcNZfI/AAAAAAAAAaA/sbjwdihBwqY/s800/FixedWidthColumn.png %}

## サンプルコード
<pre class="prettyprint"><code>//すべてのヘッダカラムの幅を変更不可に
//tableHeader.setResizingAllowed(false);

//JTable.AUTO_RESIZE_OFFで、あるカラムの幅を変更不可にしたい場合
//table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
//col.setPreferredWidth(50);
//col.setResizable(false);

//カラムの幅を変更不可にしたい場合
TableColumn col = table.getColumnModel().getColumn(0);
col.setMinWidth(50);
col.setMaxWidth(50);
</code></pre>

## 解説
上記のサンプルでは、一番最初のカラム幅が`50px`で固定となるように、`TableColumn#setMaxWidth(int)`、`TableColumn#setMinWidth(int)`を使用しています。カーソルも変化しないようにする場合は、`setResizable(false)`も一緒に指定します。

- メモ
    - `JTableHeader#setResizingAllowed(booelan)`を使うと、すべてのカラム幅が変更不可となる
    - `TableColumn#setResizable(boolean)`は、`JTable#setAutoResizeMode(JTable.AUTO_RESIZE_OFF)`の場合のみ有効
    - `TableColumn#setMaxWidth(int)`、`TableColumn#setMinWidth(int)`を使用して、カラム幅を固定すると、`JTable.AUTO_RESIZE_OFF`でなくても有効

<!-- dummy comment line for breaking list -->

- - - -
以下のようにカラム幅を`0`に固定すると、表示されない列を作成することができます。一時的にカラムを隠したいけど、`JTable#removeColumn(TableColumn)`、`JTable#addColumn(TableColumn)`、`JTable#moveColumn(TableColumn)`のように元の場所に戻すのが面倒なときに使えるかもしれません(ただし、<kbd>Tab</kbd>キーなどによるフォーカス移動がおかしくなります)。

<pre class="prettyprint"><code>TableColumn col = table.getColumnModel().getColumn(1);
col.setMinWidth(0);
col.setMaxWidth(0);
</code></pre>

- - - -
各カラムの幅を固定するのではなく、`JTable`を`2`つ使用して(`model`は`1`つ)あるカラムを常に表示(スクロールで隠れないよう固定)しておく場合は、[Fixed Column Table ≪ Java Tips Weblog](http://tips4java.wordpress.com/2008/11/05/fixed-column-table/)や、[JTableの列固定とソート](http://terai.xrea.jp/Swing/FixedColumnTableSorting.html)などを参照してください。

- - - -
カラムの位置を固定してドラッグなどでの移動を禁止したい場合は、[JTableのヘッダ入れ替えを禁止](http://terai.xrea.jp/Swing/Reordering.html)を参照してください。

## 参考リンク
- [FixedColumnExample](http://www.crionics.com/products/opensource/faq/swing_ex/JTableExamples1.html)
- [Fixed Column Table ≪ Java Tips Weblog](http://tips4java.wordpress.com/2008/11/05/fixed-column-table/)
- [JTableの列固定とソート](http://terai.xrea.jp/Swing/FixedColumnTableSorting.html)

<!-- dummy comment line for breaking list -->

## コメント
