---
layout: post
title: TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え
category: swing
folder: DnDReorderTable
tags: [JTable, TransferHandler, DragAndDrop]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-09-07

## TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え
`JTable`の行を複数選択し、ドラッグ＆ドロップで並べ替えを可能にする`TransferHandler`を作成します。


{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTLg-5HyXI/AAAAAAAAAXs/Wda5rMSf-1c/s800/DnDReorderTable.png %}

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model);
table.getSelectionModel().setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
table.setTransferHandler(new TableRowTransferHandler());
table.setDropMode(DropMode.INSERT_ROWS);
table.setDragEnabled(true);
</code></pre>

### 解説
上記のサンプルの`TransferHandler`(`JDK 6`で導入された`TransferHandler#canImport`メソッドなどを使用)は、[TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](http://terai.xrea.jp/Swing/DnDReorderList.html)のものとほぼ同じです。

- - - -
[JTableの行をドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDTable.html)とは異なり、複数行を選択して`Drag&Drop`による移動が可能になっています。

### 参考リンク
- [Drag and Drop and Data Transfer: Examples (The Java™ Tutorials > Creating a GUI with JFC/Swing > Drag and Drop and Data Transfer)](http://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/index.html#BasicDnD)
    - [ListTransferHandler.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/DropDemoProject/src/dnd/ListTransferHandler.java)
- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](http://terai.xrea.jp/Swing/DnDReorderList.html)
- [JTableの行をドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDTable.html)
- [JTableの行を別のJTableにドラッグして移動](http://terai.xrea.jp/Swing/DragRowsAnotherTable.html)

<!-- dummy comment line for breaking list -->

### コメント
- テスト -- [aterai](http://terai.xrea.jp/aterai.html) 2009-09-26 (土) 02:19:20
    - [JTableの行を別のJTableにドラッグして移動](http://terai.xrea.jp/Swing/DragRowsAnotherTable.html)に移動。
- このサンプルでは、ソートされた状態での並べ替えは想定していない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2014-02-20 (木) 19:50:30

<!-- dummy comment line for breaking list -->

