---
layout: post
category: swing
folder: Highlighter
title: Highlighterで文字列をハイライト
tags: [JTextComponent, Highlighter]
author: aterai
pubdate: 2005-12-05T11:02:14+09:00
description: Highlighterを使ってテキスト中の文字列を強調表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTN25SyRaI/AAAAAAAAAbc/i3gVEjh-mlQ/s800/Highlighter.png
comments: true
---
## 概要
`Highlighter`を使ってテキスト中の文字列を強調表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTN25SyRaI/AAAAAAAAAbc/i3gVEjh-mlQ/s800/Highlighter.png %}

## サンプルコード
<pre class="prettyprint"><code>jtc.getHighlighter().removeAllHighlights();
try {
  Highlighter highlighter = jtc.getHighlighter();
  Document doc = jtc.getDocument();
  String text = doc.getText(0, doc.getLength());
  Matcher matcher = Pattern.compile(pattern).matcher(text);
  int pos = 0;
  while (matcher.find(pos)) {
    pos = matcher.end();
    highlighter.addHighlight(matcher.start(), pos, highlightPainter);
  }
} catch (BadLocationException | PatternSyntaxException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
テキストコンポーネントから`Highlighter`を取得し、`Highlighter#addHighlight(...)`メソッドで検索した文字列を追加していきます。

上記のサンプルでは、ハイライト色を`DefaultHighlighter.DefaultHighlightPainter`を使って指定しています。

## 参考リンク
- [Highlighter#addHighlight(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Highlighter.html#addHighlight-int-int-javax.swing.text.Highlighter.HighlightPainter-)
- [Swing - Searching text in files & highlighting that text](https://community.oracle.com/thread/1387954)
- [JTextPaneで検索結果のハイライト表示と文字色変更を同時に行う](https://ateraimemo.com/Swing/HighlightTextForeground.html)

<!-- dummy comment line for breaking list -->

## コメント
- こんにちは。はじめまして。Keithと言います。このプログラムだと、テキスト中の複数の異なる文字に、それぞれハイライトを割り当てることが出来ないのですが、解決策はあるでしょうか。 -- *Keith* 2007-11-28 (水) 19:12:19
    - こんばんは。`Highlighter#addHighlight`メソッドは、複数のハイライトを追加できるので、パターン毎に色を変えたいだけなら(効率とか、同じ文字列が含まれる場合とか、エラー処理などの面倒なことは考えない)、以下のようにパターンを配列にして繰り返すだけでもいいかもしれません。 -- *aterai* 2007-11-28 (水) 20:25:31

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private final Highlighter.HighlightPainter[] highlightPainter = {
  new DefaultHighlighter.DefaultHighlightPainter(Color.YELLOW),
  new DefaultHighlighter.DefaultHighlightPainter(Color.CYAN)
};
private final String[] pattern = {"Swing", "win"};
public void setHighlight(JTextComponent jtc, String[] pattern) {
  try {
    Highlighter hilite = jtc.getHighlighter();
    hilite.removeAllHighlights();
    Document doc = jtc.getDocument();
    String text = doc.getText(0, doc.getLength());
    for (int i = 0; i &lt; pattern.length; i++) {
      int pos = 0;
      while ((pos = text.indexOf(pattern[i], pos)) &gt;= 0) {
        hilite.addHighlight(pos, pos + pattern[i].length(), highlightPainter[i]);
        pos += pattern[i].length();
      }
    }
  } catch (BadLocationException e) {
    e.printStackTrace();
  }
}
</code></pre>

- こんな簡単にハイライトできるとは！。正規表現で実装すると開始位置と終了位置がより簡単で、しかも複雑にできるかも。 -- *eternalharvest* 2008-08-28 (木) 02:20:11
    - ちょっと夏休みで帰省してました。正規表現 > そうですね。基本的には同じような要領で大丈夫だと思います。メモ: [Swing - Content-Overlay in JTextPane](https://community.oracle.com/thread/1382907)、追記: [DefaultHighlighterの描画方法を変更する](https://ateraimemo.com/Swing/DrawsLayeredHighlights.html)に、`Matcher matcher = Pattern.compile(pattern).matcher(text);`と正規表現でハイライトするサンプルを追加。追記2: このサンプルでも正規表現を使用するように変更。 -- *aterai* 2008-09-01 (月) 13:47:05
- こんにちは。Cakaiと申します。ハイライトされているテキストのカラーを設定することがありますか？ -- *Caokai* 2009-10-15 (Thu) 23:12:47
    - こんにちは。はじめまして。`Highlighter.HighlightPainter`で、文字色は変更できないかもしれません。以下のように`AttributeSet`を使うのはどうでしょう。[JTextPaneでキーワードのSyntaxHighlight](https://ateraimemo.com/Swing/SimpleSyntaxHighlight.html) -- *aterai* 2009-10-16 (金) 13:04:32
        - 用途によっては、[JEditorPaneのHTMLEditorKitにCSSを適用](https://ateraimemo.com/Swing/StyleSheet.html)なども使えるかもしれません。 -- *aterai* 2009-10-16 (金) 13:05:35
    - [JTextPaneで検索結果のハイライト表示と文字色変更を同時に行う](https://ateraimemo.com/Swing/HighlightTextForeground.html)にサンプルソースコードを移動。 -- *aterai* 2014-11-10 (月) 00:05:55
- わかりました。ほんとにありがとうございました。 -- *Caokai* 2009-10-16 (Fri) 16:42:07

<!-- dummy comment line for breaking list -->
