---
layout: post
title: JTableの次行にTabキーでフォーカスを移動
category: swing
folder: SelectNextRow
tags: [JTable, InputMap]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-04-18

## 概要
<kbd>Tab</kbd>キーでセルのフォーカスが次行に移動するように設定します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTS5aM0UvI/AAAAAAAAAjg/g-wlrmrzml8/s800/SelectNextRow.png %}

## サンプルコード
<pre class="prettyprint"><code>InputMap im = table.getInputMap(JTable.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
KeyStroke tab   = KeyStroke.getKeyStroke(KeyEvent.VK_TAB, 0);
KeyStroke enter = KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0);
im.put(tab, im.get(enter));
</code></pre>

## 解説
上記のサンプルでは、チェックボックスで<kbd>Tab</kbd>キーでのフォーカスの移動(セル毎に移動)が、<kbd>Enter</kbd>キーと同じ(行毎に移動)になるように切り替えています。

逆遷移の<kbd>Shift+Tab</kbd>なども対応する場合は、修飾子を`0`の代わりに`InputEvent.SHIFT_MASK`にして、同様に変更しています。

[Swing (Archive) - JTable skiping the cells disableds](https://forums.oracle.com/thread/1484284)に、編集できないセルを飛ばして、<kbd>Tab</kbd>キーでフォーカス移動することができるサンプルがあるので参考にしてください。

## 参考リンク
- [Swing (Archive) - JTable skiping the cells disableds](https://forums.oracle.com/thread/1484284)

<!-- dummy comment line for breaking list -->

## コメント
