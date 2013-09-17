---
layout: post
title: JTextFieldにフォーカスと文字列が無い場合の表示
category: swing
folder: GhostText
tags: [JTextField, Focus, FocusListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-11-07

## JTextFieldにフォーカスと文字列が無い場合の表示
`JTextField`にフォーカスが無く文字列が空の場合、薄い色でその説明を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNY3BG1nI/AAAAAAAAAas/YJB5L9kNK-c/s800/GhostText.png)

### サンプルコード
<pre class="prettyprint"><code>class HintTextFocusListener implements FocusListener {
  Color INACTIVE_COLOR = UIManager.getColor("TextField.inactiveForeground");
  Color ORIGINAL_COLOR = UIManager.getColor("TextField.foreground");
  private final String hintMessage;
  public HintTextFocusListener(final JTextComponent tf) {
    hintMessage = tf.getText();
    tf.setForeground(INACTIVE_COLOR);
  }
  public void focusGained(final FocusEvent e) {
    JTextComponent textField = (JTextComponent)e.getSource();
    String str = textField.getText();
    Color col  = textField.getForeground();
    if(hintMessage.equals(str) &amp;&amp; INACTIVE_COLOR.equals(col)) {
      textField.setForeground(ORIGINAL_COLOR);
      textField.setText("");
    }
  }
  public void focusLost(final FocusEvent e) {
    JTextComponent textField = (JTextComponent)e.getSource();
    String str = textField.getText().trim();
    if("".equals(str)) {
      textField.setForeground(INACTIVE_COLOR);
      textField.setText(hintMessage);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、下の`JTextField`からフォーカスが失われた時、まだ何も入力されていない場合は、その`JTextField`の説明などを薄く表示することができるようにしています。

### 参考リンク
- [JTextFieldに透かし画像を表示する](http://terai.xrea.jp/Swing/WatermarkInTextField.html)
- [JPasswordFieldにヒント文字列を描画する](http://terai.xrea.jp/Swing/InputHintPasswordField.html)
    - `JPasswordField`の場合は、`setText`などが使えないので、透かし画像と同じ要領で`paintComponent`をオーバーライドして文字列を描画する方法を使います。

<!-- dummy comment line for breaking list -->

### コメント
- タイトルを変更?: `Input Hint`、`Placeholder`、`Watermark` ... -- [aterai](http://terai.xrea.jp/aterai.html) 2009-11-17 (火) 15:48:18

<!-- dummy comment line for breaking list -->

