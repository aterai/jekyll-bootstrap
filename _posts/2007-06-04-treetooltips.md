---
layout: post
category: swing
folder: TreeToolTips
title: JTreeのToolTipsを表示
tags: [JTree, JToolTip, ToolTipManager, TreeCellRenderer]
author: aterai
pubdate: 2007-06-04T19:46:36+09:00
description: ノード毎に内容の異なるJToolTipを表示するJTreeを作成します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWQe1RL2I/AAAAAAAAAo8/6HFqbUb3UZ8/s800/TreeToolTips.png
comments: true
---
## 概要
ノード毎に内容の異なる`JToolTip`を表示する`JTree`を作成します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWQe1RL2I/AAAAAAAAAo8/6HFqbUb3UZ8/s800/TreeToolTips.png %}

## サンプルコード
<pre class="prettyprint"><code>tree = new JTree() {
  @Override public String getToolTipText(MouseEvent e) {
    Object o = null;
    TreePath path = getPathForLocation(e.getX(), e.getY());
    if (Objects.nonNull(path)) {
      o = path.getLastPathComponent();
    }
    return Objects.toString(o, "getToolTipText");
  }
};
// tree.setCellRenderer(new MyTreeCellRenderer(tree.getCellRenderer()));
ToolTipManager.sharedInstance().registerComponent(tree);
</code></pre>

## 解説
上記のサンプルでは、`JTree#getToolTipText(MouseEvent)`メソッドをオーバーライドして`JToolTip`で表示する文字列を変更しています。

ツールチップ表示を有効にするには、`JTree`オブジェクトを`ToolTipManager`に登録するか、`JTree#setToolTipText(...)`メソッドで`null`以外を指定しておく必要があります。

<pre class="prettyprint"><code>ToolTipManager.sharedInstance().registerComponent(tree);
// tree.setToolTipText("dummy");
</code></pre>

- - - -
- セルレンダラーを使用する別方法
    
    <pre class="prettyprint"><code>class MyTreeCellRenderer implements TreeCellRenderer {
      private final TreeCellRenderer renderer;
      public MyTreeCellRenderer(TreeCellRenderer renderer) {
        this.renderer = renderer;
      }
      @Override public Component getTreeCellRendererComponent(
            JTree tree, Object value, boolean isSelected,
            boolean expanded, boolean leaf, int row, boolean hasFocus) {
        JComponent c = (JComponent) renderer.getTreeCellRendererComponent(
          tree, value, isSelected, expanded, leaf, row, hasFocus);
        c.setToolTipText(Objects.nonNull(value) ? value.toString() : null);
        return c;
      }
    }
</code></pre>
- * 参考リンク [#reference]
- [JTree#getToolTipText() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#getToolTipText-java.awt.event.MouseEvent-)

<!-- dummy comment line for breaking list -->
## コメント
