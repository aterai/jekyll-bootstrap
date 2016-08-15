---
layout: post
category: swing
folder: TreeNodeHighlightSearch
title: JTreeで条件に一致するノードを検索しハイライト
tags: [JTree, TreeCellRenderer]
author: aterai
pubdate: 2010-10-18T14:37:59+09:00
description: JTreeを検索し、TreeCellRendererを使ってノードをハイライトします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWIqTzfbI/AAAAAAAAAow/n7eIy_ax-zY/s800/TreeNodeHighlightSearch.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2010/10/jtree-node-highlight-search.html
    lang: en
comments: true
---
## 概要
`JTree`を検索し、`TreeCellRenderer`を使ってノードをハイライトします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWIqTzfbI/AAAAAAAAAow/n7eIy_ax-zY/s800/TreeNodeHighlightSearch.png %}

## サンプルコード
<pre class="prettyprint"><code>class HighlightTreeCellRenderer extends DefaultTreeCellRenderer {
  private static final Color rollOverRowColor = new Color(220, 240, 255);
  private final TreeCellRenderer renderer;
  public String q;
  public HighlightTreeCellRenderer(TreeCellRenderer renderer) {
    this.renderer = renderer;
  }
  @Override public Component getTreeCellRendererComponent(JTree tree, Object value,
        boolean isSelected, boolean expanded,
        boolean leaf, int row, boolean hasFocus) {
    JComponent c = (JComponent) renderer.getTreeCellRendererComponent(
        tree, value, isSelected, expanded, leaf, row, hasFocus);
    if (isSelected) {
      c.setOpaque(false);
      c.setForeground(getTextSelectionColor());
      //c.setBackground(Color.BLUE); //getBackgroundSelectionColor());
    } else {
      c.setOpaque(true);
      if (q != null &amp;&amp; !q.isEmpty() &amp;&amp; value.toString().startsWith(q)) {
        c.setForeground(getTextNonSelectionColor());
        c.setBackground(rollOverRowColor);
      } else {
        c.setForeground(getTextNonSelectionColor());
        c.setBackground(getBackgroundNonSelectionColor());
      }
    }
    return c;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTextField`に入力した文字列に`startsWith(...)`で一致するノードをハイライトしています。デフォルトの`TreeCellRenderer`は、`isOpaque()==Boolean.FALSE`で、選択色は`DefaultTreeCellRenderer#paint(Graphics g)`で塗りつぶされる(ノードアイコンを除いて選択状態にするため？)ので、検索のハイライトの為にレンダラーを`setOpaque(true)`としてしまうと、マウスなどでノードを選択しても背景色が変更されません。このため、`DefaultTreeCellRenderer#getTreeCellRendererComponent(...)`内で、検索のハイライトはレンダラーを`setOpaque(true)`、ノードの選択は`setOpaque(false)`となるように設定しています。

- - - -
- `DefaultTreeCellRenderer#getBackgroundNonSelectionColor()`をオーバーライドする場合、デフォルトの選択領域(ノードアイコンは含まず、ノードテキストのみ)で選択色を変更することが可能
    - [JTreeの選択背景色を変更](http://ateraimemo.com/Swing/TreeBackgroundSelectionColor.html)に移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのノードを検索する](http://ateraimemo.com/Swing/SearchBox.html)
- [JTreeのノードを展開・折り畳み](http://ateraimemo.com/Swing/ExpandAllNodes.html)
- [JTreeのノードをハイライト](http://ateraimemo.com/Swing/RollOverTree.html)
- [JTreeの選択背景色を変更](http://ateraimemo.com/Swing/TreeBackgroundSelectionColor.html)
- [JTreeのノード中の文字列をハイライトする](http://ateraimemo.com/Swing/HighlightWordInNode.html)
    - ノードではなく一致する文字列だけをハイライトして強調表示する場合のサンプル

<!-- dummy comment line for breaking list -->

## コメント
