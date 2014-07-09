---
layout: post
title: JTextAreaでハイライト付き検索を行う
category: swing
folder: HighlightSearch
tags: [JTextArea, JTextField, JLayer, Highlighter, Matcher, Pattern]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-07-07

## JTextAreaでハイライト付き検索を行う
`JTextArea`内の文字列を指定した条件で検索し、マッチした文字列をすべてハイライト表示します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/-jdjIr-6A1l8/U7ljpxPgxzI/AAAAAAAACJI/x2Okpzkcce8/s800/HighlightSearch.png)

### サンプルコード
<pre class="prettyprint"><code>private void changeHighlight() {
  layerUI.hint.setOpaque(false);
  field.setBackground(Color.WHITE);
  Highlighter highlighter = textArea.getHighlighter();
  highlighter.removeAllHighlights();
  if (field.getText().isEmpty()) {
    return;
  }
  String cw = checkWord.isSelected() ? "\\b" : "";
  String pattern = String.format("%s%s%s", cw, field.getText(), cw);
  int flags = checkCase.isSelected() ?
    Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE : 0;
  Document doc = textArea.getDocument();
  try {
    String text = doc.getText(0, doc.getLength());
    Matcher matcher = Pattern.compile(pattern, flags).matcher(text);
    int pos = 0;
    while (matcher.find(pos)) {
      int start = matcher.start();
      int end   = matcher.end();
      highlighter.addHighlight(start, end, highlightPainter);
      pos = end;
    }
    Highlighter.Highlight[] array = highlighter.getHighlights();
    int hits = array.length;

    if (pos == 0) {
      current = -1;
      layerUI.hint.setOpaque(true);
    } else {
      current = (current + hits) % hits;
      Highlighter.Highlight hh = highlighter.getHighlights()[current];
      highlighter.removeHighlight(hh);
      highlighter.addHighlight(
          hh.getStartOffset(), hh.getEndOffset(), currentPainter);
      scrollToCenter(hh.getStartOffset());
    }
    layerUI.hint.setText(String.format("%02d / %02d%n", current + 1, hits));
  } catch (BadLocationException | PatternSyntaxException e) {
    field.setBackground(WARNING_COLOR);
  }
}
</code></pre>

### 解説
上記のサンプルでは、以下のような条件に一致する文字列をすべてハイライト表示(黄色)する検索を行います。また、文字列入力欄に文字列が入力されている場合、マッチした結果の総数とカレントの結果(オレンジでハイライト)の順番を`JLayer`で表示します。

- `⋀`
    - 前を検索
- `⋁`
    - 次を検索
- `"Match case"`
    - `Pattern.compile(...)`の引数に、`Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE`を指定して、大文字小文字の区別をしない
- `"Match whole word only"`
    - `\b`(単語境界)を検索文字列の前後に追加して、単語検索を行う

<!-- dummy comment line for breaking list -->

### コメント
