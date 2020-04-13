---
layout: post
category: swing
folder: DnDReorderTable
title: TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え
tags: [JTable, TransferHandler, DragAndDrop]
author: aterai
pubdate: 2009-09-07T15:58:48+09:00
description: JTableの行を複数選択し、ドラッグ＆ドロップで並べ替えを可能にするTransferHandlerを作成します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTLg-5HyXI/AAAAAAAAAXs/Wda5rMSf-1c/s800/DnDReorderTable.png
comments: true
---
## 概要
`JTable`の行を複数選択し、ドラッグ＆ドロップで並べ替えを可能にする`TransferHandler`を作成します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTLg-5HyXI/AAAAAAAAAXs/Wda5rMSf-1c/s800/DnDReorderTable.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model);
table.getSelectionModel().setSelectionMode(
    ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
table.setTransferHandler(new TableRowTransferHandler());
table.setDropMode(DropMode.INSERT_ROWS);
table.setDragEnabled(true);
</code></pre>

## 解説
上記のサンプルの`TransferHandler`(`JDK 6`で導入された`TransferHandler#canImport`メソッドなどを使用)は、[TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)のものとほぼ同じです。

[JTableの行をドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDTable.html)とは異なり、複数行を選択して`Drag & Drop`による移動が可能です。

## 参考リンク
- [Drag and Drop and Data Transfer: Examples (The Java™ Tutorials > Creating a GUI with JFC/Swing > Drag and Drop and Data Transfer)](https://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/index.html#BasicDnD)
    - [ListTransferHandler.java](https://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/DropDemoProject/src/dnd/ListTransferHandler.java)
- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)
- [JTableの行をドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDTable.html)
- [JTableの行を別のJTableにドラッグして移動](https://ateraimemo.com/Swing/DragRowsAnotherTable.html)

<!-- dummy comment line for breaking list -->

## コメント
- このサンプルでは、ソートされた状態での並べ替えは想定していない。 -- *aterai* 2014-02-20 (木) 19:50:30

<!-- dummy comment line for breaking list -->
