---
layout: post
title: JTreeのノードを走査する
category: swing
folder: TraverseAllNodes
tags: [JTree, Enumeration, TreeModel, DefaultMutableTreeNode]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-01-16

## JTreeのノードを走査する
`JTree`のノードから`Enumeration`を取得してサブツリーの走査を行います。

{% download %}

![screenshot](https://lh5.googleusercontent.com/-m8cdaUCibl0/TxPCZQMYqkI/AAAAAAAABH4/eAK9LyYkv14/s800/TraverseAllNodes.png)

### サンプルコード
<pre class="prettyprint"><code>TreeModel model = tree.getModel();
DefaultMutableTreeNode root = (DefaultMutableTreeNode)model.getRoot();
Enumeration e = root.breadthFirstEnumeration();
while(e.hasMoreElements()) {
  DefaultMutableTreeNode node = (DefaultMutableTreeNode)e.nextElement();
  textArea.append(node.toString()+"\n");
}
</code></pre>

### 解説
上記のサンプルでは、この`JTree`の最上位ノードをルートにするサブツリーを、深さ優先、幅優先などで全走査しています。

- [DefaultMutableTreeNode#depthFirstEnumeration()](http://docs.oracle.com/javase/jp/6/api/javax/swing/tree/DefaultMutableTreeNode.html#depthFirstEnumeration%28%29)
    - [DefaultMutableTreeNode#postorderEnumeration()](http://docs.oracle.com/javase/jp/6/api/javax/swing/tree/DefaultMutableTreeNode.html#postorderEnumeration%28%29)と同じ
    - 深さ優先走査(後順走査)
    - `blue, violet, red, yellow, colors, basketball, ... , JTree`

<!-- dummy comment line for breaking list -->

- [DefaultMutableTreeNode#breadthFirstEnumeration()](http://docs.oracle.com/javase/jp/6/api/javax/swing/tree/DefaultMutableTreeNode.html#breadthFirstEnumeration%28%29)
    - 幅優先走査
    - `JTree, colors, sports, food, blue, violet, red, ...`

<!-- dummy comment line for breaking list -->

- [DefaultMutableTreeNode#preorderEnumeration()](http://docs.oracle.com/javase/jp/6/api/javax/swing/tree/DefaultMutableTreeNode.html#preorderEnumeration%28%29)
    - 前順走査
    - `JTree, colors, blue, violet, red, yellow, sports, basketball, soccer, ...`

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTreeのノードを検索する](http://terai.xrea.jp/Swing/SearchBox.html)

<!-- dummy comment line for breaking list -->

### コメント
