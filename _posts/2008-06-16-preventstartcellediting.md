---
layout: post
category: swing
folder: PreventStartCellEditing
title: JTableでキー入力によるセル編集開始を禁止する
tags: [JTable, TableModel, DefaultCellEditor]
author: aterai
pubdate: 2008-06-16T13:18:37+09:00
description: キー入力やマウスクリックによるJTableのセル編集開始を禁止します。
comments: true
---
## 概要
キー入力やマウスクリックによる`JTable`のセル編集開始を禁止します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRLZXQW1I/AAAAAAAAAgw/ufR0d0md6Bc/s800/PreventStartCellEditing.png %}

## サンプルコード
<pre class="prettyprint"><code>table.putClientProperty("JTable.autoStartsEdit", Boolean.FALSE);
</code></pre>
<pre class="prettyprint"><code>DefaultCellEditor ce = (DefaultCellEditor) table.getDefaultEditor(Object.class);
ce.setClickCountToStart(Integer.MAX_VALUE);
</code></pre>

## 解説
- `default`(上記のサンプルでのデフォルト)
    - `0`列目だけ`TableModel#isCellEditable`が`false`を返すように設定
- `prevent KeyStroke autoStartsEdit`
    - `table.putClientProperty("JTable.autoStartsEdit", Boolean.FALSE);`で、キー入力(<kbd>F2</kbd>は除く)によるセルの編集開始を禁止
- `prevent mouse from starting edit`
    - `DefaultCellEditor#setClickCountToStart`に大きな値を設定して、事実上マウスクリックによる編集開始を禁止
- `start cell editing only F2`
    - 上二つを設定して、セルの編集開始は<kbd>F2</kbd>キーのみ可能に設定
- `isCellEditable retrun false`
    - `TableModel#isCellEditable`が常に`false`を返すように設定し、すべてのカラムでセルエディタの起動を禁止

<!-- dummy comment line for breaking list -->

## 参考リンク
- [片っ端から忘れていけばいいじゃない。  JTableで、セル上でキータイプされただけでは編集を開始しないようにする。JTable.autoStartsEdit](http://0xc000013a.blog96.fc2.com/blog-entry-19.html)
- [TIPs JTable - Space Of Mind - Confluence](http://www.stateofmind.fr/confluence/display/java/TIPs+JTable)
- [JTableのセルを編集不可にする](http://ateraimemo.com/Swing/CellEditor.html)
- [JTableでキー入力によるセル編集自動開始を一部禁止する](http://ateraimemo.com/Swing/FunctionKeyStartEditing.html)

<!-- dummy comment line for breaking list -->

## コメント
