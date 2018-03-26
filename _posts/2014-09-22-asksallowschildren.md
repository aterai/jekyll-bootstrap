---
layout: post
category: swing
folder: AsksAllowsChildren
title: JTreeで葉ノードが存在しない親ノードの描画を変更する
tags: [JTree, DefaultTreeModel, DefaultMutableTreeNode, Icon]
author: aterai
pubdate: 2014-09-22T00:06:58+09:00
description: JTreeの親ノードに子として葉ノードがひとつも存在しない場合でも、フォルダアイコン表示になるよう設定します。
image: https://lh6.googleusercontent.com/-vfEqezCRy2w/VB7mN-AcppI/AAAAAAAACNg/VkZLdGkiDRQ/s800/AsksAllowsChildren.png
comments: true
---
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
    - `DefaultMutableTreeNode`が親ノード(`DefaultMutableTreeNode#getAllowsChildren() == true`)であっても、子として葉ノードがひとつも存在しない場合、そのアイコンは葉ノードアイコンになる
    - `JTree`に`TreeWillExpandListener`を追加し、この親ノード(葉ノードが存在しない)をマウスでクリックしても`treeWillExpand(...)`は発生しない
- 右: `DefaultTreeModel#setAsksAllowsChildren(true)` (チェックボックスで選択した場合)
    - `DefaultMutableTreeNode`が親ノード(`DefaultMutableTreeNode#getAllowsChildren() == true`)の場合、子として葉ノードが存在するかどうかにかかわらず、そのアイコンは親ノードアイコンになる
    - `JTree`に`TreeWillExpandListener`を追加し、この親ノード(葉ノードが存在しない)をクリックすると`treeWillExpand(...)`が発生する
        - このタイミングで後からこの親ノードに子ノードを追加するといった処理が可能になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultTreeModel#setAsksAllowsChildren(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeModel.html#setAsksAllowsChildren-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
