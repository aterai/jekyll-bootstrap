---
layout: post
title: JTreeで展開不可のノードを設定する
category: swing
folder: PreventNodeExpanding
tags: [JTree, TreeWillExpandListener, File]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-01-27

## JTreeで展開不可のノードを設定する
JTreeで特定のノードだけ展開できないように設定します。


{% download https://lh4.googleusercontent.com/-WcBsEg_mxgc/UuUbyvn84EI/AAAAAAAAB-0/iZ6t8_EGeZQ/s800/PreventNodeExpanding.png %}

### サンプルコード
<pre class="prettyprint"><code>class DirectoryExpandVetoListener implements TreeWillExpandListener {
  @Override public void treeWillExpand(TreeExpansionEvent e)
        throws ExpandVetoException {
    TreePath path = e.getPath();
    Object o = path.getLastPathComponent();
    if(o instanceof DefaultMutableTreeNode) {
      DefaultMutableTreeNode node = (DefaultMutableTreeNode)o;
      File file = (File)node.getUserObject();
      String title = file.getName();
      System.out.println(title);
      if(title.startsWith(".")) {
        throw new ExpandVetoException(e, "Tree expansion cancelled");
      }
    }
  }
  @Override public void treeWillCollapse(TreeExpansionEvent e)
        throws ExpandVetoException {}
}
</code></pre>

### 解説
- `TreeWillExpandListener`を実装し、`treeWillExpand(...)`メソッド内で、ノード(`File`)の名前がドットで始まる場合、`ExpandVetoException`を投げて展開をキャンセル
    - これらのノードは展開は不可だが、選択自体は可能
- `DefaultTreeCellRenderer#getTreeCellRendererComponent(...)`内で、名前がドットで始まる場合、ノードを`setEnabled(false)`で無効状態にして描画

<!-- dummy comment line for breaking list -->

### 参考リンク
- [How to Write a Tree-Will-Expand Listener (The Java™ Tutorials > Creating a GUI With JFC/Swing > Writing Event Listeners)](http://docs.oracle.com/javase/tutorial/uiswing/events/treewillexpandlistener.html)

<!-- dummy comment line for breaking list -->

### コメント
