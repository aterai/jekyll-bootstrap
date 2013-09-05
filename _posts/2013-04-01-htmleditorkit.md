---
layout: post
title: JTextPaneで修飾したテキストをJTextAreaにHtmlソースとして表示する
category: swing
folder: HTMLEditorKit
tags: [JTextPane, HTMLEditorKit, Html, JPopupMenu, JTextArea, JTabbedPane, ChangeListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-04-01

## JTextPaneで修飾したテキストをJTextAreaにHtmlソースとして表示する
`HTMLEditorKit`を使用する`JTextPane`で修飾したテキストを`JTextArea`に`Html`ソースとして表示、編集、`JTextPane`に反映するテストを行なっています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-ORS7lITRAUE/UVhL_1G6hPI/AAAAAAAABo4/5WKtBFFthJ0/s800/HTMLEditorKit.png)

### サンプルコード
<pre class="prettyprint"><code>textPane.setComponentPopupMenu(new HTMLColorPopupMenu());
//textPane.setEditorKit(new HTMLEditorKit());
textPane.setContentType("text/html");
textArea.setText(textPane.getText());

JTabbedPane tabbedPane = new JTabbedPane();
tabbedPane.addTab("JTextPane", new JScrollPane(textPane));
tabbedPane.addTab("JTextArea", new JScrollPane(textArea));
tabbedPane.addChangeListener(new ChangeListener() {
  @Override public void stateChanged(ChangeEvent e) {
    JTabbedPane t = (JTabbedPane)e.getSource();
    int i = t.getSelectedIndex();
    try{
      if(i==0) {
        textPane.setText(textArea.getText());
      }else{
        String str = textPane.getText();
        textArea.setText(str);
      }
    }catch(Exception ex) {
      ex.printStackTrace();
    }
    t.revalidate();
  }
});
</code></pre>

### 解説
`HTMLEditorKit`を使用(コンテンツ形式を"text/html"に設定)する`JTextPane`で`JEditorPane#getText()`を実行すると、`HTMLEditorKit`からスタイル(文字色)などを設定した`Html`ソースとして文字列を取得することができるので、これを`JTabbedPane`が`JTextArea`に切り替わるときに`JTextArea`に流しこんでいます。

逆に、`JTextArea`で`Html`ソースを編集し、`JTabbedPane`で`JTextPane`に切り替える時には、`JEditorPane#setText(String)`内で、`HTMLEditorKit`に`HTML`形式で読み込まれるようになっています。

- メモ
    - `textPane.setContentType("text/html");`とコンテンツ形式を設定しておかないと、`JEditorPane#setText(String)`で`Document`が更新されない場合がある？
    - この場合、以下のように、`textPane.setText(textArea.getText());`ではなく、`HTMLEditorKit#insertHTML(...)`を使用する

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//textPane.setText(textArea.getText());
textPane.setText("");
HTMLEditorKit hek = (HTMLEditorKit)textPane.getEditorKit();
HTMLDocument doc = (HTMLDocument)textPane.getStyledDocument();
hek.insertHTML(doc, 0, textArea.getText(), 0, 0, null);
</code></pre>

- - - -
- `HTMLEditorKit`から、`HTML Tag`を取り除いた文字列を取得するサンプル
    - [Removing HTML from a Java String - Stack Overflow](http://stackoverflow.com/questions/240546/removing-html-from-a-java-string)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//import java.io.StringReader;
//import javax.swing.text.html.parser.*;
ParserDelegator delegator = new ParserDelegator();
final StringBuffer s = new StringBuffer();
delegator.parse(new StringReader(str), new HTMLEditorKit.ParserCallback() {
  @Override public void handleText(char[] text, int pos) {
    s.append(text);
  }
}, Boolean.TRUE);
System.out.println(s.toString());
</code></pre>

### コメント