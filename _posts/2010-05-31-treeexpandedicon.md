---
layout: post
title: JTreeの展開、折畳みアイコンを非表示にする
category: swing
folder: TreeExpandedIcon
tags: [JTree, Icon, UIManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-05-31

## JTreeの展開、折畳みアイコンを非表示にする
`JTree`の展開、折畳みアイコンを変更して非表示にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTWHHSFZMI/AAAAAAAAAos/aymKObZa7WQ/s800/TreeExpandedIcon.png)

### サンプルコード
<pre class="prettyprint"><code>Icon emptyIcon = new EmptyIcon();
UIManager.put("Tree.expandedIcon",  new IconUIResource(emptyIcon));
UIManager.put("Tree.collapsedIcon", new IconUIResource(emptyIcon));
</code></pre>

### 解説
上記のサンプルでは、サイズ`0`の`Icon`を`Tree.expandedIcon`, `Tree.collapsedIcon`として使用することで、それぞれ非表示になるように設定しています。

### 参考リンク
- [JTableのソートアイコンを変更](http://terai.xrea.jp/Swing/TableSortIcon.html)
- [JTreeのOpenIcon、ClosedIcon、LeafIconを変更](http://terai.xrea.jp/Swing/TreeLeafIcon.html)

<!-- dummy comment line for breaking list -->

### コメント