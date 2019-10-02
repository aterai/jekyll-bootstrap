---
layout: post
category: swing
folder: DropLineColor
title: TransferHandlerを使用したドラッグ＆ドロップで挿入先を表示するドロップラインの色を変更する
tags: [TransferHandler, JList, JTable, JTree, DragAndDrop, UIManager]
author: aterai
pubdate: 2019-09-30T08:12:21+09:00
description: JList、JTable、JTreeのTransferHandlerを使用したドラッグ＆ドロップで挿入先を表示するドロップラインの色を変更します。
image: https://drive.google.com/uc?id=1zV5JFERJgM_2M66Sa8dWyRViXHZfQdkL
comments: true
---
## 概要
`JList`、`JTable`、`JTree`の`TransferHandler`を使用したドラッグ＆ドロップで挿入先を表示するドロップラインの色を変更します。

{% download https://drive.google.com/uc?id=1zV5JFERJgM_2M66Sa8dWyRViXHZfQdkL %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("List.dropLineColor", Color.RED);
UIManager.put("Table.dropLineColor", Color.GREEN);
UIManager.put("Table.dropLineShortColor", Color.GREEN);
UIManager.put("Tree.dropLineColor", Color.BLUE);

// Default drop line color:
// UIManager.put(List.dropLineColor, null);

// Hide drop lines: 
// UIManager.put(List.dropLineColor, new Color(0x0, true));
</code></pre>

## 解説
- `JList`は`List.dropLineColor`でドロップラインの色を変更可能
- `JTable`は`Table.dropLineColor`でドロップラインの色を変更可能
    - `Table.dropLineShortColor`でマウスカーソル先のセルに引かれる短いドロップラインの色を変更可能
    - `UIManager.put("Table.dropLineShortColor", new Color(0x0, true))`で`Table.dropLineShortColor`のみ非表示にすると、ドロップライン全体が`Table.dropLineColor`で設定した色で描画される
- `JTree`は`Tree.dropLineColor`でドロップラインの色を変更可能

<!-- dummy comment line for breaking list -->

- - - -
- `UIManager.put("List.dropLineColor", null)`でドロップラインの色に`null`を設定すると、デフォルト色でドロップラインが描画される
- ドロップラインを非表示にする場合は、`UIManager.put("List.dropLineColor", new Color(0x0, true))`のように完全透明色を設定する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [swing - Java: How to change JTable drag & drop dropLine color? - Stack Overflow](https://stackoverflow.com/questions/58032762/java-how-to-change-jtable-drag-drop-dropline-color)
- [JTreeのノードをドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDTree.html)
    - こちらのドラッグ＆ドロップは`TransferHandler`を使用していないため、`Tree.dropLineColor`も無視して独自にドロップラインを描画している

<!-- dummy comment line for breaking list -->

## コメント
