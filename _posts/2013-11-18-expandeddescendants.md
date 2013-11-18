---
layout: post
title: JTreeの展開状態を記憶・復元する
category: swing
folder: ExpandedDescendants
tags: [JTree, TreePath]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-11-18

## JTreeの展開状態を記憶・復元する
`JTree`でノードの展開状態を記憶、復元します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-FcYsZkFYSxE/UojBcoMtHwI/AAAAAAAAB6k/A7D221doy2w/s800/ExpandedDescendants.png)

### サンプルコード
<pre class="prettyprint"><code>visitAll(tree, rootPath, false); //Collapse all
if(expandedState == null) { return; }
while(expandedState.hasMoreElements()) {
  tree.expandPath(expandedState.nextElement());
}
expandedState = tree.getExpandedDescendants(rootPath);
</code></pre>

### 解説
上記のサンプルでは、`JTree#getExpandedDescendants(TreePath)`メソッドで展開されているノードの`TreePath`を`Enumeration`で保存しています。復元は一旦すべてのノードを折り畳んでから、`JTree#expandPath(TreePath)`で`Enumeration<TreePath>`から取得したノードを展開しています。

- 注:
    - 親ノードが閉じている場合、その子ノードの展開状態は記憶していない
    - [JTree (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/javax/swing/JTree.html#getExpandedDescendants%28javax.swing.tree.TreePath%29)

<!-- dummy comment line for breaking list -->

- - - -
- `JTree`のシリアライズに関するのメモ

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//XMLEncoderではデフオルトのJTreeの場合、展開状態などは保存されない
//??? 1.7.0_45では、整形式のXMLにならない場合がある ???
XMLEncoder xe = new XMLEncoder(new BufferedOutputStream(new FileOutputStream(xmlFile)));
xe.writeObject(tree);
xe.flush();

//ObjectOutputStreamの場合は、選択状態、展開状態なども保存、復元可能
ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file));
oos.writeObject(tree);
oos.flush();
</code></pre>

### 参考リンク
- [JTreeのノードを展開・折り畳み](http://terai.xrea.jp/Swing/ExpandAllNodes.html)
- [Swing: Retaining JTree Expansion State](http://www.javalobby.org/java/forums/t19857.html)

<!-- dummy comment line for breaking list -->

### コメント
