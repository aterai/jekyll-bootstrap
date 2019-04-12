---
layout: post
category: swing
folder: TableCellHtmlHighlighter
title: JTableのセル内文字列をHTMLタグを使用してハイライト
tags: [JTable, HTML, JLabel, TableCellRenderer, NimbusLookAndFeel]
author: aterai
pubdate: 2017-11-13T15:19:39+09:00
description: JTableのセル内文字列をHTMLタグを使用して強調表示します。
image: https://drive.google.com/uc?id=1PqzXSbIvazI6-v8INSlkDS2FOv7LtY-u-Q
comments: true
---
## 概要
`JTable`のセル内文字列を`HTML`タグを使用して強調表示します。

{% download https://drive.google.com/uc?id=1PqzXSbIvazI6-v8INSlkDS2FOv7LtY-u-Q %}

## サンプルコード
<pre class="prettyprint"><code>class HighlightTableCellRenderer extends DefaultTableCellRenderer {
  private static final String SPAN =
    "%s&lt;span style='color:#000000; background-color:#FFFF00'&gt;%s&lt;/span&gt;";
  private String pattern = "";
  private String prev;

  public boolean setPattern(String str) {
    if (Objects.equals(str, pattern)) {
      return false;
    } else {
      prev = pattern;
      pattern = str;
      return true;
    }
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    String txt = Objects.toString(value, "");
    if (Objects.nonNull(pattern) &amp;&amp; !pattern.isEmpty() &amp;&amp; !Objects.equals(pattern, prev)) {
      Matcher matcher = Pattern.compile(pattern).matcher(txt);
      int pos = 0;
      StringBuilder buf = new StringBuilder("&lt;html&gt;");
      while (matcher.find(pos) &amp;&amp; !matcher.group().isEmpty()) {
        int start = matcher.start();
        int end = matcher.end();
        buf.append(String.format(SPAN,
                                 txt.substring(pos, start), txt.substring(start, end)));
        pos = end;
      }
      buf.append(txt.substring(pos));
      txt = buf.toString();
    }
    super.getTableCellRendererComponent(table, txt, isSelected, hasFocus, row, column);
    return this;
  }
}
</code></pre>

## 解説
- 行のフィルタリング
    - [JTableの検索結果をRowFilterとHighlighterで強調表示する](https://ateraimemo.com/Swing/TableHighlightRegexFilter.html)と同様の`RowFilter.regexFilter(pattern)`で正規表現による絞り込みが可能
- セル中文字列のハイライト
    - [JTableの検索結果をRowFilterとHighlighterで強調表示する](https://ateraimemo.com/Swing/TableHighlightRegexFilter.html)はセルレンダラーとして`JTextField`を使用し、`JTextField#getHighlighter()#addHighlight(...)`でハイライト表示しているが、このサンプルでは、`JLabel`を継承する`DefaultTableCellRenderer`に`HTML`タグを適用した文字列を生成することでハイライト表示
        - ハイライトの背景色だけではなく文字色も変更可能なので、`JTable`のセル選択文字色、背景色にデフォルト色が使用可能
        - 例えば`NimbusLookAndFeel`などのようにセルを選択すると文字色が白抜き反転される`LookAndFeel`で`JTextField#getHighlighter()#addHighlight(...)`を使用する場合、セル文字色を黒に固定してセル選択背景色をハイライト背景色より薄い色に変更するなどの対策が必要

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableの検索結果をRowFilterとHighlighterで強調表示する](https://ateraimemo.com/Swing/TableHighlightRegexFilter.html)
- [JTextPaneで検索結果のハイライト表示と文字色変更を同時に行う](https://ateraimemo.com/Swing/HighlightTextForeground.html)
    - `JTextPane`とスタイルでハイライトの文字色と背景色を変更する方法もある

<!-- dummy comment line for breaking list -->

## コメント
