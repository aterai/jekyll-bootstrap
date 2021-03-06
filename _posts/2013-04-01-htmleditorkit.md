---
layout: post
category: swing
folder: HTMLEditorKit
title: JTextPaneで修飾したテキストをJTextAreaにHtmlソースとして表示する
tags: [JTextPane, HTMLEditorKit, Html, JPopupMenu, JTextArea, JTabbedPane, ChangeListener]
author: aterai
pubdate: 2013-04-01T00:08:05+09:00
description: HTMLEditorKitを使用するJTextPaneで修飾したテキストをJTextAreaにHtmlソースとして表示、編集、JTextPaneに反映するテストを行なっています。
image: https://lh6.googleusercontent.com/-ORS7lITRAUE/UVhL_1G6hPI/AAAAAAAABo4/5WKtBFFthJ0/s800/HTMLEditorKit.png
comments: true
---
## 概要
`HTMLEditorKit`を使用する`JTextPane`で修飾したテキストを`JTextArea`に`Html`ソースとして表示、編集、`JTextPane`に反映するテストを行なっています。

{% download https://lh6.googleusercontent.com/-ORS7lITRAUE/UVhL_1G6hPI/AAAAAAAABo4/5WKtBFFthJ0/s800/HTMLEditorKit.png %}

## サンプルコード
<pre class="prettyprint"><code>textPane.setComponentPopupMenu(new HTMLColorPopupMenu());
// textPane.setEditorKit(new HTMLEditorKit());
textPane.setContentType("text/html");
textArea.setText(textPane.getText());

JTabbedPane tabbedPane = new JTabbedPane();
tabbedPane.addTab("JTextPane", new JScrollPane(textPane));
tabbedPane.addTab("JTextArea", new JScrollPane(textArea));
tabbedPane.addChangeListener(new ChangeListener() {
  @Override public void stateChanged(ChangeEvent e) {
    JTabbedPane t = (JTabbedPane) e.getSource();
    int i = t.getSelectedIndex();
    try {
      if (i == 0) {
        textPane.setText(textArea.getText());
      } else {
        String str = textPane.getText();
        textArea.setText(str);
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    t.revalidate();
  }
});
</code></pre>

## 解説
`HTMLEditorKit`を使用(コンテンツ形式を`text/html`に設定)する`JTextPane`で`JEditorPane#getText()`を実行すると、`HTMLEditorKit`から文字色などの`Style`を設定した`Html`ソースとして文字列を取得可能なので、`JTabbedPane`が`JTextArea`に切り替わるときに`JTextArea`に流し込んでいます。

逆に、`JTextArea`で`Html`ソースを編集して`JTabbedPane`で`JTextPane`に切り替える時には、`JEditorPane#setText(String)`内で`HTMLEditorKit`に`HTML`形式で読み込まれるよう設定しています。

- `textPane.setContentType("text/html");`とコンテンツ形式を設定しておかないと`JEditorPane#setText(String)`で`Document`が更新されない場合がある？
- この場合、以下のように`textPane.setText(textArea.getText());`ではなく`HTMLEditorKit#insertHTML(...)`を使用する
    
    <pre class="prettyprint"><code>// textPane.setText(textArea.getText());
    textPane.setText("");
    HTMLEditorKit hek = (HTMLEditorKit) textPane.getEditorKit();
    HTMLDocument doc = (HTMLDocument) textPane.getStyledDocument();
    hek.insertHTML(doc, 0, textArea.getText(), 0, 0, null);
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `HTMLEditorKit`から`HTML Tag`を取り除いた文字列を取得するサンプル
    - [Removing HTML from a Java String - Stack Overflow](https://stackoverflow.com/questions/240546/removing-html-from-a-java-string)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>// import java.io.StringReader;
// import javax.swing.text.html.parser.*;
ParserDelegator delegator = new ParserDelegator();
final StringBuffer s = new StringBuffer();
delegator.parse(new StringReader(str), new HTMLEditorKit.ParserCallback() {
  @Override public void handleText(char[] text, int pos) {
    s.append(text);
  }
}, Boolean.TRUE);
System.out.println(s.toString());
</code></pre>

## 参考リンク
- [HTMLEditorKit#insertHTML(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/HTMLEditorKit.html#insertHTML-javax.swing.text.html.HTMLDocument-int-java.lang.String-int-int-javax.swing.text.html.HTML.Tag-)

<!-- dummy comment line for breaking list -->

## コメント
