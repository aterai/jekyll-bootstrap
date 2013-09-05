---
layout: post
title: JTreeのノード中の文字列をハイライトする
category: swing
folder: HighlightWordInNode
tags: [JTree, TreeCellRenderer, JTextField, HighlightPainter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-07-01

## JTreeのノード中の文字列をハイライトする
`JTree`のノードから文字列を検索して、`HighlightPainter`で強調表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-rBf-D-8MbOM/UdBIT7ksWjI/AAAAAAAABvI/m_v7K_LuLao/s800/HighlightWordInNode.png)

### サンプルコード
<pre class="prettyprint"><code>class HighlightTreeCellRenderer extends JTextField
                                implements TreeCellRenderer {
  Color backgroundSelectionColor = new Color(220, 240, 255);
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
  public void removeHighlights() {
    Highlighter highlighter = getHighlighter();
    for(Highlighter.Highlight h: highlighter.getHighlights()) {
      highlighter.removeHighlight(h);
    }
  }
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    String txt = value!=null ? value.toString() : "";
    removeHighlights();
    setText(txt);
    setBackground(isSelected ? backgroundSelectionColor : Color.WHITE);
    if(q!=null &amp;&amp; !q.isEmpty() &amp;&amp; txt.startsWith(q)) {
      try {
        getHighlighter().addHighlight(0, q.length(), highlightPainter);
      } catch(BadLocationException e) {
        e.printStackTrace();
      }
    }
    return this;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`TreeCellRenderer`に`JLabel`ではなく、`JTextField`を使用し`JTextField#getHighlighter()#addHighlight(...)`で検索中の文字列をハイライト表示しています。

### 参考リンク
- [JTreeで条件に一致するノードを検索しハイライト](http://terai.xrea.jp/Swing/TreeNodeHighlightSearch.html)
    - こちらは、ノードの色を変更してハイライト表示
- [Highlighterで文字列をハイライト](http://terai.xrea.jp/Swing/Highlighter.html)

<!-- dummy comment line for breaking list -->

### コメント