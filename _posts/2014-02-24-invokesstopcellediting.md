---
layout: post
title: JTreeのノード編集をコミット
category: swing
folder: InvokesStopCellEditing
tags: [JTree]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-02-24

## JTreeのノード編集をコミット
`JTree`のノード編集中に割り込みが発生した場合、変更の自動保存を行うかどうかを設定します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-KbIRjsEYzEA/Uwny844Zc3I/AAAAAAAACAY/_3w4abiuaIo/s800/InvokesStopCellEditing.png)

### サンプルコード
<pre class="prettyprint"><code>tree.setInvokesStopCellEditing(true);
</code></pre>

### 解説
`JTree`のノード編集に割り込みが発生した場合の動作を変更します。

- `tree.setInvokesStopCellEditing(false);` デフォルト
    - 編集に割り込みが発生したとき、`JTree#cancelCellEditing()`が呼び出され、変更は破棄される
- `tree.setInvokesStopCellEditing(true);`
    - 編集に割り込みが発生したとき、`JTree#stopCellEditing()`が呼び出され、データが保存される

<!-- dummy comment line for breaking list -->

- - - -
ノード編集の割り込みは、その`JTree`内の別のノードがクリックされた場合などに発生します。<kbd>Tab</kbd>キーなどで`JTree`以外のコンポーネントにフォーカスが移動したり、親`Window`がフォーカスを失っても、割り込みは発生しないため、編集中の状態が維持され、再度`JTree`にフォーカスを戻せば編集を再開することができます。

### 参考リンク
- [JTree#setInvokesStopCellEditing(boolean) (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/javax/swing/JTree.html#setInvokesStopCellEditing%28boolean%29)
- [JTableのセルの編集をコミット](http://terai.xrea.jp/Swing/TerminateEdit.html)

<!-- dummy comment line for breaking list -->

### コメント
