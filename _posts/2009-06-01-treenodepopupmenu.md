---
layout: post
title: JTreeのノード上でJPopupMenuを表示
category: swing
folder: TreeNodePopupMenu
tags: [JTree, JPopupMenu, TreePath]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-06-01

## JTreeのノード上でJPopupMenuを表示
`JTree`のノード上でクリックした場合のみ、`JPopupMenu`を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWLWQUjBI/AAAAAAAAAo0/3F3RUbU5sx8/s800/TreeNodePopupMenu.png)

### サンプルコード
<pre class="prettyprint"><code>static class TreePopupMenu extends JPopupMenu {
  private TreePath[] tsp;
  public TreePopupMenu() {
    super();
    add(new AbstractAction("path") {
      @Override public void actionPerformed(ActionEvent e) {
        JOptionPane.showMessageDialog(null, tsp, "path",
          JOptionPane.INFORMATION_MESSAGE);
      }
    });
    add(new JMenuItem("dummy"));
  }
  @Override public void show(Component c, int x, int y) {
    JTree tree = (JTree)c;
    tsp = tree.getSelectionPaths();
    if(tsp!=null) {
      TreePath path = tree.getPathForLocation(x, y);
      if(path!=null &amp;&amp; Arrays.asList(tsp).contains(path)) {
        super.show(c, x, y);
      }
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは以下の場合、`JPopupMenu`を表示しています。

- `JTree`のノードが選択されている
- 選択されたノード上にカーソルがある

<!-- dummy comment line for breaking list -->

### コメント
