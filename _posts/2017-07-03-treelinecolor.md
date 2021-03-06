---
layout: post
category: swing
folder: TreeLineColor
title: JTreeのノード間の接続線の色を変更する
tags: [JTree, LookAndFeel, UIManager, BasicStroke]
author: aterai
pubdate: 2017-07-03T14:32:43+09:00
description: JTreeのノード間の接続線の色、太さなどを変更します。
image: https://drive.google.com/uc?id=1btj2ocoJQdwg8t8Smv1O29xUUFsfjbR5zA
comments: true
---
## 概要
`JTree`のノード間の接続線の色、太さなどを変更します。

{% download https://drive.google.com/uc?id=1btj2ocoJQdwg8t8Smv1O29xUUFsfjbR5zA %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Tree.paintLines", Boolean.TRUE);
UIManager.put("Tree.lineTypeDashed", Boolean.TRUE);
UIManager.put("Tree.line", Color.GREEN);
UIManager.put("Tree.hash", Color.RED);

JTree tree0 = new JTree();

JTree tree1 = new JTree();
tree1.putClientProperty("JTree.lineStyle", "Horizontal");

JTree tree2 = new JTree();
tree2.setUI(new BasicTreeUI() {
  private final Stroke horizontalLine = new BasicStroke(2f);
  private final Stroke verticalLine = new BasicStroke(5f);

  @Override public Color getHashColor() {
    return Color.BLUE;
  }

  @Override protected void paintHorizontalPartOfLeg(
      Graphics g, Rectangle clipBounds, Insets insets,
      Rectangle bounds, TreePath path, int row,
      boolean isExpanded, boolean hasBeenExpanded, boolean isLeaf) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setStroke(horizontalLine);
    super.paintHorizontalPartOfLeg(
        g2, clipBounds, insets, bounds, path, row,
        isExpanded, hasBeenExpanded, isLeaf);
    g2.dispose();
  }

  @Override protected void paintVerticalPartOfLeg(
      Graphics g, Rectangle clipBounds, Insets insets, TreePath path) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setStroke(verticalLine);
    super.paintVerticalPartOfLeg(g2, clipBounds, insets, path);
    g2.dispose();
  }
});
</code></pre>

## 解説
- 左: `lineTypeDashed`
    - `UIManager.put("Tree.lineTypeDashed", Boolean.TRUE);`を設定して接続線を点線に変更
    - `UIManager.put("Tree.hash", Color.RED);`で線色を変更可能
- 中: `lineStyle`
    - `tree1.putClientProperty("JTree.lineStyle", "Horizontal");`を設定して親ノードの上下に水平線を表示するスタイルに変更
        - 参考: [JTreeのノード間の接続線のスタイルを変更する](https://ateraimemo.com/Swing/TreeLineStyle.html)
    - `UIManager.put("Tree.line", Color.GREEN);`で水平線の線色を変更可能
        - 接続線の線色には影響しない
- 右: `BasicTreeUI`
    - `BasicTreeUI#paintHorizontalPartOfLeg(...)`、`BasicTreeUI#paintVerticalPartOfLeg(...)`をオーバーライドして、接続線の太さを変更
    - 接続線の色は、`BasicTreeUI#getHashColor()`をオーバーライドして変更
    - ~~`UIManager.put("Tree.lineTypeDashed", Boolean.TRUE);`の設定などは無視される~~
    - `UIManager.put("Tree.lineTypeDashed", Boolean.TRUE);`の場合、`Graphics2D#setStroke(...)`の設定が無効になる場合がある？
    - `BasicTreeUI`は点線の描画に`BasicStroke`を使用せず、以下のように`1px`の線を描画しているため？
        
        <pre class="prettyprint"><code>// This method is slow -- revisit when Java2D is ready.
        // assumes y1 &lt;= y2
        protected void drawDashedVerticalLine(Graphics g, int x, int y1, int y2) {
          // Drawing only even coordinates helps join line segments so they
          // appear as one line.  This can be defeated by translating the
          // Graphics by an odd amount.
          y1 += (y1 % 2);
          for (int y = y1; y &lt;= y2; y+=2) {
            g.drawLine(x, y, x, y);
          }
        }
</code></pre>
    - * 参考リンク [#reference]
- [JTreeのノード間の接続線のスタイルを変更する](https://ateraimemo.com/Swing/TreeLineStyle.html)

<!-- dummy comment line for breaking list -->

## コメント
