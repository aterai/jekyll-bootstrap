---
layout: post
category: swing
folder: RollOverTree
title: JTreeのノードをハイライト
tags: [JTree, TreeCellRenderer, MouseMotionListener]
author: aterai
pubdate: 2007-05-21T05:44:50+09:00
description: JTreeのノード上にマウスカーソルがきたら、ハイライト表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTSHWXxwwI/AAAAAAAAAiQ/MP7tLgM--lo/s800/RollOverTree.png
comments: true
---
## 概要
`JTree`のノード上にマウスカーソルがきたら、ハイライト表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTSHWXxwwI/AAAAAAAAAiQ/MP7tLgM--lo/s800/RollOverTree.png %}

## サンプルコード
<pre class="prettyprint"><code>private final JTree tree = new JTree(makeModel()) {
  private final Color rolloverRowColor = new Color(220, 240, 255);
  private int rollOverRowIndex = -1;
  private transient MouseMotionListener listener;
  @Override public void updateUI() {
    removeMouseMotionListener(listener);
    super.updateUI();
    setCellRenderer(new DefaultTreeCellRenderer() {
      @Override public Component getTreeCellRendererComponent(
          JTree tree, Object value, boolean selected, boolean expanded,
          boolean leaf, int row, boolean hasFocus) {
        JComponent c = (JComponent) super.getTreeCellRendererComponent(
            tree, value, selected, expanded, leaf, row, hasFocus);
        if (row == rollOverRowIndex) {
          c.setOpaque(true);
          c.setBackground(rolloverRowColor);
          if (selected) {
            c.setForeground(getTextNonSelectionColor());
          }
        } else {
          c.setOpaque(false);
        }
        return c;
      }
    });
    listener = new MouseAdapter() {
      @Override public void mouseMoved(MouseEvent e) {
        int row = getRowForLocation(e.getX(), e.getY());
        if (row != rollOverRowIndex) {
          rollOverRowIndex = row;
          repaint();
        }
      }
    };
    addMouseMotionListener(listener);
  }
};
</code></pre>

## 解説
- `JTree`に`MouseMotionListener`を設定して現在マウスカーソルが存在する行を記録
- `DefaultTreeCellRenderer#getTreeCellRendererComponent(...)`メソッドをオーバーライドし、カーソル行の場合はノードの不透明設定(`setOpaque(true)`)と背景色を変更(`setForeground(Color)`)
- `DefaultTreeCellRenderer`は、`JTable`とは異なり、`DefaultTreeCellRenderer#getTextNonSelectionColor()`などのメソッドが使用可能
    - `DefaultTableCellRenderer`に選択時の文字色や背景色を取得するメソッドはなく、`JTable#getSelectionBackground()`などを使用する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeで条件に一致するノードを検索しハイライト](http://ateraimemo.com/Swing/TreeNodeHighlightSearch.html)

<!-- dummy comment line for breaking list -->

## コメント
