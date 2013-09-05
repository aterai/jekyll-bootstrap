---
layout: post
title: JTextPaneを一行に制限してスタイル可能なJTextFieldとして使用する
category: swing
folder: OneLineTextPane
tags: [JTextPane, StyledDocument, JScrollPane, JTextField, KeyboardFocusManager, Focus, InputMap]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-05-06

## JTextPaneを一行に制限してスタイル可能なJTextFieldとして使用する
`JTextPane`の行数を一行のみに制限して、文字色などのスタイル付けが可能な`JTextField`として使用します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-jckifA3Ym6c/UYZlsvWPTqI/AAAAAAAABrY/ERGHE6rtaPo/s800/OneLineTextPane.png)

### サンプルコード
<pre class="prettyprint"><code>JTextPane textPane = new JTextPane() {
  @Override public void scrollRectToVisible(Rectangle rect) {
    int r = getBorder().getBorderInsets(this).right;
    rect.grow(r, 0);
    super.scrollRectToVisible(rect);
  }
};
textPane.setEditorKit(new NoWrapEditorKit());
AbstractDocument doc = new SimpleSyntaxDocument();
textPane.setDocument(doc);
try {
  doc.insertString(0, text, null);
} catch(Exception ex) {
  ex.printStackTrace();
}
InputMap im = textPane.getInputMap(JComponent.WHEN_FOCUSED);
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0), new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    // Do nothing
  }
});
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_TAB, 0), new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    // Do nothing
  }
});

// @see http://terai.xrea.jp/Swing/FocusTraversalKeys.html
Set&lt;AWTKeyStroke&gt; forwardKeys = new HashSet&lt;AWTKeyStroke&gt;(
    textPane.getFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS));
forwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_TAB, 0));
forwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_TAB, KeyEvent.SHIFT_MASK));
textPane.setFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS, forwardKeys);

JScrollPane scrollPane = new JScrollPane(
    textPane, ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER,
              ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER) {
  @Override public Dimension getMinimumSize() {
    return super.getPreferredSize();
  }
};
</code></pre>

### 解説
- `JScrollPane`に追加
    - `JScrollBar`を常に非表示にした、`JScrollPane`に`JTextPane`を追加
- JTextPaneの折り返しを無効化
    - [JEditorPaneで長い行を折り返さない](http://terai.xrea.jp/Swing/NoWrapTextPane.html)の`ParagraphView`を使用して、折り返しを無効化
- 文字列の最後にある`Caret`が表示されないのを修正
    - `JTextPane#scrollRectToVisible(Rectangle)`をオーバーライドして、余白までスクロールするように設定
    - メモ: [No Wrap Text Pane ≪ Java Tips Weblog](http://tips4java.wordpress.com/2009/01/25/no-wrap-text-pane/)のように、`CaretListener`を使用する方法もある
- <kbd>Enter</kbd>キーの無効化
    - `JTextPane`から`InputMap`を取得して、`KeyEvent.VK_ENTER`をなにもしない`Action`で置き換える
    - `Document#insertString(...)`をオーバーライドして、コピー・ペーストなどで張り込まれた文字列から、改行を空白に置換
- <kbd>Tab</kbd>キーでフォーカス移動
    - [FocusTraversalKeysに矢印キーを追加してフォーカス移動](http://terai.xrea.jp/Swing/FocusTraversalKeys.html)
    - `JTextPane`から`InputMap`を取得して、`KeyEvent.VK_TAB`をなにもしない`Action`で置き換え、`JTextPane#setFocusTraversalKeys(...)`で、<kbd>Tab</kbd>キーでフォーカス移動するように設定
- 文字スタイルの変更
    - [JTextPaneでキーワードのSyntaxHighlight](http://terai.xrea.jp/Swing/SimpleSyntaxHighlight.html)
    - [SyntaxDocument.java](http://www.discoverteenergy.com/files/SyntaxDocument.java)を使って、入力された`red`, `green`, `blue`の文字色を変更

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JEditorPaneで長い行を折り返さない](http://terai.xrea.jp/Swing/NoWrapTextPane.html)
- [FocusTraversalKeysに矢印キーを追加してフォーカス移動](http://terai.xrea.jp/Swing/FocusTraversalKeys.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JTextField`では、`aaaaa|bbbbb`でカーソル`|`の位置に文字を追加していくと領域外にカーソルが移動した時点で`bbbbb`が表示されるようにスクロールするが、ここの`OneLineTextPane`では未対応。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-05-06 (月) 15:35:00

<!-- dummy comment line for breaking list -->
