---
layout: post
category: swing
folder: HighlightTextForeground
title: JTextPaneで検索結果のハイライト表示と文字色変更を同時に行う
tags: [JTextPane, StyledDocument, Style, Highlighter, Matcher, Pattern]
author: aterai
pubdate: 2014-11-10T00:02:14+09:00
description: Highlighter.HighlightPainterを使用したハイライト表示では文字色が変更不可なので、JTextPaneにStyleを設定してこれを同時に適用します。
image: https://lh6.googleusercontent.com/-fNEZKm4idgc/VF96YuCU_UI/AAAAAAAANpM/7YVQ1GL5sjw/s800/HighlightTextForeground.png
comments: true
---
## 概要
`Highlighter.HighlightPainter`を使用したハイライト表示では文字色が変更不可なので、`JTextPane`に`Style`を設定してこれを同時に適用します。

{% download https://lh6.googleusercontent.com/-fNEZKm4idgc/VF96YuCU_UI/AAAAAAAANpM/7YVQ1GL5sjw/s800/HighlightTextForeground.png %}

## サンプルコード
<pre class="prettyprint"><code>StyledDocument doc = textPane.getStyledDocument();
Style def = doc.getStyle(StyleContext.DEFAULT_STYLE);
Style htf = doc.addStyle("highlight-text-foreground", def);
StyleConstants.setForeground(htf, new Color(0xFF_DD_FF));
// ...

//clear the previous highlight:
Highlighter highlighter = textPane.getHighlighter();
for (Highlighter.Highlight h: highlighter.getHighlights()) {
  doc.setCharacterAttributes(
      h.getStartOffset(), h.getEndOffset() - h.getStartOffset(), def, true);
}
highlighter.removeAllHighlights();
// ...

//match highlighting:
Highlighter.Highlight hh = highlighter.getHighlights()[current];
highlighter.removeHighlight(hh);
highlighter.addHighlight(
    hh.getStartOffset(), hh.getEndOffset(), currentPainter);
doc.setCharacterAttributes(
    hh.getStartOffset(), hh.getEndOffset() - hh.getStartOffset(), s, true);
scrollToCenter(textPane, hh.getStartOffset());
</code></pre>

## 解説
上記のサンプルでは、[JTextAreaでハイライト付き検索を行う](https://ateraimemo.com/Swing/HighlightSearch.html)で使用したコードに、以下のような変更を追加することで検索結果のハイライト表示と文字色変更を同時に行っています。

- ~~`StyledDocument`にスタイル名`regular`で`Style`を追加~~
- `StyledDocument`にスタイル名`highlight-text-foreground`で文字色のみデフォルトから変更した`Style`を追加
- 検索結果のハイライト(背景)と同時に、`StyledDocument#getStyle("highlight-text-foreground")`で取得した`Style`を`StyledDocument#setCharacterAttributes(...)`で、上書き追加
    - 現在の対象になっている検索結果以外は、`StyledDocument#getStyle("highlight-text-foreground")`の`Style`で文字色を元に元に戻す

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextAreaでハイライト付き検索を行う](https://ateraimemo.com/Swing/HighlightSearch.html)
- [JTextPaneでキーワードのSyntaxHighlight](https://ateraimemo.com/Swing/SimpleSyntaxHighlight.html)
- [Highlighterで文字列をハイライト](https://ateraimemo.com/Swing/Highlighter.html)
    - こちらのコメントからソースコードを移動して、この記事を作成

<!-- dummy comment line for breaking list -->

## コメント
