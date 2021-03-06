---
layout: post
category: swing
folder: HighlightWordInNode
title: JTreeのノード中の文字列をハイライトする
tags: [JTree, TreeCellRenderer, JTextField, HighlightPainter]
author: aterai
pubdate: 2013-07-01T00:02:16+09:00
description: JTreeのノードから文字列を検索して、HighlightPainterで強調表示します。
image: https://lh4.googleusercontent.com/-rBf-D-8MbOM/UdBIT7ksWjI/AAAAAAAABvI/m_v7K_LuLao/s800/HighlightWordInNode.png
comments: true
---
## 概要
`JTree`のノードから文字列を検索して、`HighlightPainter`で強調表示します。

{% download https://lh4.googleusercontent.com/-rBf-D-8MbOM/UdBIT7ksWjI/AAAAAAAABvI/m_v7K_LuLao/s800/HighlightWordInNode.png %}

## サンプルコード
<pre class="prettyprint"><code>class HighlightTreeCellRenderer extends JTextField
                                implements TreeCellRenderer {
  private static final Color BACKGROUND_SELECTION_COLOR = new Color(220, 240, 255);
  Highlighter.HighlightPainter highlightPainter =
    new DefaultHighlighter.DefaultHighlightPainter(Color.YELLOW);
  public String q;
  public HighlightTreeCellRenderer() {
    super();
    setOpaque(true);
    setBorder(BorderFactory.createEmptyBorder());
    setForeground(Color.BLACK);
    setBackground(Color.WHITE);
    setEditable(false);
  }

  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    String txt = Objects.toString(value, "");
    getHighlighter().removeAllHighlights();
    setText(txt);
    setBackground(isSelected ? BACKGROUND_SELECTION_COLOR : Color.WHITE);
    if (q != null &amp;&amp; !q.isEmpty() &amp;&amp; txt.startsWith(q)) {
      try {
        getHighlighter().addHighlight(0, q.length(), highlightPainter);
      } catch (BadLocationException e) {
        e.printStackTrace();
      }
    }
    return this;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`TreeCellRenderer`に`JLabel`ではなく`JTextField`を使用して`JTextField#getHighlighter()#addHighlight(...)`メソッドで検索中の文字列をハイライト表示しています。

## 参考リンク
- [JTreeで条件に一致するノードを検索しハイライト](https://ateraimemo.com/Swing/TreeNodeHighlightSearch.html)
    - こちらは、ノードの色を変更してハイライト表示
- [Highlighterで文字列をハイライト](https://ateraimemo.com/Swing/Highlighter.html)

<!-- dummy comment line for breaking list -->

## コメント
