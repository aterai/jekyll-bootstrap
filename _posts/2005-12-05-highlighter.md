---
layout: post
title: Highlighterで文字列をハイライト
category: swing
folder: Highlighter
tags: [JTextComponent, Highlighter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-12-05

## Highlighterで文字列をハイライト
`Highlighter`を使ってテキスト中の文字列を強調表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTN25SyRaI/AAAAAAAAAbc/i3gVEjh-mlQ/s800/Highlighter.png)

### サンプルコード
<pre class="prettyprint"><code>public void setHighlight(JTextComponent jtc, String pattern) {
  removeHighlights(jtc);
  try{
    Highlighter hilite = jtc.getHighlighter();
    Document doc = jtc.getDocument();
    String text = doc.getText(0, doc.getLength());
    int pos = 0;
    while((pos = text.indexOf(pattern, pos)) &gt;= 0) {
      hilite.addHighlight(pos, pos+pattern.length(), highlightPainter);
      pos += pattern.length();
    }
  }catch(BadLocationException e) {}
}
</code></pre>

### 解説
テキストコンポーネントから`Highlighter`を取得し、`Highlighter#addHighlight`メソッドで検索した文字列を追加していきます。

上記のサンプルでは、ハイライト色を`DefaultHighlighter.DefaultHighlightPainter`を使って指定しています。

### 参考リンク
- [Swing - Searching text in files & highlighting that text](https://forums.oracle.com/thread/1387954)

<!-- dummy comment line for breaking list -->

### コメント
- こんにちは。はじめまして。Keithと言います。このプログラムだと、テキスト中の複数の異なる文字に、それぞれハイライトを割り当てることが出来ないのですが、解決策はあるでしょうか。 -- [Keith](http://terai.xrea.jp/Keith.html) 2007-11-28 (水) 19:12:19
    - こんばんは。`Highlighter#addHighlight`メソッドは、複数のハイライトを追加できるので、パターン毎に色を変えたいだけなら(効率とか、同じ文字列が含まれる場合とか、エラー処理などの面倒なことは考えない)、以下のようにパターンを配列にして繰り返すだけでもいいかもしれません。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-11-28 (水) 20:25:31

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private final Highlighter.HighlightPainter[] highlightPainter = {
  new DefaultHighlighter.DefaultHighlightPainter(Color.YELLOW),
  new DefaultHighlighter.DefaultHighlightPainter(Color.CYAN)
};
private final String[] pattern = {"Swing", "win"};
public void setHighlight(JTextComponent jtc, String[] pattern) {
  removeHighlights(jtc);
  try{
    Highlighter hilite = jtc.getHighlighter();
    Document doc = jtc.getDocument();
    String text = doc.getText(0, doc.getLength());
    for(int i=0;i&lt;pattern.length;i++) {
      int pos = 0;
      while((pos = text.indexOf(pattern[i], pos)) &gt;= 0) {
        hilite.addHighlight(pos, pos+pattern[i].length(), highlightPainter[i]);
        pos += pattern[i].length();
      }
    }
  }catch(BadLocationException e) { e.printStackTrace(); }
}
</code></pre>

- こんな簡単にハイライトできるとは！。正規表現で実装すると開始位置と終了位置がより簡単で、しかも複雑にできるかも。 -- [eternalharvest](http://terai.xrea.jp/eternalharvest.html) 2008-08-28 (木) 02:20:11
    - ちょっと夏休みで帰省してました。正規表現 > そうですね。基本的には同じような要領で大丈夫だと思います。メモ:[Swing - Content-Overlay in JTextPane](https://forums.oracle.com/thread/1382907)、追記: [DefaultHighlighterの描画方法を変更する](http://terai.xrea.jp/Swing/DrawsLayeredHighlights.html)に、`Matcher matcher = Pattern.compile(pattern).matcher(text);`と正規表現でハイライトするサンプルを追加。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-09-01 (月) 13:47:05
- こんにちは。Cakaiと申します。ハイライトされているテキストのカラーを設定することがありますか？ -- [Caokai](http://terai.xrea.jp/Caokai.html) 2009-10-15 (Thu) 23:12:47
    - こんにちは。はじめまして。`Highlighter.HighlightPainter`で、文字色は変更できないかもしれません。以下のように`AttributeSet`を使うのはどうでしょう。[JTextPaneでキーワードのSyntaxHighlight](http://terai.xrea.jp/Swing/SimpleSyntaxHighlight.html) -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-16 (金) 13:04:32
        - 用途によっては、[JEditorPaneのHTMLEditorKitにCSSを適用](http://terai.xrea.jp/Swing/StyleSheet.html)なども使えるかもしれません。

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import javax.swing.*;
import javax.swing.text.*;
public class HighlightTest{
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() { createAndShowGUI(); }
    });
  }
  private static void addHighlightTest(JTextComponent textarea,
                     String pattern,
                     Highlighter.HighlightPainter painter) {
    String text = textarea.getText();
    try {
      int pos = 0;
      while ((pos = text.indexOf(pattern, pos)) &gt;= 0) {
        textarea.getHighlighter().addHighlight(
          pos, pos+pattern.length(), painter);
        pos += pattern.length();
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
  private static JTextArea makeTestTextArea() {
    JTextArea textArea = new JTextArea();
    textArea.setText("JTextArea\nRed and Blue");
    addHighlightTest(textArea, "Red",
      new DefaultHighlighter.DefaultHighlightPainter(Color.RED));
    addHighlightTest(textArea, "Blue",
      new DefaultHighlighter.DefaultHighlightPainter(Color.BLUE));
    return textArea;
  }
  private static void addStyleTest(JTextPane textPane, String pattern) {
    String text = textPane.getText();
    StyledDocument doc = textPane.getStyledDocument();
    Style s = doc.getStyle(pattern.toLowerCase());
    try{
        int pos = 0;
        while ((pos = text.indexOf(pattern, pos)) &gt;= 0) {
            doc.setCharacterAttributes(pos, pattern.length(), s, false);
            pos += pattern.length();
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
  }
  private static JTextPane makeTestTextPane() {
    JTextPane textPane = new JTextPane();
    textPane.setText("JTextPane\nRed and Blue");

    StyledDocument doc = textPane.getStyledDocument();
    Style def = StyleContext.getDefaultStyleContext().getStyle(
        StyleContext.DEFAULT_STYLE);
    Style regular = doc.addStyle("regular", def);

    Style red = doc.addStyle("red", regular);
    StyleConstants.setForeground(red, Color.RED);
    Style blue = doc.addStyle("blue", regular);
    StyleConstants.setForeground(blue, Color.BLUE);
    addStyleTest(textPane, "Red");
    addStyleTest(textPane, "Blue");
    return textPane;
  }
  public static void createAndShowGUI() {
    JPanel p = new JPanel(new GridLayout(2,1));
    p.add(new JScrollPane(makeTestTextArea()));
    p.add(new JScrollPane(makeTestTextPane()));
    JFrame frame = new JFrame();
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(p);
    frame.setSize(320, 240);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}
</code></pre>
- わかりました。ほんとにありがとうございました。 -- [Caokai](http://terai.xrea.jp/Caokai.html) 2009-10-16 (Fri) 16:42:07

<!-- dummy comment line for breaking list -->

