---
layout: post
title: JTreeのToolTipsを表示
category: swing
folder: TreeToolTips
tags: [JTree, JToolTip, ToolTipManager, TreeCellRenderer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-06-04

## JTreeのToolTipsを表示
`JTree`のノードの`ToolTips`を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWQe1RL2I/AAAAAAAAAo8/6HFqbUb3UZ8/s800/TreeToolTips.png)

### サンプルコード
<pre class="prettyprint"><code>//tree = new JTree();
tree = new JTree() {
  @Override public String getToolTipText(MouseEvent e) {
    Object o = null;
    TreePath path = getPathForLocation(e.getX(), e.getY());
    if(path!=null) {
      o = path.getLastPathComponent();
    }
    return (o==null)?null:o.toString();
  }
};
//tree.setCellRenderer(new MyTreeCellRenderer(tree.getCellRenderer()));
ToolTipManager.sharedInstance().registerComponent(tree);
</code></pre>

### 解説
上記のサンプルでは、`JTree#getToolTipText(MouseEvent)`をオーバーライドして`JToolTip`を表示しています。以下のようなセルレンダラーを使用する方法もあります。

<pre class="prettyprint"><code>class MyTreeCellRenderer implements TreeCellRenderer {
  private final TreeCellRenderer renderer;
  public MyTreeCellRenderer(TreeCellRenderer renderer) {
    this.renderer = renderer;
  }
  @Override public Component getTreeCellRendererComponent(
        JTree tree, Object value, boolean isSelected,
        boolean expanded, boolean leaf, int row, boolean hasFocus) {
    JComponent c = (JComponent)renderer.getTreeCellRendererComponent(
      tree, value, isSelected, expanded, leaf, row, hasFocus);
    c.setToolTipText((value==null)?null:value.toString());
    return c;
  }
}
</code></pre>

どちらの方法を使う場合でも、`JTree`オフジェクトを`ToolTipManager`に登録する(もしくは、`JTree#setToolTipText`メソッドで`null`以外を指定しておく)必要があります。

<pre class="prettyprint"><code>ToolTipManager.sharedInstance().registerComponent(tree);
//tree.setToolTipText("dummy");
</code></pre>

### コメント
