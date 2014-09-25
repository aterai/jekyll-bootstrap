---
layout: post
title: JTreeで葉ノードが存在しない親ノードの描画を変更する
category: swing
folder: AsksAllowsChildren
tags: [JTree, DefaultTreeModel, DefaultMutableTreeNode]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-09-22

## 概要
`JTree`の親ノードに子として葉ノードがひとつも存在しない場合でも、フォルダアイコン表示になるよう設定します。

{% download https://lh6.googleusercontent.com/-vfEqezCRy2w/VB7mN-AcppI/AAAAAAAACNg/VkZLdGkiDRQ/s800/AsksAllowsChildren.png %}

## サンプルコード
<pre class="prettyprint"><code>DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
model.setAsksAllowsChildren(true);
</code></pre>

## 解説
- 左: `DefaultTreeModel#setAsksAllowsChildren(false)`
    - デフォルト
    - `DefaultMutableTreeNode`が親ノード(`DefaultMutableTreeNode#getAllowsChildren()==ture`)であっても、子として葉ノードがひとつも存在しない場合、そのアイコンは、葉ノードアイコンになる
- 右: `DefaultTreeModel#setAsksAllowsChildren(true)` (チェックボックスで選択した場合)
    - `DefaultMutableTreeNode`が親ノード(`DefaultMutableTreeNode#getAllowsChildren()==ture`)の場合、子として葉ノードが存在するかどうかにかかわらず、そのアイコンは、親ノードアイコンになる

<!-- dummy comment line for breaking list -->

## コメント
