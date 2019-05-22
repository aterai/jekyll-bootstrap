---
layout: post
category: swing
folder: SortsOnUpdates
title: JTableのモデルが更新された時にソートを行う
tags: [JTable, DefaultRowSorter]
author: aterai
pubdate: 2015-01-19T00:22:44+09:00
description: JTableのモデルが更新された時にソートを行うように設定し、値の変更、行の追加などでの状態変化をテストします。
image: https://lh3.googleusercontent.com/-sydiHRbXRzw/VLvNhDDXdlI/AAAAAAAANvI/Qelj8B1NIWs/s800/SortsOnUpdates.png
comments: true
---
## 概要
`JTable`のモデルが更新された時にソートを行うように設定し、値の変更、行の追加などでの状態変化をテストします。

{% download https://lh3.googleusercontent.com/-sydiHRbXRzw/VLvNhDDXdlI/AAAAAAAANvI/Qelj8B1NIWs/s800/SortsOnUpdates.png %}

## サンプルコード
<pre class="prettyprint"><code>RowSorter&lt;? extends TableModel&gt; rs = table.getRowSorter();
if (rs instanceof DefaultRowSorter) {
  ((DefaultRowSorter&lt;?, ?&gt;) rs).setSortsOnUpdates(true);
}
</code></pre>

## 解説
- セルエディタで値を編集、変更
    - `SortsOnUpdates(false)`の場合、ソート状態に変化なし(デフォルト)
    - `SortsOnUpdates(true)`の場合、`CellEditor`が値をコミットした(`DefaultRowSorter#rowsUpdated(...)`メソッドが呼び出された)後にソートが実行される
- モデルに行を追加、削除
    - `SortsOnUpdates`の値には依存せず、常にソートが実行される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultRowSorter#setSortsOnUpdates(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/DefaultRowSorter.html#setSortsOnUpdates-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
