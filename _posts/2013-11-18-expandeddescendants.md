---
layout: post
category: swing
folder: ExpandedDescendants
title: JTreeの展開状態を記憶・復元する
tags: [JTree, TreePath]
author: aterai
pubdate: 2013-11-18T00:04:12+09:00
description: JTreeのノードが展開されているかどうかを記憶、復元します。
image: https://lh4.googleusercontent.com/-FcYsZkFYSxE/UojBcoMtHwI/AAAAAAAAB6k/A7D221doy2w/s800/ExpandedDescendants.png
comments: true
---
## 概要
`JTree`のノードが展開されているかどうかを記憶、復元します。

{% download https://lh4.googleusercontent.com/-FcYsZkFYSxE/UojBcoMtHwI/AAAAAAAAB6k/A7D221doy2w/s800/ExpandedDescendants.png %}

## サンプルコード
<pre class="prettyprint"><code>visitAll(tree, rootPath, false); //Collapse all
if (expandedState == null) {
  return;
}
while (expandedState.hasMoreElements()) {
  tree.expandPath(expandedState.nextElement());
}
expandedState = tree.getExpandedDescendants(rootPath);
</code></pre>

## 解説
上記のサンプルでは、`JTree#getExpandedDescendants(TreePath)`メソッドを使用して展開されているノードの`TreePath`を`Enumeration`に保存しています。復元は一旦すべてのノードを折り畳んでから`JTree#expandPath(TreePath)`メソッドを使用して`Enumeration<TreePath>`から取得したノードを展開しています。

- 親ノードが閉じている場合、その子ノードの展開状態は記憶していない
    - このサンプルでの例を挙げると、`Set 004`を展開して親の`Set 001`を折り畳んだ状態で`JTree#getExpandedDescendants(TreePath)`を使用した場合、戻り値の`Enumeration<TreePath>`に`Set 004`へのパスは含まれない
- [JTree#getExpandedDescendants(TreePath)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#getExpandedDescendants-javax.swing.tree.TreePath-)メソッドのドキュメントの説明がよく分からない(特に前半)が、もしかしたら上記のことを言っているのかもしれない…

<!-- dummy comment line for breaking list -->

	If you expand/collapse nodes while iterating over the returned Enumeration this may not return all the expanded paths, or may return paths that are no longer expanded.
	返された Enumeration で繰り返している間ノードを展開するか、折りたたむと、このメソッドは展開されたすべてのパスを返すのではなく、それ以上展開されていないパスを返します。

- - - -
- `JTree`のシリアライズに関するのメモ
    
    <pre class="prettyprint"><code>// XMLEncoderではデフォルトのJTreeの場合、展開状態などは保存されない
    try (XMLEncoder xe = new XMLEncoder(new BufferedOutputStream(new FileOutputStream(xmlFile)))) {
      xe.writeObject(tree);
      // xe.close();
      // ...
    
      // ObjectOutputStreamの場合は、選択状態、展開状態なども保存、復元可能
      ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file));
      oos.writeObject(tree);
      // ...
</code></pre>
- * 参考リンク [#reference]
- [JTree#getExpandedDescendants(TreePath) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#getExpandedDescendants-javax.swing.tree.TreePath-)
- [JTreeのノードを展開・折り畳み](https://ateraimemo.com/Swing/ExpandAllNodes.html)
- [Swing: Retaining JTree Expansion State](http://www.javalobby.org/java/forums/t19857.html)
- [OR in an OB World: Auto-collapsing Tree in Java](http://orinanobworld.blogspot.jp/2013/03/auto-collapsing-tree-in-java.html)

<!-- dummy comment line for breaking list -->

## コメント
