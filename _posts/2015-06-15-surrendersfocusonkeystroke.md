---
layout: post
category: swing
folder: SurrendersFocusOnKeystroke
title: JTableのセルを編集開始したときにセルエディタがフォーカスを取得するよう設定する
tags: [JTable, CellEditor, Focus]
author: aterai
pubdate: 2015-06-15T00:00:18+09:00
description: JTableのセルを編集開始したときに、セルエディタがフォーカスを取得するかどうかを設定で切り替えます。
image: https://lh3.googleusercontent.com/-Kzqx4xhc2CM/VX2WWWF2AYI/AAAAAAAAN6o/MQEBYdlaDP4/s800/SurrendersFocusOnKeystroke.png
comments: true
---
## 概要
`JTable`のセルを編集開始したときに、セルエディタがフォーカスを取得するかどうかを設定で切り替えます。

{% download https://lh3.googleusercontent.com/-Kzqx4xhc2CM/VX2WWWF2AYI/AAAAAAAAN6o/MQEBYdlaDP4/s800/SurrendersFocusOnKeystroke.png %}

## サンプルコード
<pre class="prettyprint"><code>table.setSurrendersFocusOnKeystroke(true);
</code></pre>

## 解説
- `table.setSurrendersFocusOnKeystroke(false);`
    - `JTable`のデフォルト
    - キー入力でセル編集を開始した場合、フォーカスは`JTable`に残る
        - このため、キー入力でセル編集を開始した直後に<kbd>Ctrl+A</kbd>を入力すると`JTable`の行が全選択される
    - マウスクリックでセル編集を開始した場合は、この`JTable#setSurrendersFocusOnKeystroke(...)`の指定に依存せず、フォーカスはセルエディタに移動する
- `table.setSurrendersFocusOnKeystroke(true);`
    - キー入力でセル編集を開始した場合、フォーカスはセルエディタ(`JTextField`)に移動する
        - このため、キー入力でセル編集を開始した直後に<kbd>Ctrl+A</kbd>を入力するとセルエディタ内の文字列が全選択される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTable#setSurrendersFocusOnKeystroke(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#setSurrendersFocusOnKeystroke-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
