---
layout: post
title: JTextFieldを編集不可のJTextPaneに追加する
category: swing
folder: TextFieldOnReadOnlyTextPane
tags: [JTextPane, JTextField, JScrollPane, Focus]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-02-11

## JTextFieldを編集不可のJTextPaneに追加する
`JTextField`を空欄として編集不可にした`JTextPane`に追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-N1aQ1F9Zrn8/UReetdvfWQI/AAAAAAAABdc/9J_2lkAgW0Y/s800/TextFieldOnReadOnlyTextPane.png)

### サンプルコード
<pre class="prettyprint"><code>void insertQuestion(final JTextPane textPane, String str) {
  Document doc = textPane.getDocument();
  try{
    doc.insertString(doc.getLength(), str, null);
    final int pos = doc.getLength();
    System.out.println(pos);
    final JTextField field = new JTextField(4) {
      @Override public Dimension getMaximumSize() {
        return getPreferredSize();
      }
    };
    field.setBorder(BorderFactory.createMatteBorder(0,0,1,0,Color.BLACK));
    field.addFocusListener(new FocusListener() {
      @Override public void focusGained(FocusEvent e) {
        try{
          Rectangle rect = textPane.modelToView(pos);
          rect.grow(0, 4);
          rect.setSize(field.getSize());
          textPane.scrollRectToVisible(rect);
        }catch(BadLocationException ex) {
          ex.printStackTrace();
        }
      }
      @Override public void focusLost(FocusEvent e) {}
    });
    Dimension d = field.getPreferredSize();
    int baseline = field.getBaseline(d.width, d.height);
    field.setAlignmentY(baseline/(float)d.height);

    SimpleAttributeSet a = new SimpleAttributeSet();
    StyleConstants.setLineSpacing(a, 1.5f);
    textPane.setParagraphAttributes(a, true);

    textPane.insertComponent(field);
    doc.insertString(doc.getLength(), "\n", null);
  }catch(BadLocationException e) {
    e.printStackTrace();
  }
}
</code></pre>

### 解説
上記のサンプルでは、編集不可にした`JTextPane`内の文字列中に、編集可能な空欄として`JTextField`を追加(`JTextPane#insertComponent(...)`を使用)しています。

- `JTextPane`
    - 編集不可に設定
    - 行間を`1.5`倍に設定
        - [JEditorPaneやJTextPaneに行間を設定する](http://terai.xrea.jp/Swing/LineSpacing.html)
- `JTextField`
    - `JTextField#getMaximumSize()`をオーバーライドして幅を制限
    - `JTextFieldにMatteBorder`を設定して下線のみ表示
    - `JTextField#setAlignmentY(...)`でベースラインを揃える
        - [JTextPaneに追加するコンポーネントのベースラインを揃える](http://terai.xrea.jp/Swing/InsertComponentBaseline.html)
    - `JTextField`に`FocusListener`を追加し、<kbd>Tab</kbd>キーなどで`Focus`が移動したら、その`JTextField`までスクロールするように設定

<!-- dummy comment line for breaking list -->

### コメント