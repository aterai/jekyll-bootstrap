---
layout: post
category: swing
folder: MiddleXOfRootNodeIcon
title: JTreeのルートノードアイコンのサイズを変更し、その中央に接続線が描画されるように設定する
tags: [JTree, JLayer, TreeCellRenderer, Icon]
author: aterai
pubdate: 2016-11-21T02:08:30+09:00
description: JTreeのルートノードアイコンのみ、そのサイズを拡大し、アイコンの中央に垂直の接続線が描画されるように設定します。
image: https://drive.google.com/uc?id=1L1Zx1voPr1qT2nXuxhHn1hJ8Kzqg1mK95A
comments: true
---
## 概要
`JTree`のルートノードアイコンのみ、そのサイズを拡大し、アイコンの中央に垂直の接続線が描画されるように設定します。

{% download https://drive.google.com/uc?id=1L1Zx1voPr1qT2nXuxhHn1hJ8Kzqg1mK95A %}

## サンプルコード
<pre class="prettyprint"><code>int ow = UIManager.getIcon("Tree.openIcon").getIconWidth();
int iw = 32;
int ih = 24;
Icon icon1 = new ColorIcon(Color.GREEN, new Dimension(ow, ih));
Icon icon2 = new ColorIcon(new Color(0x55_00_00_AA, true), new Dimension(iw, ih));
JTree tree = new JTree();
tree.setRowHeight(0);
tree.setBorder(BorderFactory.createEmptyBorder(1, 1 + (iw - ow) / 2, 1, 1));
tree.setCellRenderer(new DefaultTreeCellRenderer() {
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean selected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    JLabel l = (JLabel) super.getTreeCellRendererComponent(
        tree, value, selected, expanded, leaf, row, hasFocus);
    if (value.equals(tree.getModel().getRoot())) {
      l.setIcon(icon1);
      l.setIconTextGap(2 + (iw - icon1.getIconWidth()) / 2);
    }
    return l;
  }
});
LayerUI&lt;JTree&gt; layerUI = new LayerUI&lt;JTree&gt;() {
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    Graphics2D g2 = (Graphics2D) g.create();
    icon2.paintIcon(c, g2, 1, 1);
    g2.dispose();
  }
};
</code></pre>

## 解説
- 左: デフォルト
    - `tree.setRowHeight(0)`でセルレンダラーが行の高さを決めるように設定
    - ルートノードのアイコンのみサイズを変更する`TreeCellRenderer`を設定
    - ルートノードアイコンを繋ぐ垂直の接続線は、左側寄りの位置に描画される
- 右: `setBorder` + `JLayer`
    - `tree.setRowHeight(0)`でセルレンダラーが行の高さを決めるように設定
    - `JTree`に、別途`JLayer`で描画するルートノードのアイコンの幅だけ余白を設定
        - `UIManager.put("Tree.padding", 10)`は、`SynthLookAndFeel`でのみ有効？
    - ルートノードのアイコンのみ、幅はデフォルトで高さを変更する`TreeCellRenderer`を設定
        - `JLabel#setIconTextGap(...)`メソッドで、別途`JLayer`で描画するアイコンの幅だけ余白を設定しておく
    - 本来`JTree`のルートノードアイコンとして設定したいアイコンを`JLayer`を使用して描画
    - ルートノードアイコンを繋ぐ垂直の接続線は、中央に描画される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - JTree - Move nodes to the right - Stack Overflow](https://stackoverflow.com/questions/40544376/jtree-move-nodes-to-the-right)

<!-- dummy comment line for breaking list -->

## コメント
