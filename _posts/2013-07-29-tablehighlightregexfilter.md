---
layout: post
title: JTableの検索結果をRowFilterとHighlighterで強調表示する
category: swing
folder: TableHighlightRegexFilter
tags: [JTable, RowFilter, TableRowSorter, Highlighter, TableCellRenderer, JTextField, Pattern, Matcher]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-07-29

## JTableの検索結果をRowFilterとHighlighterで強調表示する
`JTable`で正規表現による検索結果を`RowFilter`と`Highlighter`を使用して表現します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-9b6L1m5fhBk/UfUzbWaYGtI/AAAAAAAABw8/xhrIa_pJXls/s800/TableHighlightRegexFilter.png)

### サンプルコード
<pre class="prettyprint"><code>class HighlightTableCellRenderer extends JTextField implements TableCellRenderer {
  private static final Color backgroundSelectionColor = new Color(220, 240, 255);
  private static final Highlighter.HighlightPainter highlightPainter
    = new DefaultHighlighter.DefaultHighlightPainter(Color.YELLOW);
  private String pattern = "";
  private String prev = null;

  public boolean setPattern(String str) {
    if(str==null || str.equals(pattern)) {
      return false;
    }else{
      prev = pattern;
      pattern = str;
      return true;
    }
  }
  public HighlightTableCellRenderer() {
    super();
    setOpaque(true);
    setBorder(BorderFactory.createEmptyBorder());
    setForeground(Color.BLACK);
    setBackground(Color.WHITE);
    setEditable(false);
  }
  public void clearHighlights() {
    Highlighter highlighter = getHighlighter();
    for(Highlighter.Highlight h: highlighter.getHighlights()) {
      highlighter.removeHighlight(h);
    }
  }
  @Override public Component getTableCellRendererComponent(
    JTable table, Object value, boolean isSelected,
    boolean hasFocus, int row, int column) {
    String txt = value!=null ? value.toString() : "";
    clearHighlights();
    setText(txt);
    setBackground(isSelected ? backgroundSelectionColor : Color.WHITE);
    if(pattern!=null &amp;&amp; !pattern.isEmpty() &amp;&amp; !pattern.equals(prev)) {
      Matcher matcher = Pattern.compile(pattern).matcher(txt);
      if(matcher.find()) {
        int start = matcher.start();
        int end   = matcher.end();
        try{
          getHighlighter().addHighlight(start, end, highlightPainter);
        }catch(BadLocationException e) {
          e.printStackTrace();
        }
      }
    }
    return this;
  }
}
</code></pre>

### 解説
- セル中文字列のハイライト
    - [JTreeのノード中の文字列をハイライトする](http://terai.xrea.jp/Swing/HighlightWordInNode.html)
    - `JTextField`を継承する`TableCellRenderer`を作成し、`JTextField#getHighlighter()#addHighlight(...)`で検索結果の文字列をハイライト表示
- 行のフィルタリング
    - [RowFilterでJTableの行をフィルタリング](http://terai.xrea.jp/Swing/RowFilter.html)
    - `RowFilter.regexFilter(pattern)`で正規表現を使用するフィルターを作成し、その検索にマッチする行以外は非表示

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTreeのノード中の文字列をハイライトする](http://terai.xrea.jp/Swing/HighlightWordInNode.html)
- [RowFilterでJTableの行をフィルタリング](http://terai.xrea.jp/Swing/RowFilter.html)

<!-- dummy comment line for breaking list -->

### コメント