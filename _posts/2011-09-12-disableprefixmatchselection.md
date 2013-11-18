---
layout: post
title: JListの先頭文字キー入力による検索選択を無効にする
category: swing
folder: DisablePrefixMatchSelection
tags: [JList, JTree]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-09-12

## JListの先頭文字キー入力による検索選択を無効にする
`JList`にフォーカスがある状態で英数字キー入力をしたときに先頭文字が一致するアイテムを検索して選択する機能を無効にします。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-_wtzuIN_MvU/Tm2wga2X4hI/AAAAAAAABBs/dUuDS1gj9mM/s800/DisablePrefixMatchSelection.png)

### サンプルコード
<pre class="prettyprint"><code>JList list = new JList() {
  @Override public int getNextMatch(String prefix, int startIndex, Position.Bias bias) {
    return -1;
  }
};
</code></pre>

### 解説
上記のサンプルでは、`JList#getNextMatch(...)`メソッドをオーバーライドして、常に`-1`を返すようにすることで、キー入力による先頭文字検索選択を無効にしています。

- - - -
`JTree`にも同様に機能がありますが、`JTree#getNextMatch(...)`メソッドをオーバーライドして、戻り値の`TreePath`を`null`にすることで、無効にすることができます。

<pre class="prettyprint"><code>@Override public TreePath getNextMatch(
    String prefix, int startingRow, Position.Bias bias) {
  return null;
}
</code></pre>

### コメント
