---
layout: post
title: JTreeのノードの文字列に余白を追加
category: swing
folder: TreeCellMargin
tags: [JTree, TreeCellRenderer, Border, JLabel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-05-17

## JTreeのノードの文字列に余白を追加
`JTree`のノードにある文字列の左右に余白を追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTWBZNFbLI/AAAAAAAAAok/8_0YqLhhqTk/s800/TreeCellMargin.png)

### サンプルコード
<pre class="prettyprint"><code>class MyTreeCellRenderer2 extends DefaultTreeCellRenderer {
  private final JPanel p = new JPanel(new BorderLayout());
  private final JLabel icon = new JLabel();
  private final JLabel text = new JLabel();
  private final Border innerBorder = BorderFactory.createEmptyBorder(1,2,1,2);
  private final Border emptyBorder = BorderFactory.createCompoundBorder(
                      BorderFactory.createEmptyBorder(1,1,1,1), innerBorder);
  private final Border hasFocusBorder;
  private final TreeCellRenderer renderer;

  public MyTreeCellRenderer2(TreeCellRenderer renderer) {
    super();
    this.renderer = renderer;
    Color bsColor = getBorderSelectionColor();
    Color focusBGColor = new Color(~getBackgroundSelectionColor().getRGB());
    hasFocusBorder = BorderFactory.createCompoundBorder(
                         new DotBorder(focusBGColor, bsColor), innerBorder);
    icon.setBorder(BorderFactory.createEmptyBorder(0,0,0,2));
    text.setBorder(emptyBorder);
    text.setOpaque(true);
    p.setOpaque(false);
    p.add(icon, BorderLayout.WEST);
    p.add(text);
  }
  @Override public Component getTreeCellRendererComponent(JTree tree, Object value,
          boolean selected, boolean expanded, boolean leaf, int row, boolean hasFocus) {
    JLabel l = (JLabel)renderer.getTreeCellRendererComponent(
          tree, value, selected, expanded, leaf, row, hasFocus);
    Color bColor, fColor;
    if(selected) {
      bColor = getBackgroundSelectionColor();
      fColor = getTextSelectionColor();
    } else {
      bColor = getBackgroundNonSelectionColor();
      fColor = getTextNonSelectionColor();
      if (bColor == null) bColor = getBackground();
      if (fColor == null) fColor = getForeground();
    }
    text.setForeground(fColor);
    text.setBackground(bColor);
    text.setBorder(hasFocus?hasFocusBorder:emptyBorder);
    text.setText(l.getText());
    icon.setIcon(l.getIcon());
    return p;
  }
}
</code></pre>

### 解説
- 左
    - `Default`
- 中
    - `DefaultTreeCellRenderer#paint`メソッドをオーバーライドして、余白を追加
    - 注: `WindowsLookAndFeel`(フォーカスのボーダーがアイコンの周りには描画れさない)で、`getComponentOrientation().isLeftToRight()==true`の場合のみ対応
- 右
    - `DefaultTreeCellRenderer#getTreeCellRendererComponent`メソッドをオーバーライドして、アイコンと文字列を別の`JLabel`に分解し、文字列にのみ`BorderFactory.createEmptyBorder(0,0,0,2)`の余白を追加
    - 注: `WindowsLookAndFeel`(フォーカスのボーダーがアイコンの周りには描画れさない)で、`getComponentOrientation().isLeftToRight()==true`の場合のみ対応

<!-- dummy comment line for breaking list -->

### コメント