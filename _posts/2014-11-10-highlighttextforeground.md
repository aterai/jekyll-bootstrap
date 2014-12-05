---
layout: post
category: swing
folder: HighlightTextForeground
title: JTextPaneで検索結果のハイライト表示と文字色変更を同時に行う
tags: [JTextPane, StyledDocument, Style, Highlighter, Matcher, Pattern]
author: aterai
pubdate: 2014-11-10T00:02:14+09:00
description: Highlighter.HighlightPainterを使用したハイライト表示では文字色を変更することが出来ないので、JTextPaneにStyleを適用してこれを同時に行います。
comments: true
---
## 概要
`Highlighter.HighlightPainter`を使用したハイライト表示では文字色を変更することが出来ないので、`JTextPane`に`Style`を適用してこれを同時に行います。

{% download https://lh6.googleusercontent.com/-fNEZKm4idgc/VF96YuCU_UI/AAAAAAAANpM/7YVQ1GL5sjw/s800/HighlightTextForeground.png %}

## サンプルコード
<pre class="prettyprint"><code>StyledDocument doc = textPane.getStyledDocument();
Style def = StyleContext.getDefaultStyleContext().getStyle(StyleContext.DEFAULT_STYLE);
Style regular = doc.addStyle("regular", def);
Style htf = doc.addStyle("highlight-text-foreground", regular);
StyleConstants.setForeground(htf, new Color(0xFFDDFF));
//...

//clear the previous highlight:
Highlighter highlighter = textPane.getHighlighter();
for (Highlighter.Highlight h: highlighter.getHighlights()) {
  doc.setCharacterAttributes(
      h.getStartOffset(), h.getEndOffset() - h.getStartOffset(), def, true);
}
highlighter.removeAllHighlights();
//...

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
上記のサンプルでは、[JTextAreaでハイライト付き検索を行う](http://ateraimemo.com/Swing/HighlightSearch.html)に、以下のような変更を追加することで、検索結果のハイライト表示と文字色変更を同時に行っています。

- `StyledDocument`に名称`"regular"`で`Style`を追加
- `StyledDocument`に親`Style`が`"regular"`で、名称`"highlight-text-foreground"`、文字色のみ変更した`Style`を追加
- 検索結果のハイライト(背景)と同時に、`StyledDocument#getStyle("highlight-text-foreground")`で取得した`Style`を`StyledDocument#setCharacterAttributes(...)`で、上書き追加
    - 現在の対象になっている検索結果以外は、`StyledDocument#getStyle("highlight-text-foreground")`の`Style`で文字色を元に元に戻す

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextAreaでハイライト付き検索を行う](http://ateraimemo.com/Swing/HighlightSearch.html)
- [JTextPaneでキーワードのSyntaxHighlight](http://ateraimemo.com/Swing/SimpleSyntaxHighlight.html)
- [Highlighterで文字列をハイライト](http://ateraimemo.com/Swing/Highlighter.html)
    - こちらのコメントからソースコードを移動。

<!-- dummy comment line for breaking list -->

## コメント