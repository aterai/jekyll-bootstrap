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


{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNY3BG1nI/AAAAAAAAAas/YJB5L9kNK-c/s800/GhostText.png %}

### サンプルコード
<pre class="prettyprint"><code>class HintTextFocusListener implements FocusListener {
  Color INACTIVE_COLOR = UIManager.getColor("TextField.inactiveForeground");
  Color ORIGINAL_COLOR = UIManager.getColor("TextField.foreground");
  private final String hintMessage;
  public HintTextFocusListener(final JTextComponent tf) {
    hintMessage = tf.getText();
    tf.setForeground(INACTIVE_COLOR);
  }
  @Override public void focusGained(final FocusEvent e) {
    JTextComponent textField = (JTextComponent)e.getSource();
    String str = textField.getText();
    Color col  = textField.getForeground();
    if(hintMessage.equals(str) &amp;&amp; INACTIVE_COLOR.equals(col)) {
      textField.setForeground(ORIGINAL_COLOR);
      textField.setText("");
    }
  }
  @Override public void focusLost(final FocusEvent e) {
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

- - - -
`JDK 1.7.0`以上の場合は、`JLayer`を使用して同様にヒント文字列を描画することができます。

<pre class="prettyprint"><code>class PlaceholderLayerUI extends LayerUI&lt;JTextComponent&gt; {
  private static final Color INACTIVE = UIManager.getColor("TextField.inactiveForeground");
  private final JLabel hint;
  public PlaceholderLayerUI(String hintMessage) {
    super();
    this.hint = new JLabel(hintMessage);
    hint.setForeground(INACTIVE);
  }
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer) {
      JLayer jlayer = (JLayer) c;
      JTextComponent tc = (JTextComponent) jlayer.getView();
      if (tc.getText().length() == 0 &amp;&amp; !tc.hasFocus()) {
        Graphics2D g2 = (Graphics2D) g.create();
        g2.setPaint(INACTIVE);
        Insets i = tc.getInsets();
        Dimension d = hint.getPreferredSize();
        SwingUtilities.paintComponent(g2, hint, tc, i.left, i.top, d.width, d.height);
        g2.dispose();
      }
    }
  }
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(AWTEvent.FOCUS_EVENT_MASK);
    }
  }
  @Override public void uninstallUI(JComponent c) {
    super.uninstallUI(c);
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(0);
    }
  }
  @Override public void processFocusEvent(FocusEvent e, JLayer&lt;? extends JTextComponent&gt; l) {
    l.getView().repaint();
  }
}
</code></pre>

### 参考リンク
- [JTextFieldに透かし画像を表示する](http://terai.xrea.jp/Swing/WatermarkInTextField.html)
- [JPasswordFieldにヒント文字列を描画する](http://terai.xrea.jp/Swing/InputHintPasswordField.html)
    - `JPasswordField`の場合は、`setText`などが使えないので、透かし画像と同じ要領で`paintComponent`をオーバーライドして文字列を描画する方法を使います。

<!-- dummy comment line for breaking list -->

### コメント
- タイトルを変更?: `Input Hint`、`Placeholder`、`Watermark` ... -- [aterai](http://terai.xrea.jp/aterai.html) 2009-11-17 (火) 15:48:18
- `LayerUI#paint(...)`中で、子コンポーネントの`repaint()`を呼び出して再描画が無限ループしていたバグを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2014-07-26 (土) 04:51:11

<!-- dummy comment line for breaking list -->

