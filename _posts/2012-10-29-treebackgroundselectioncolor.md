---
layout: post
category: swing
folder: TreeBackgroundSelectionColor
title: JTreeの選択背景色を変更
tags: [JTree, TreeCellRenderer]
author: aterai
pubdate: 2012-10-29T01:14:10+09:00
description: JTreeのノード条件によって、その選択背景色を変更します。
image: https://lh4.googleusercontent.com/-7JA4jpNa55U/UI1VhdHlkwI/AAAAAAAABVw/dAUHGh4q014/s800/TreeBackgroundSelectionColor.png
comments: true
---
## 概要
`JTree`のノード条件によって、その選択背景色を変更します。

{% download https://lh4.googleusercontent.com/-7JA4jpNa55U/UI1VhdHlkwI/AAAAAAAABVw/dAUHGh4q014/s800/TreeBackgroundSelectionColor.png %}

## サンプルコード
<pre class="prettyprint"><code>class SelectionColorTreeCellRenderer extends DefaultTreeCellRenderer {
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    JComponent c = (JComponent) super.getTreeCellRendererComponent(
        tree, value, isSelected, expanded, leaf, row, hasFocus);
    if (isSelected) {
      setParticularCondition(value);
      c.setForeground(getTextSelectionColor());
      c.setBackground(getBackgroundSelectionColor());
      if (leaf &amp;&amp; value.toString().startsWith("a")) {
        c.setOpaque(true);
        c.setBackground(Color.RED);
      } else {
        c.setOpaque(false);
        c.setBackground(getBackgroundSelectionColor());
      }
    } else {
      c.setForeground(getTextNonSelectionColor());
      c.setBackground(getBackgroundNonSelectionColor());
    }
    return c;
  }
  private Color color = null;
  private void setParticularCondition(Object value) {
    if (value instanceof DefaultMutableTreeNode) {
      Object uo = ((DefaultMutableTreeNode) value).getUserObject();
      if (uo instanceof Color) {
        color = (Color) uo;
        return;
      }
    }
    color = null;
  }
  @Override public Color getBackgroundSelectionColor() {
    return color != null ? color : super.getBackgroundSelectionColor();
  }
}
</code></pre>

## 解説
上記のサンプルでは、以下の条件でノードの選択時背景色を変更しています。

- `DefaultMutableTreeNode#getUserObject()`が`Color`の場合、その色を選択時背景色に採用
    - `DefaultTreeCellRenderer#getBackgroundSelectionColor()`をオーバーライド
    - ノードアイコンの背景は選択状態にならず、ノードテキストの背景色のみ変更される
- ノードテキストが`a`で始まる場合、選択背景色を`Color.RED`に変更
    - `TreeCellRenderer#getTreeCellRendererComponent(...)`で取得したコンポーネント(`JLabel`)を`setOpaque(true)`で不透明、`setBackground(Color.RED)`で背景色を変更
    - ノードアイコン、テキストの背景色が共に選択状態になる
    - `SynthLookAndFeel`で作成されている`NimbusLookAndFeel`などでは、上記のような選択背景色にならない場合がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultTreeCellRenderer (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellRenderer.html)

<!-- dummy comment line for breaking list -->

## コメント
