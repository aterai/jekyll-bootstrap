---
layout: post
title: JTreeのノードをハイライト
category: swing
folder: RollOverTree
tags: [JTree, TreeCellRenderer, MouseMotionListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-05-21

## 概要
`JTree`のノード上にマウスカーソルがきたら、ハイライト表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTSHWXxwwI/AAAAAAAAAiQ/MP7tLgM--lo/s800/RollOverTree.png %}

## サンプルコード
<pre class="prettyprint"><code>class MyTreeCellRenderer extends DefaultTreeCellRenderer implements MouseMotionListener {
  private static final Color rollOverRowColor = new Color(220,240,255);
  private final JTree tree;
  private final TreeCellRenderer renderer;
  public MyTreeCellRenderer(JTree tree, TreeCellRenderer renderer) {
    this.tree = tree;
    this.renderer = renderer;
    tree.addMouseMotionListener(this);
  }
  @Override public Component getTreeCellRendererComponent(
          JTree tree, Object value, boolean isSelected,
          boolean expanded, boolean leaf, int row, boolean hasFocus) {
    JComponent c = (JComponent)renderer.getTreeCellRendererComponent(
        tree, value, isSelected, expanded, leaf, row, hasFocus);
    if(row==rollOverRowIndex) {
      c.setOpaque(true);
      c.setBackground(rollOverRowColor);
      if(isSelected) c.setForeground(getTextNonSelectionColor());
    }else{
      c.setOpaque(false);
    }
    return c;
  }
  private int rollOverRowIndex = -1;
  @Override public void mouseMoved(MouseEvent e) {
    int row = tree.getRowForLocation(e.getX(), e.getY());
    if(row!=rollOverRowIndex) {
      //System.out.println(row);
      rollOverRowIndex = row;
      tree.repaint();
    }
  }
  @Override public void mouseDragged(MouseEvent e) {}
}
</code></pre>

## 解説
`JTree`からデフォルトのセルレンダラーを取得し、これを委譲してセルレンダラーを作成しています。

- 継承ではなく、委譲を使うのは、ノードをハイライトしない場合は、`Windows`などでのノードアイコンは選択されない、文字列だけ選択されるという描画をそのまま利用するため
- 継承もしているが、これは、`JTable`と違い`DefaultTreeCellRenderer`からノードを選択した時の色などを取得するようになっているためで、あまり意味はない

<!-- dummy comment line for breaking list -->

このレンダラーは`MouseMotionListener`を実装し、`getTreeCellRendererComponent`メソッドの実装で、ハイライト表示したいノードの場合は、
委譲したレンダラーから得たコンポーネントを`setOpaque(true)`、`setForeground(Color)`などで修飾して返すようになっています。

## 参考リンク
- [JTreeで条件に一致するノードを検索しハイライト](http://terai.xrea.jp/Swing/TreeNodeHighlightSearch.html)

<!-- dummy comment line for breaking list -->

## コメント
