---
layout: post
title: JTreeを透明にし、選択状態を半透明にする
category: swing
folder: TranslucentTree
tags: [JTree, Translucent, Transparent, TreeCellRenderer, UIDefaults]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-01-14

## JTreeを透明にし、選択状態を半透明にする
`JTree`の背景を透明にし、ノードの選択色を半透明にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-HxmekrVRX6M/UPLEn6O6-VI/AAAAAAAABbM/XJoGyl2khVM/s800/TranslucentTree.png)

### サンプルコード
<pre class="prettyprint"><code>class TransparentTreeCellRenderer extends DefaultTreeCellRenderer {
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    JComponent c = (JComponent)super.getTreeCellRendererComponent(
        tree, value, isSelected, expanded, leaf, row, hasFocus);
    c.setOpaque(false);
    return c;
  }
  private final Color ALPHA_OF_ZERO = new Color(0, true);
  @Override public Color getBackgroundNonSelectionColor() {
    return ALPHA_OF_ZERO;
  }
  @Override public Color getBackgroundSelectionColor() {
    return ALPHA_OF_ZERO;
  }
}

class TranslucentTreeCellRenderer extends TransparentTreeCellRenderer {
  private final Color backgroundSelectionColor = new Color(100, 100, 255, 100);
  @Override public Color getBackgroundSelectionColor() {
    return backgroundSelectionColor;
  }
}
</code></pre>

### 解説
- 左: `TreeCellRenderer`を半透明化
    - `JTree#setOpaque(false);`として`JTree`や`JScrollPane`などを透明化
    - `DefaultTreeCellRenderer#getBackgroundNonSelectionColor(...)`をオーバーライドしてノードの背景色を透明化
    - `DefaultTreeCellRenderer#getBackgroundSelectionColor(...)`をオーバーライドしてノードの選択色を半透明化

<!-- dummy comment line for breaking list -->

- 右: `TreeCellRenderer`を透明化
    - `JTree#setOpaque(false);`として`JTree`や`JScrollPane`などを透明化
    - `DefaultTreeCellRenderer#getBackgroundNonSelectionColor(...)`をオーバーライドしてノードの背景色を透明化
    - `DefaultTreeCellRenderer#getBackgroundSelectionColor(...)`をオーバーライドしてノードの選択色を透明化
    - `JTree#paintComponent(...)`をオーバーライドして、半透明の選択色で`JTree`に直接選択状態を描画
        - 参考: [JTreeを行クリックで選択し、行全体を選択状態の背景色で描画](http://terai.xrea.jp/Swing/TreeRowSelection.html)

<!-- dummy comment line for breaking list -->

- - - -
`SynthLookAndFeel`系の`NimbusLookAndFeel`や`GTKLookAndFeel`などの場合、以下のようななにも描画しない`Painter`をノード選択に使用することで、選択色を半透明にすることができます。

<pre class="prettyprint"><code>//NimbusLookAndFeel(SynthLookAndFeel) JDK 1.7.0
UIDefaults d = new UIDefaults();
d.put("Tree:TreeCell[Enabled+Selected].backgroundPainter", new AbstractRegionPainter() {
  @Override protected void doPaint(Graphics2D g, JComponent c, int width, int height, Object[] extendedCacheKeys) {
    //Do nothing
  }
  @Override protected final PaintContext getPaintContext() {
    return null;
  }
});
tree2.putClientProperty("Nimbus.Overrides", d);
tree2.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
</code></pre>

### 参考リンク
- [JTreeを行クリックで選択し、行全体を選択状態の背景色で描画](http://terai.xrea.jp/Swing/TreeRowSelection.html)
- [JRootPaneの背景として画像を表示](http://terai.xrea.jp/Swing/RootPaneBackground.html)

<!-- dummy comment line for breaking list -->

### コメント
