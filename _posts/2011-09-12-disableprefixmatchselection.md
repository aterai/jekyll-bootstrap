---
layout: post
category: swing
folder: DisablePrefixMatchSelection
title: JListの先頭文字キー入力による検索選択を無効にする
tags: [JList, JTree]
author: aterai
pubdate: 2011-09-12T16:36:34+09:00
description: JListにフォーカスがある状態で英数字キー入力をしたときに先頭文字が一致するアイテムを検索して選択する機能を無効にします。
image: https://lh6.googleusercontent.com/-_wtzuIN_MvU/Tm2wga2X4hI/AAAAAAAABBs/dUuDS1gj9mM/s800/DisablePrefixMatchSelection.png
comments: true
---
## 概要
`JList`にフォーカスがある状態で英数字キー入力をしたときに先頭文字が一致するアイテムを検索して選択する機能を無効にします。

{% download https://lh6.googleusercontent.com/-_wtzuIN_MvU/Tm2wga2X4hI/AAAAAAAABBs/dUuDS1gj9mM/s800/DisablePrefixMatchSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>JList list = new JList() {
  @Override public int getNextMatch(
        String prefix, int startIndex, Position.Bias bias) {
    return -1;
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JList#getNextMatch(...)`メソッドをオーバーライドし、戻り値(次にマッチする要素のインデックス)が常に`-1`になるようにすることで、キー入力による先頭文字検索選択を無効にしています。

- - - -
- `JTree`にも`JTree#getNextMatch(...)`メソッドが存在し、同様のキー入力による選択機能が存在するが、こちらはインデックスではなく`TreePath`が戻り値なので、`null`を返すことで無効化できる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JTree tree = new JTree() {
  @Override public TreePath getNextMatch(
        String prefix, int startingRow, Position.Bias bias) {
    return null;
  }
};
</code></pre>

## 参考リンク
- [JList#getNextMatch(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JList.html#getNextMatch-java.lang.String-int-javax.swing.text.Position.Bias-)
- [JTree#getNextMatch(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#getNextMatch-java.lang.String-int-javax.swing.text.Position.Bias-)

<!-- dummy comment line for breaking list -->

## コメント
