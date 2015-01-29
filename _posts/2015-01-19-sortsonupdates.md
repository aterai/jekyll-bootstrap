---
layout: post
category: swing
folder: SortsOnUpdates
title: JTableのモデルが更新された時にソートを行う
tags: [JTable, DefaultRowSorter]
author: aterai
pubdate: 2015-01-19T00:22:44+09:00
description: JTableのモデルが更新された時にソートを行うように設定し、値の変更、行の追加などでの状態変化をテストします。
comments: true
---
## 概要
`JTable`のモデルが更新された時にソートを行うように設定し、値の変更、行の追加などでの状態変化をテストします。

{% download https://lh3.googleusercontent.com/-sydiHRbXRzw/VLvNhDDXdlI/AAAAAAAANvI/Qelj8B1NIWs/s800/SortsOnUpdates.png %}

## サンプルコード
<pre class="prettyprint"><code>((DefaultRowSorter) table.getRowSorter()).setSortsOnUpdates(true);
</code></pre>

## 解説
- 値の編集、変更
    - `SortsOnUpdates(false)`の場合、ソートに変化なし
    - `SortsOnUpdates(true)`の場合、`CellEditor`が値をコミットした(`rowsUpdated`が呼び出された)後にソートが行われる
- 行の追加、削除
    - `SortsOnUpdates`の値に関わらず、ソートが行われる

<!-- dummy comment line for breaking list -->

## コメント
