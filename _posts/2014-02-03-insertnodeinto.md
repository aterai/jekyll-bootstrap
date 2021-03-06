---
layout: post
category: swing
folder: InsertNodeInto
title: JTreeへのノード追加をテスト
tags: [JTree, DefaultTreeModel, DefaultMutableTreeNode]
author: aterai
pubdate: 2014-02-03T12:43:56+09:00
description: JTreeにノード追加をした場合、兄弟ノードの展開状態などがどうなるかをテストします。
image: https://lh3.googleusercontent.com/-siBaGX1oXx8/Uu8JPWZaA7I/AAAAAAAAB_Y/fzV1VSKYg9I/s800/InsertNodeInto.png
comments: true
---
## 概要
`JTree`にノード追加をした場合、兄弟ノードの展開状態などがどうなるかをテストします。

{% download https://lh3.googleusercontent.com/-siBaGX1oXx8/Uu8JPWZaA7I/AAAAAAAAB_Y/fzV1VSKYg9I/s800/InsertNodeInto.png %}

## サンプルコード
<pre class="prettyprint"><code>DefaultTreeModel model1 = (DefaultTreeModel) tree1.getModel();
DefaultMutableTreeNode parent1 = (DefaultMutableTreeNode) model1.getRoot();
DefaultMutableTreeNode child1  = new DefaultMutableTreeNode(date);
parent1.add(child1);
model1.reload(parent1);
tree1.scrollPathToVisible(new TreePath(child1.getPath()));

DefaultTreeModel model2 = (DefaultTreeModel) tree2.getModel();
DefaultMutableTreeNode parent2 = (DefaultMutableTreeNode) model2.getRoot();
DefaultMutableTreeNode child2  = new DefaultMutableTreeNode(date);
model2.insertNodeInto(child2, parent2, parent2.getChildCount());
tree2.scrollPathToVisible(new TreePath(child2.getPath()));
</code></pre>

## 解説
上記のサンプルでは、`add`ボタンのクリックで左右の`JTree`のルートノードの子ノード末尾に新規ノードを追加し、それぞれの描画などをテストできます。

- 左: `p.add(c) & m.reload(p)`
    - `DefaultMutableTreeNode#add(...)`メソッドを使用して、親ノードの末尾に子ノードを追加
        - 追加する子ノードが親ノードを持つ場合、その親子関係は削除される(子ノードが持つ親ノードはひとつのみ)
    - `DefaultTreeModel#reload(...)`、または`DefaultTreeModel#nodeStructureChanged(DefaultMutableTreeNode)`でモデルに更新を通知
        - 兄弟ノードの展開状態などがすべて閉じた状態にリセットされてしまう
- 右: `m.insertNodeInto(c, p, p.size)`
    - `DefaultTreeModel#insertNodeInto(...)`メソッドを使用して、子ノードを親ノードの指定した位置に挿入
        - 内部で、`nodesWereInserted(...)`メソッドが呼び出され、適切なイベントが生成されるので、他のノードの展開状態などは維持される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのノード追加、削除](https://ateraimemo.com/Swing/AddNode.html)
    - ポップアップメニューで任意の位置にノードを追加
- [JScrollPane内にあるJTableなどで追加した行が可視化されるようにスクロールする](https://ateraimemo.com/Swing/ScrollRectToVisible.html)
    - 追加したノードが表示されるようにスクロール

<!-- dummy comment line for breaking list -->

## コメント
