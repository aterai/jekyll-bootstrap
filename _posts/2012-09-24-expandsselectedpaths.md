---
layout: post
title: JTreeの選択されたノードを展開する
category: swing
folder: ExpandsSelectedPaths
tags: [JTree]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-09-24


## JTreeの選択されたノードを展開する
`JTree`の選択されたノードまでのパスをすべて展開して可視状態にします。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-sOsnOftT8xE/UF_b7dSxzQI/AAAAAAAABS0/i_xYkTfxbZg/s800/ExpandsSelectedPaths.png)

### サンプルコード
<pre class="prettyprint"><code>tree.setExpandsSelectedPaths(true);
</code></pre>

### 解説
- `JTree#setExpandsSelectedPaths(false);`
    - ノード選択を変更しても親パスを展開しない
- `JTree#setExpandsSelectedPaths(true);`
    - デフォルト(`JDK 1.3`から)
    - マウスによる選択ではない、`JTree#addSelectionPath(TreePath)`などによるノード選択が行われた場合、選択されたノードまでのパスをすべて展開して可視化(スクロールはしない)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [http://docs.oracle.com/javase/1.3/docs/guide/swing/JTreeChanges.html](http://docs.oracle.com/javase/1.3/docs/guide/swing/JTreeChanges.html)
- [http://docs.oracle.com/javase/jp/1.3/guide/swing/JTreeChanges.html](http://docs.oracle.com/javase/jp/1.3/guide/swing/JTreeChanges.html)
    - メモ: 日本語版には`docs`が付かない
- [JTreeのノードを検索する](http://terai.xrea.jp/Swing/SearchBox.html)

<!-- dummy comment line for breaking list -->

### コメント
