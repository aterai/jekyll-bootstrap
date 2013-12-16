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

{% download %}

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
        - このサンプルでの例を挙げると、`Set 004`を展開して、親の`Set 001`を折り畳んだ状態で、`JTree#getExpandedDescendants(TreePaht)`を使用した場合、戻り値の`Enumeration<TreePath>`に`Set 004`へのパスは含まれない
    - [JTree#getExpandedDescendants(TreePath) (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/javax/swing/JTree.html#getExpandedDescendants%28javax.swing.tree.TreePath%29)に書かれている説明がよく分からない(特に前半)が、もしかしたら上記のことを言っているのかもしれない…。

<!-- dummy comment line for breaking list -->

	If you expand/collapse nodes while iterating over the returned Enumeration this may not return all the expanded paths, or may return paths that are no longer expanded.
	返された Enumeration で繰り返している間ノードを展開するか、折りたたむと、このメソッドは展開されたすべてのパスを返すのではなく、それ以上展開されていないパスを返します。

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
- [OR in an OB World: Auto-collapsing Tree in Java](http://orinanobworld.blogspot.jp/2013/03/auto-collapsing-tree-in-java.html)

<!-- dummy comment line for breaking list -->

### コメント