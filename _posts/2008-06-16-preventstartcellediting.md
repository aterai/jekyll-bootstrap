---
layout: post
title: JTableでキー入力によるセル編集開始を禁止する
category: swing
folder: PreventStartCellEditing
tags: [JTable, TableModel, DefaultCellEditor]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-06-16

## JTableでキー入力によるセル編集開始を禁止する
キー入力やマウスクリックによる`JTable`のセル編集開始を禁止します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRLZXQW1I/AAAAAAAAAgw/ufR0d0md6Bc/s800/PreventStartCellEditing.png)

### サンプルコード
<pre class="prettyprint"><code>table.putClientProperty("JTable.autoStartsEdit", Boolean.FALSE);
</code></pre>
<pre class="prettyprint"><code>DefaultCellEditor ce = (DefaultCellEditor)table.getDefaultEditor(Object.class);
ce.setClickCountToStart(Integer.MAX_VALUE);
</code></pre>

### 解説
- `default`
    - `0`列目だけ、編集禁止です。

<!-- dummy comment line for breaking list -->

- `prevent KeyStroke autoStartsEdit`
    - `table.putClientProperty("JTable.autoStartsEdit", Boolean.FALSE);`で、キー入力(<kbd>F2</kbd>は除く)によるセルの編集開始を禁止します。

<!-- dummy comment line for breaking list -->

- `prevent mouse from starting edit`
    - `DefaultCellEditor#setClickCountToStart`に大きな値を設定して、事実上マウスクリックによる編集開始が不可能になっています。

<!-- dummy comment line for breaking list -->

- `start cell editing only F2`
    - 上二つを設定して、セルの編集開始は、<kbd>F2</kbd>キーのみ可能になっています。

<!-- dummy comment line for breaking list -->

- `isCellEditable retrun false`
    - `TableModel#isCellEditable`が常に`false`を返し、セルエディタは起動されません。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [片っ端から忘れていけばいいじゃない。  JTableで、セル上でキータイプされただけでは編集を開始しないようにする。JTable.autoStartsEdit](http://0xc000013a.blog96.fc2.com/blog-entry-19.html)
- [TIPs JTable - Space Of Mind - Confluence](http://www.stateofmind.fr/confluence/display/java/TIPs+JTable)
- [JTableのセルを編集不可にする](http://terai.xrea.jp/Swing/CellEditor.html)
- [JTableでキー入力によるセル編集自動開始を一部禁止する](http://terai.xrea.jp/Swing/FunctionKeyStartEditing.html)

<!-- dummy comment line for breaking list -->

### コメント
