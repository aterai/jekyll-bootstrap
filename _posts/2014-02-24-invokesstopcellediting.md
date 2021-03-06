---
layout: post
category: swing
folder: InvokesStopCellEditing
title: JTreeのノード編集をコミット
tags: [JTree]
author: aterai
pubdate: 2014-02-24T00:00:29+09:00
description: JTreeのノード編集中に割り込みが発生した場合、変更の自動保存を行うかどうかを設定します。
image: https://lh6.googleusercontent.com/-KbIRjsEYzEA/Uwny844Zc3I/AAAAAAAACAY/_3w4abiuaIo/s800/InvokesStopCellEditing.png
comments: true
---
## 概要
`JTree`のノード編集中に割り込みが発生した場合、変更の自動保存を行うかどうかを設定します。

{% download https://lh6.googleusercontent.com/-KbIRjsEYzEA/Uwny844Zc3I/AAAAAAAACAY/_3w4abiuaIo/s800/InvokesStopCellEditing.png %}

## サンプルコード
<pre class="prettyprint"><code>tree.setInvokesStopCellEditing(true);
</code></pre>

## 解説
`JTree`のノード編集に割り込みイベントが発生した場合の動作を変更します。

- `tree.setInvokesStopCellEditing(false);`
    - デフォルト
    - 編集に割り込みが発生した場合、`JTree#cancelCellEditing()`が呼び出されてデータ変更は破棄される
- `tree.setInvokesStopCellEditing(true);`
    - 編集に割り込みが発生した場合、`JTree#stopCellEditing()`が呼び出されてデータ変更が保存される

<!-- dummy comment line for breaking list -->

- - - -
ノード編集の割り込みイベントは、その`JTree`内の別のノードがクリックされた場合などに発生します。<kbd>Tab</kbd>キーなどで`JTree`以外のコンポーネントにフォーカスが移動したり、親`Window`がフォーカスを失っても、割り込みは発生しないため、編集中の状態が維持され、再度`JTree`にフォーカスを戻せば編集を再開できます。

## 参考リンク
- [JTree#setInvokesStopCellEditing(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#setInvokesStopCellEditing-boolean-)
- [JTableのセルの編集をコミット](https://ateraimemo.com/Swing/TerminateEdit.html)

<!-- dummy comment line for breaking list -->

## コメント
