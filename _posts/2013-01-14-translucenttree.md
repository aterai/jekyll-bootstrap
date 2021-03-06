---
layout: post
category: swing
folder: TranslucentTree
title: JTreeを透明にし、選択状態を半透明にする
tags: [JTree, Translucent, Transparent, TreeCellRenderer, UIDefaults]
author: aterai
pubdate: 2013-01-14T00:01:16+09:00
description: JTreeの背景を透明にし、ノードの選択色を半透明にします。
image: https://lh4.googleusercontent.com/-HxmekrVRX6M/UPLEn6O6-VI/AAAAAAAABbM/XJoGyl2khVM/s800/TranslucentTree.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2014/11/make-transparent-jtree-and-translucent.html
    lang: en
comments: true
---
## 概要
`JTree`の背景を透明にし、ノードの選択色を半透明にします。

{% download https://lh4.googleusercontent.com/-HxmekrVRX6M/UPLEn6O6-VI/AAAAAAAABbM/XJoGyl2khVM/s800/TranslucentTree.png %}

## サンプルコード
<pre class="prettyprint"><code>class TransparentTreeCellRenderer extends DefaultTreeCellRenderer {
  private final Color ALPHA_OF_ZERO = new Color(0x0, true);
  @Override public Component getTreeCellRendererComponent(
          JTree tree, Object value, boolean isSelected, boolean expanded,
          boolean leaf, int row, boolean hasFocus) {
    JComponent c = (JComponent) super.getTreeCellRendererComponent(
          tree, value, isSelected, expanded, leaf, row, hasFocus);
    c.setOpaque(false);
    return c;
  }

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

## 解説
- 左: `TreeCellRenderer`を半透明化
    - `setOpaque(false)`で`JTree`と`JScrollPane`を透明化
    - `DefaultTreeCellRenderer#getBackgroundNonSelectionColor(...)`をオーバーライドしてノードの背景色を透明化
    - `DefaultTreeCellRenderer#getBackgroundSelectionColor(...)`をオーバーライドしてノードの選択色を半透明化

<!-- dummy comment line for breaking list -->

- 右: `TreeCellRenderer`を透明化
    - `JTree#setOpaque(false);`として`JTree`や`JScrollPane`などを透明化
    - `DefaultTreeCellRenderer#getBackgroundNonSelectionColor(...)`をオーバーライドしてノードの背景色を透明化
    - `DefaultTreeCellRenderer#getBackgroundSelectionColor(...)`をオーバーライドしてノードの選択色を透明化
    - `JTree#paintComponent(...)`をオーバーライドして半透明の選択色で`JTree`に直接選択状態を描画
        - 参考: [JTreeを行クリックで選択し、行全体を選択状態の背景色で描画](https://ateraimemo.com/Swing/TreeRowSelection.html)

<!-- dummy comment line for breaking list -->

- - - -
- `SynthLookAndFeel`系の`NimbusLookAndFeel`の場合、以下のような何も描画しない`Painter`をノード選択に使用することでその選択色は半透明になる
    - ただし同じ`SynthLookAndFeel`系でも`GTKLookAndFeel`の場合は、[SynthでJInternalFrameを半透明にする](https://ateraimemo.com/Swing/TranslucentFrame.html)のように`SynthStyle#isOpaque(...)`が`Region.TREE_CELL`の時は`false`になるように設定する必要がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>// NimbusLookAndFeel(SynthLookAndFeel) JDK 1.7.0
UIDefaults d = new UIDefaults();
d.put("Tree:TreeCell[Enabled+Selected].backgroundPainter", new Painter&lt;JComponent&gt;() {
  @Override public void paint(Graphics2D g, JComponent c, int width, int height) {
    // Do nothing
  }
});
tree2.putClientProperty("Nimbus.Overrides", d);
tree2.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
</code></pre>

## 参考リンク
- [JTreeを行クリックで選択し、行全体を選択状態の背景色で描画](https://ateraimemo.com/Swing/TreeRowSelection.html)
- [JRootPaneの背景として画像を表示](https://ateraimemo.com/Swing/RootPaneBackground.html)

<!-- dummy comment line for breaking list -->

## コメント
