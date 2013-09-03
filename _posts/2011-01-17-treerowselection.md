---
layout: post
title: JTreeを行クリックで選択し、行全体を選択状態の背景色で描画
category: swing
folder: TreeRowSelection
tags: [JTree, TreeCellRenderer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-01-17

## JTreeを行クリックで選択し、行全体を選択状態の背景色で描画
`JTree`の行をクリックして選択し、行全体を選択状態の背景色で描画します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.ggpht.com/_9Z4BYR88imo/TTPdCvaUyfI/AAAAAAAAAyQ/QnF4vHjyUiM/s800/TreeRowSelection.png)

### サンプルコード
<pre class="prettyprint"><code>final Color SELC = new Color(100,150,200);
JTree tree = new JTree() {
  @Override public void paintComponent(Graphics g) {
    g.setColor(getBackground());
    g.fillRect(0,0,getWidth(),getHeight());
    if(getSelectionCount()&gt;0) {
      for(int i: getSelectionRows()) {
        Rectangle r = getRowBounds(i);
        g.setColor(SELC);
        g.fillRect(0, r.y, getWidth(), r.height);
      }
    }
    super.paintComponent(g);
    if(getLeadSelectionPath()!=null) {
      Rectangle r = getRowBounds(getRowForPath(getLeadSelectionPath()));
      g.setColor(SELC.darker());
      g.drawRect(0, r.y, getWidth()-1, r.height-1);
    }
  }
};
tree.setUI(new javax.swing.plaf.basic.BasicTreeUI() {
  @Override public Rectangle getPathBounds(JTree tree, TreePath path) {
    if(tree != null &amp;&amp; treeState != null) {
      return getPathBounds(path, tree.getInsets(), new Rectangle());
    }
    return null;
  }
  private Rectangle getPathBounds(TreePath path, Insets insets, Rectangle bounds) {
    bounds = treeState.getBounds(path, bounds);
    if(bounds != null) {
      bounds.width = tree.getWidth();
      bounds.y += insets.top;
    }
    return bounds;
  }
});
tree.setOpaque(false);
</code></pre>

### 解説
以下のような設定で、`JTree`を行選択できるように変更し、表示も`NimbusLookAndFeel`風に行全体を選択状態の背景色で描画するようにしています。

- `BasicTreeUI#getPathBounds(...)`をオーバーライドして、ノードではなく、行のクリックで選択可能に変更
- `JTree`の背景を`setOpaque(false)`で透明(非描画)にし、`JTree#paintComponent(...)`をオーバーライドして選択された行を背景色で描画
- 不透明にした`TreeCellRenderer`を使用して、ノードの選択色を`JTree#paintComponent(...)`の背景色と同じものに変更

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTable でセルのないところに行っぽい表示を出せますか？ - KrdLabの不定期日記](http://d.hatena.ne.jp/KrdLab/20071209/1197143960)
- [Highlight a node's descendants in JTree - Santhosh Kumar's Weblog](http://jroller.com/santhosh/entry/highlight_a_node_s_descendants)
    - via: [Swing - JTree - highlight entire row on selection](https://forums.oracle.com/thread/2160338)

<!-- dummy comment line for breaking list -->

### コメント
