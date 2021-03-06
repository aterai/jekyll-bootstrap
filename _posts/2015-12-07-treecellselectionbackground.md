---
layout: post
category: swing
folder: TreeCellSelectionBackground
title: NimbusLookAndFeelでJTreeのセル選択を行全体ではなくノードに限定する
tags: [JTree, LookAndFeel, NimbusLookAndFeel, UIDefaults]
author: aterai
pubdate: 2015-12-07T02:44:17+09:00
description: JTreeのセル選択色で塗りつぶす範囲をNimbusLookAndFeelのデフォルトになっている行全体ではなくノードのみになるように設定します。
image: https://lh3.googleusercontent.com/-iMbDreRXOYI/VmRwiLsVZmI/AAAAAAAAOIg/tfanc-vemfo/s800-Ic42/TreeCellSelectionBackground.png
comments: true
---
## 概要
`JTree`のセル選択色で塗りつぶす範囲を`NimbusLookAndFeel`のデフォルトになっている行全体ではなくノードのみになるように設定します。

{% download https://lh3.googleusercontent.com/-iMbDreRXOYI/VmRwiLsVZmI/AAAAAAAAOIg/tfanc-vemfo/s800-Ic42/TreeCellSelectionBackground.png %}

## サンプルコード
<pre class="prettyprint"><code>UIDefaults def = new UIDefaults();
JTree tree = new JTree();
tree.putClientProperty("Nimbus.Overrides", def);
tree.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
tree.setBackground(Color.WHITE);

tree.setCellRenderer(new DefaultTreeCellRenderer() {
  private final Color selectionBackground = new Color(0x39_69_8A);
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean selected, boolean expanded,
      boolean isLeaf, int row, boolean focused) {
    JComponent c = (JComponent) super.getTreeCellRendererComponent(
        tree, value, selected, expanded, isLeaf, row, focused);
    if (selected) {
      c.setBackground(selectionBackground);
      c.setOpaque(true);
    } else {
      c.setOpaque(false);
    }
    return c;
  }
});
</code></pre>

## 解説
上記のサンプルでは、`NimbusLookAndFeel`がデフォルトで使用するセルレンダラーなどを空にした`UIDefaults`を`JTree`に設定し、選択時にノードのみ背景色で塗りつぶしを行うセルレンダラーを`JTree#setCellRenderer(...)`で設定して使用しています。

- - - -
- 親ノードの左に表示される三角のアイコン(`collapsedIcon`、`expandedIcon`)が選択されている場合の色を変更する方法がない？
    
    <pre class="prettyprint"><code>UIDefaults def = new UIDefaults();
    def.put("Tree.selectionBackground", Color.WHITE);
    def.put("Tree.selectionForeground", Color.GREEN);
    def.put("Tree.opaque", Boolean.FALSE);
    def.put("Tree:TreeCell[Enabled+Selected].textForeground", Color.GREEN);
    def.put("Tree.rendererFillBackground", true);
    def.put("Tree.repaintWholeRow", true);
    def.put("Tree:TreeCell[Enabled+Selected].backgroundPainter", new Painter&lt;JComponent&gt;() {
      @Override public void paint(Graphics2D g, JComponent c, int w, int h) {
        //g.setPaint(Color.RED);
        //g.fillRect(0, 0, w, h);
      }
    });
    def.put("Tree:TreeCell[Focused+Selected].backgroundPainter", new Painter&lt;JComponent&gt;() {
      @Override public void paint(Graphics2D g, JComponent c, int w, int h) {
        //g.setPaint(Color.RED);
        //g.fillRect(0, 0, w, h);
      }
    });
    def.put("Tree[Enabled].collapsedIconPainter", null);
    def.put("Tree[Enabled].expandedIconPainter", null);
    def.put("Tree[Enabled+Selected].collapsedIconPainter", null);
    def.put("Tree[Enabled+Selected].expandedIconPainter", null);
</code></pre>
- * 参考リンク [#reference]
- [swing - JTree Nimbus Selectionbackground not Working on Java 1.8 - Stack Overflow](https://stackoverflow.com/questions/33939381/jtree-nimbus-selectionbackground-not-working-on-java-1-8)
- [JTreeを行クリックで選択し、行全体を選択状態の背景色で描画](https://ateraimemo.com/Swing/TreeRowSelection.html)
    - こちらは逆に、`MetalLookAndFeel`などで行全体の選択を行う方法

<!-- dummy comment line for breaking list -->

## コメント
