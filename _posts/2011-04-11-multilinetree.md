---
layout: post
category: swing
folder: MultiLineTree
title: JTreeのノードタイトルを複数行表示する
tags: [JList, TreeCellRenderer, JTextArea, Html]
author: aterai
pubdate: 2011-04-11T15:20:36+09:00
description: JTreeの各ノードで改行を使用し、タイトルを複数行表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TaKbyMKLtkI/AAAAAAAAA5M/NoozvykYAUE/s800/MultiLineTree.png
comments: true
---
## 概要
`JTree`の各ノードで改行を使用し、タイトルを複数行表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TaKbyMKLtkI/AAAAAAAAA5M/NoozvykYAUE/s800/MultiLineTree.png %}

## サンプルコード
<pre class="prettyprint"><code>class MultiLineCellRenderer extends JPanel implements TreeCellRenderer {
  private DefaultTreeCellRenderer renderer = new DefaultTreeCellRenderer();
  private final JLabel icon = new JLabel();
  private final JTextArea text = new CellTextArea2();

  public MultiLineCellRenderer() {
    super(new BorderLayout(0, 0));
    text.setOpaque(true);
    text.setFont(icon.getFont());
    text.setBorder(BorderFactory.createEmptyBorder());
    icon.setOpaque(true);
    icon.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 2));
    icon.setVerticalAlignment(SwingConstants.TOP);
    setOpaque(false);
    setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
    add(icon, BorderLayout.WEST);
    add(text);
  }
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    JLabel l = (JLabel) renderer.getTreeCellRendererComponent(
      tree, value, isSelected, expanded, leaf, row, hasFocus);
    Color bColor, fColor;
    if (isSelected) {
      bColor = renderer.getBackgroundSelectionColor();
      fColor = renderer.getTextSelectionColor();
    } else {
      bColor = renderer.getBackgroundNonSelectionColor();
      fColor = renderer.getTextNonSelectionColor();
      if (bColor == null) bColor = renderer.getBackground();
      if (fColor == null) fColor = renderer.getForeground();
    }
    text.setFont(l.getFont());
    text.setText(l.getText());
    text.setForeground(fColor);
    text.setBackground(bColor);
    icon.setIcon(l.getIcon());
    icon.setBackground(bColor);
    return this;
  }
  @Override public void updateUI() {
    super.updateUI();
    renderer = new DefaultTreeCellRenderer();
  }
}
</code></pre>

<pre class="prettyprint"><code>class CellTextArea2 extends JTextArea {
  @Override public Dimension getPreferredSize() {
    Dimension d = new Dimension(10, 10);
    Insets i = getInsets();
    d.width  = Math.max(
      d.width,  getColumns() * getColumnWidth() + i.left + i.right);
    d.height = Math.max(
      d.height, getRows() * getRowHeight() + i.top + i.bottom);
    return d;
  }
  @Override public void setText(String str) {
    super.setText(str);
    FontMetrics fm = getFontMetrics(getFont());
    Document doc   = getDocument();
    Element root   = doc.getDefaultRootElement();
    int lineCount  = root.getElementCount();
    int maxWidth   = 10;
    try {
      for (int i = 0; i &lt; lineCount; i++) {
        Element e = root.getElement(i);
        int rangeStart = e.getStartOffset();
        int rangeEnd = e.getEndOffset();
        String line = doc.getText(rangeStart, rangeEnd - rangeStart);
        int width = fm.stringWidth(line);
        if (maxWidth &lt; width) {
          maxWidth = width;
        }
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    setRows(lineCount);
    setColumns(1 + maxWidth / getColumnWidth());
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTree#setRowHeight(0)`を実行して`JTree`のデフォルトの行の高さを`0`にすることでセルレンダラーが行の高さを決めるように設定し、以下の`2`つの方法で改行を行っています。

- `Html`
    - `Html`タグを使用し、`<br>`で改行
    - `parent.add(new DefaultMutableTreeNode("<html>blue<br>blue, blue"));`
- `TextAreaRenderer`
    - `JTextArea`をノードタイトルの表示に使用する`TreeCellRenderer`を作成し、`\n`で改行
    - `parent.add(new DefaultMutableTreeNode("blue\nblue, blue"));`
- 注:
    - `JTree#getRowHeight()`の初期値は`LookAndFeel`で異なり、例えば`WindowsLookAndFeel`の場合`0`以下ではない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Multi-line tree items](http://www.codeguru.com/java/articles/141.shtml)

<!-- dummy comment line for breaking list -->

## コメント
