---
layout: post
category: swing
folder: HighlightSearch
title: JTextAreaでハイライト付き検索を行う
tags: [JTextArea, JTextField, JLayer, Highlighter, Matcher, Pattern]
author: aterai
pubdate: 2014-07-07T00:34:07+09:00
description: JTextArea内の文字列を指定した条件で検索し、マッチした文字列をすべてハイライト表示します。
image: https://lh5.googleusercontent.com/-jdjIr-6A1l8/U7ljpxPgxzI/AAAAAAAACJI/x2Okpzkcce8/s800/HighlightSearch.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2014/07/highlight-all-search-pattern-matches-in.html
    lang: en
comments: true
---
## 概要
`JTextArea`内の文字列を指定した条件で検索し、マッチした文字列をすべてハイライト表示します。

{% download https://lh5.googleusercontent.com/-jdjIr-6A1l8/U7ljpxPgxzI/AAAAAAAACJI/x2Okpzkcce8/s800/HighlightSearch.png %}

## サンプルコード
<pre class="prettyprint"><code>private Pattern getPattern() {
  String text = field.getText();
  if (text == null || text.isEmpty()) {
    return null;
  }
  try {
    String cw = checkWord.isSelected() ? "\\b" : "";
    String pattern = String.format("%s%s%s", cw, text, cw);
    int flags = checkCase.isSelected()
      ? 0 : Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE;
    return Pattern.compile(pattern, flags);
  } catch (PatternSyntaxException ex) {
    field.setBackground(WARNING_COLOR);
    return null;
  }
}

private void changeHighlight() {
  field.setBackground(Color.WHITE);
  Highlighter highlighter = textArea.getHighlighter();
  highlighter.removeAllHighlights();
  Document doc = textArea.getDocument();
  try {
    Pattern pattern = getPattern();
    if (pattern != null) {
      Matcher matcher = pattern.matcher(doc.getText(0, doc.getLength()));
      int pos = 0;
      while (matcher.find(pos) &amp;&amp; !matcher.group().isEmpty()) {
        int start = matcher.start();
        int end   = matcher.end();
        highlighter.addHighlight(start, end, highlightPainter);
        pos = end;
      }
    }
    JLabel label = layerUI.hint;
    Highlighter.Highlight[] array = highlighter.getHighlights();
    int hits = array.length;
    if (hits == 0) {
      current = -1;
      label.setOpaque(true);
    } else {
      current = (current + hits) % hits;
      label.setOpaque(false);
      Highlighter.Highlight hh = highlighter.getHighlights()[current];
      highlighter.removeHighlight(hh);
      highlighter.addHighlight(
          hh.getStartOffset(), hh.getEndOffset(), currentPainter);
      scrollToCenter(textArea, hh.getStartOffset());
    }
    label.setText(String.format("%02d / %02d%n", current + 1, hits));
  } catch (BadLocationException e) {
    e.printStackTrace();
  }
  field.repaint();
}
</code></pre>

## 解説
上記のサンプルでは、以下のような条件に一致する文字列をすべてハイライト表示(黄色)する検索を行います。また、文字列入力欄に文字列が入力されている場合、マッチした結果の総数とカレントの結果(オレンジ)の順番を`JLayer`で表示します。

- `⋀`
    - 先頭に向かって検索
- `⋁`
    - 末尾に向かって検索
- `Match case`
    - チェック有りで、`Pattern.compile(...)`の引数に`0`を指定して大文字小文字の区別を行う
    - チェック無しで、`Pattern.compile(...)`の引数に`Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE`を指定し、大文字小文字の区別をしない
- `Match whole word only`
    - チェック有りで、`\b`(単語境界)を検索文字列の前後に追加して単語検索を行う

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextPaneで検索結果のハイライト表示と文字色変更を同時に行う](https://ateraimemo.com/Swing/HighlightTextForeground.html)

<!-- dummy comment line for breaking list -->

## コメント
- `Match case`の動作が逆になっていたのを修正。 -- *aterai* 2014-07-23 (水) 17:57:58
- 参考リンクのリンク先が`404`になっていたのを修正。 -- *aterai* 2015-07-27 (水) 17:57:58

<!-- dummy comment line for breaking list -->
