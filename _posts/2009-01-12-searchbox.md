---
layout: post
title: JTreeのノードを検索する
category: swing
folder: SearchBox
tags: [JTree, TreeModel, TreePath, TreeNode]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-01-12

## JTreeのノードを検索する
`JTree`を検索して、一致するアイテムを選択します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.ggpht.com/_9Z4BYR88imo/TQTSs3gdysI/AAAAAAAAAjM/r_j-mrb83aU/s800/SearchBox.png)

### サンプルコード
<pre class="prettyprint"><code>private static void searchTree(JTree tree, TreePath path, String q) {
  TreeNode node = (TreeNode)path.getLastPathComponent();
  if(node==null) return;
  if(node.toString().equals(q))
    tree.addSelectionPath(path);
  if(!node.isLeaf() &amp;&amp; node.getChildCount()&gt;=0) {
    Enumeration e = node.children();
    while(e.hasMoreElements())
      searchTree(tree, path.pathByAddingChild(e.nextElement()), q);
  }
}
</code></pre>

### 解説
上記のサンプルでは、選択された`JTree`のノード以下に、検索文字列と一致するノードがあれば、`JTree#addSelectionPath(TreePath)`メソッドで選択するようになっています。

- - - -
[Swing - how to get everything in DefaultTreeNode](https://forums.oracle.com/thread/1357454)のAndre_Uhresさんの投稿のように、`TreeModel`を使って検索する方法もあります。

<pre class="prettyprint"><code>//&lt;blockquote cite="https://forums.oracle.com/thread/1357454"&gt;
public void traverse(JTree tree) {
  TreeModel model = tree.getModel();
  Object root;
  if(model != null) {
    root = model.getRoot();
    walk(model,root);
  }else{
    System.out.println("Tree is empty.");
  }
}
protected void walk(TreeModel model, Object o) {
  int cc = model.getChildCount(o);
  for(int i=0; i &lt; cc; i++) {
    DefaultMutableTreeNode child = (DefaultMutableTreeNode) model.getChild(o, i);
    if(model.isLeaf(child)) {
      System.out.println(child);
    }else{
      System.out.println(child);
      walk(model, child);
    }
  }
}
//&lt;/blockquote&gt;
</code></pre>

- - - -
以下は、`DefaultMutableTreeNode#depthFirstEnumeration()`を使用して、`bananas`を検索しています。

- [JTreeのノードを走査する](http://terai.xrea.jp/Swing/TraverseAllNodes.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>TreeModel model = tree.getModel();
DefaultMutableTreeNode root = (DefaultMutableTreeNode)model.getRoot();
Enumeration depth = root.depthFirstEnumeration();
while(depth.hasMoreElements()) {
  DefaultMutableTreeNode node = (DefaultMutableTreeNode)depth.nextElement();
  if(node!=null &amp;&amp; "bananas".equals(node.toString())) {
    TreePath path = new TreePath(node.getPath());
    tree.setSelectionPath(path);
    tree.scrollPathToVisible(path);
    return;
  }
}
</code></pre>

### 参考リンク
- [JTreeのノードを展開・折り畳み](http://terai.xrea.jp/Swing/ExpandAllNodes.html)
- [Swing - how to get everything in DefaultTreeNode](https://forums.oracle.com/thread/1357454)
- [JTreeで条件に一致するノードを検索しハイライト](http://terai.xrea.jp/Swing/TreeNodeHighlightSearch.html)
- [JTreeのノードを走査する](http://terai.xrea.jp/Swing/TraverseAllNodes.html)

<!-- dummy comment line for breaking list -->

### コメント
- ソースを拝見させていただきましたが, 要素の挿入の箇所がさっぱりわかりません... -- [taji](http://terai.xrea.jp/taji.html) 2010-01-20 (水) 00:38:18
- 途中で切れてしまい失礼しました. できればどこで挿入しているのか教えていただけませんか? -- [taji](http://terai.xrea.jp/taji.html) 2010-01-20 (水) 00:39:44
    - `JTree`のデフォルトコンストラクタがサンプルモデルを持つ`JTree`を返しているので、`%JAVA_HOME%\src.zip`を展開して、`JTree()`を見るのがよいと思います。そこからたどって行けば`protected static TreeModel getDefaultTreeModel()`の中で、`TreeModel`を作って要素(ノード)を挿入している様子が分かります。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-20 (水) 11:15:33
- `JTree#getNextMatch(...)`は、展開されているノードのみ検索する？ -- [aterai](http://terai.xrea.jp/aterai.html) 2010-11-18 (木) 01:40:07
- 一致するノードが複数ある場合、ボタンクリックで選択状態がループするように変更しました(いつ修正したのかは不明...)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-09-15 (木) 21:32:23

<!-- dummy comment line for breaking list -->
