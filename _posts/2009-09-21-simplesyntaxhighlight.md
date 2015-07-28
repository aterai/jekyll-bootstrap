---
layout: post
category: swing
folder: SimpleSyntaxHighlight
title: JTextPaneでキーワードのSyntaxHighlight
tags: [JTextPane, StyledDocument, Element, Highlight]
author: aterai
pubdate: 2009-09-21T02:07:00+09:00
description: JTextPaneでキーワードのSyntax Highlightを行います。
comments: true
---
## 概要
`JTextPane`でキーワードの`Syntax Highlight`を行います。このサンプルは、[Fast styled JTextPane editor | Oracle Community](https://community.oracle.com/thread/2105230)などのサンプルコードからキーワードのハイライト部分を参考にして作成しています。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTAw3RBeI/AAAAAAAAAjs/LtUs6l9UpZo/s800/SimpleSyntaxHighlight.png %}

## サンプルコード
<pre class="prettyprint"><code>//This code is taken from: SyntaxDocument.java, MultiSyntaxDocument.java
// Fast styled JTextPane editor | Oracle Community
// @author camickr
// @author David Underhill
// https://community.oracle.com/thread/2105230
// modified by aterai aterai@outlook.com
class SimpleSyntaxDocument extends DefaultStyledDocument {
  //HashMap&lt;String, AttributeSet&gt; keywords = new HashMap&lt;&gt;();
  private final Style normal;
  private static final String OPERANDS = ".,";
  public SimpleSyntaxDocument() {
    super();
    Style def = StyleContext.getDefaultStyleContext().getStyle(
        StyleContext.DEFAULT_STYLE);
    normal = addStyle("normal", def);
    StyleConstants.setForeground(normal, Color.BLACK);
    StyleConstants.setForeground(addStyle("red",   normal), Color.RED);
    StyleConstants.setForeground(addStyle("green", normal), Color.GREEN);
    StyleConstants.setForeground(addStyle("blue",  normal), Color.BLUE);
  }
  @Override public void insertString(int offset, String str, AttributeSet a)
        throws BadLocationException {
    super.insertString(offset, str, a);
    processChangedLines(offset, str.length());
  }
  @Override public void remove(int offset, int length)
        throws BadLocationException {
    super.remove(offset, length);
    processChangedLines(offset, 0);
  }
  private void processChangedLines(int offset, int length)
        throws BadLocationException {
    Element root = getDefaultRootElement();
    int startLine = root.getElementIndex(offset);
    int endLine = root.getElementIndex(offset + length);
    for (int line = startLine; line &lt;= endLine; line++) {
      applyHighlighting(line);
    }
  }
  private void applyHighlighting(int line) throws BadLocationException {
    Element root = getDefaultRootElement();
    int startOffset   = root.getElement(line).getStartOffset();
    int endOffset     = root.getElement(line).getEndOffset() - 1;
    int lineLength    = endOffset - startOffset;
    int contentLength = getLength();
    if (endOffset &gt;= contentLength) {
      endOffset = contentLength - 1;
    }
    setCharacterAttributes(startOffset, lineLength, normal, true);
    checkForTokens(startOffset, endOffset);
  }
  private void checkForTokens(int startOffset, int endOffset)
        throws BadLocationException {
    int index = startOffset;
    while (index &lt;= endOffset) {
      while (isDelimiter(getText(index, 1))) {
        if (index &lt; endOffset) {
          index++;
        } else {
          return;
        }
      }
      index = getOtherToken(index, endOffset);
    }
  }
  private int getOtherToken(int startOffset, int endOffset)
        throws BadLocationException {
    int endOfToken = startOffset + 1;
    while (endOfToken &lt;= endOffset) {
      if (isDelimiter(getText(endOfToken, 1))) {
        break;
      }
      endOfToken++;
    }
    String token = getText(startOffset, endOfToken - startOffset);
    Style s = getStyle(token);
    if (s != null) {
      setCharacterAttributes(startOffset, endOfToken - startOffset, s, false);
    }
    return endOfToken + 1;
  }
  protected boolean isDelimiter(String character) {
    return Character.isWhitespace(
        character.charAt(0)) || OPERANDS.indexOf(character) != -1;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`red`, `green`, `blue`といったキーワードを入力すると、その色で文字列をハイライトするようになっています。区切り文字は、空白、`.`(ドット)、`,`(カンマ)の`3`つです。

`Java`のシンタックスハイライトを行うサンプルコード(参考リンクの`SyntaxDocument.java`など)からキーワードのハイライト部分を抜き出して作成しています。

## 参考リンク
- [Fast styled JTextPane editor | Oracle Community](https://community.oracle.com/thread/2105230)
    - ~~オリジナルの作者、ライセンス、参照元のページが何処だったかなどが不明…~~
    - [Java Code Example for](http://www.programcreek.com/java-api-examples/index.php?example_code_path=weka-weka.gui.scripting-SyntaxDocument.java)によると、元は[Fast styled JTextPane editor | Oracle Community](https://community.oracle.com/thread/2105230)の投稿で、作者は camickr さん、David Underhill さん。そう言われるとなんとなくそんな記憶があるような…、あのフォーラムはもういろいろ変更されすぎててどうにも…
- [Customizing a Text Editor](http://web.archive.org/web/20120802021725/http://java.sun.com/products/jfc/tsc/articles/text/editor_kit/index.html)
- [Text Editor Tutorial](http://ostermiller.org/syntax/editor.html)

<!-- dummy comment line for breaking list -->

## コメント
