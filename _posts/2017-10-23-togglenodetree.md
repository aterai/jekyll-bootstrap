---
layout: post
category: swing
folder: ToggleNodeTree
title: JTreeのノードを展開すると他の兄弟ノードをすべて折り畳むよう設定する
tags: [JTree, TreeWillExpandListener, DefaultMutableTreeNode]
author: aterai
pubdate: 2017-10-23T14:25:33+09:00
description: JTreeの第一階層にあるノードを展開すると、他の兄弟ノードをすべて折り畳むよう設定し、展開できるノードを一つに限定します。
image: https://drive.google.com/uc?id=14fs0qBmqml8KoEbqhJM6bfNzKf9JbcQkxA
hreflang:
    href: https://java-swing-tips.blogspot.com/2017/11/when-jtrees-node-is-expanded-collapse.html
    lang: en
comments: true
---
## 概要
`JTree`の第一階層にあるノードを展開すると、他の兄弟ノードをすべて折り畳むよう設定し、展開できるノードを一つに限定します。

{% download https://drive.google.com/uc?id=14fs0qBmqml8KoEbqhJM6bfNzKf9JbcQkxA %}

## サンプルコード
<pre class="prettyprint"><code>JTree tree = new JTree(makeModel());
tree.setRootVisible(false);
tree.addTreeWillExpandListener(new TreeWillExpandListener() {
  private boolean isAdjusting;
  @Override public void treeWillExpand(TreeExpansionEvent e) throws ExpandVetoException {
    if (isAdjusting) {
      return;
    }
    isAdjusting = true;
    collapseFirstHierarchy(tree);
    tree.setSelectionPath(e.getPath());
    isAdjusting = false;
  }
  @Override public void treeWillCollapse(TreeExpansionEvent e) throws ExpandVetoException {
    // throw new ExpandVetoException(e, "Tree collapse cancelled");
  }
});
// ...
public static void collapseFirstHierarchy(JTree tree) {
  TreeModel model = tree.getModel();
  DefaultMutableTreeNode root = (DefaultMutableTreeNode) model.getRoot();
  Enumeration e = root.breadthFirstEnumeration();
  while (e.hasMoreElements()) {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode) e.nextElement();
    boolean isOverFirstLevel = node.getLevel() &gt; 1;
    if (isOverFirstLevel) { // Collapse only nodes in the first hierarchy
      return;
    } else if (node.isLeaf() || node.isRoot()) {
      continue;
    }
    tree.collapsePath(new TreePath(node.getPath()));
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTree`に`TreeWillExpandListener`を設定し、`TreeWillExpandListener#treeWillExpand(...)`をオーバーライドして、ノードを展開する前にすべての兄弟ノードを一旦折り畳み、これから展開するノードに選択状態を戻すことで、展開可能なノードを一つに限定しています。

- 第`1`階層のノードのみを対象にしているため、ルートノードや、第`2`階層以下のノードの展開、折り畳みには影響しない
    - ノードの階層には`DefaultMutableTreeNode#getLevel()`で取得した値を使用して、ルートノードを第`0`階層としている
    - 参考: [JTreeでノード階層の深さを取得する](https://ateraimemo.com/Swing/TreeNodeMaxLevel.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - How to automatically collapse JTree Node on selecting and expanding another node - Stack Overflow](https://stackoverflow.com/questions/46660028/how-to-automatically-collapse-jtree-node-on-selecting-and-expanding-another-node)

<!-- dummy comment line for breaking list -->

## コメント
