---
layout: post
title: JTextPaneでキーワードのSyntaxHighlight
category: swing
folder: SimpleSyntaxHighlight
tags: [JTextPane, StyledDocument, Element, Highlight]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-09-21

## JTextPaneでキーワードのSyntaxHighlight
`JTextPane`で`Syntax Highlight`を行います。このサンプルは、[SyntaxDocument.java](http://www.discoverteenergy.com/Files/SyntaxDocument.java)からキーワードのハイライト部分を抜き出して作成しています。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTAw3RBeI/AAAAAAAAAjs/LtUs6l9UpZo/s800/SimpleSyntaxHighlight.png %}

### サンプルコード
<pre class="prettyprint"><code>//This code is taken from:
//http://www.discoverteenergy.com/Files/SyntaxDocument.java SyntaxDocument.java
class SimpleSyntaxDocument extends DefaultStyledDocument {
  HashMap&lt;String,AttributeSet&gt; keywords = new HashMap&lt;&gt;();
  MutableAttributeSet normal = new SimpleAttributeSet();
  public SimpleSyntaxDocument() {
    super();
    StyleConstants.setForeground(normal, Color.BLACK);
    MutableAttributeSet color;
    StyleConstants.setForeground(color = new SimpleAttributeSet(), Color.RED);
    keywords.put("red", color);
    StyleConstants.setForeground(color = new SimpleAttributeSet(), Color.GREEN);
    keywords.put("green", color);
    StyleConstants.setForeground(color = new SimpleAttributeSet(), Color.BLUE);
    keywords.put("blue", color);
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
    Element root   = getDefaultRootElement();
    String content = getText(0, getLength());
    int startLine  = root.getElementIndex( offset );
    int endLine    = root.getElementIndex( offset + length );
    for (int i = startLine; i &lt;= endLine; i++) {
      applyHighlighting(content, i);
    }
  }
  private void applyHighlighting(String content, int line)
                                               throws BadLocationException {
    Element root = getDefaultRootElement();
    int startOffset   = root.getElement( line ).getStartOffset();
    int endOffset   = root.getElement( line ).getEndOffset() - 1;
    int lineLength  = endOffset - startOffset;
    int contentLength = content.length();
    if (endOffset &gt;= contentLength) endOffset = contentLength - 1;
    setCharacterAttributes(startOffset, lineLength, normal, true);
    checkForTokens(content, startOffset, endOffset);
  }
  private void checkForTokens(String content, int startOffset, int endOffset) {
    while (startOffset &lt;= endOffset) {
      while (isDelimiter(content.substring(startOffset, startOffset+1))) {
        if (startOffset &lt; endOffset) {
          startOffset++;
        } else {
          return;
        }
      }
      startOffset = getOtherToken(content, startOffset, endOffset);
    }
  }
  private int getOtherToken(String content, int startOffset, int endOffset) {
    int endOfToken = startOffset + 1;
    while ( endOfToken &lt;= endOffset ) {
      if ( isDelimiter( content.substring(endOfToken, endOfToken + 1) ) ) {
        break;
      }
      endOfToken++;
    }
    String token = content.substring(startOffset, endOfToken);
    if ( keywords.containsKey( token ) ) {
      setCharacterAttributes(
        startOffset, endOfToken - startOffset, keywords.get(token), false);
    }
    return endOfToken + 1;
  }
  String operands = ".,";
  protected boolean isDelimiter(String character) {
    return Character.isWhitespace(character.charAt(0)) ||
           operands.indexOf(character)!=-1;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`red`, `green`, `blue`といったキーワードを入力すると、その色で文字列をハイライトするようになっています。区切り文字は、空白、`.`(ドット)、`,`(カンマ)の`3`つです。

`Java`のシンタックスハイライトを行うサンプルコード([SyntaxDocument.java](http://www.discoverteenergy.com/Files/SyntaxDocument.java))からキーワードのハイライト部分を抜き出して作成しています。

### 参考リンク
- [SyntaxDocument.java](http://www.discoverteenergy.com/Files/SyntaxDocument.java)
    - 作者、ライセンス、参照元のページが何処だったかなどが不明…。
- [Customizing a Text Editor](http://web.archive.org/web/20120802021725/http://java.sun.com/products/jfc/tsc/articles/text/editor_kit/index.html)
- [Text Editor Tutorial](http://ostermiller.org/syntax/editor.html)

<!-- dummy comment line for breaking list -->

### コメント
