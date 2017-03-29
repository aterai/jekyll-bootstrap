---
layout: post
category: swing
folder: GhostText
title: JTextFieldにフォーカスと文字列が無い場合の表示
tags: [JTextField, Focus, FocusListener]
author: aterai
pubdate: 2005-11-07T16:50:50+09:00
description: JTextFieldにフォーカスが無く文字列が空の場合、薄い色でその説明を表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNY3BG1nI/AAAAAAAAAas/YJB5L9kNK-c/s800/GhostText.png
comments: true
---
## 概要
`JTextField`にフォーカスが無く文字列が空の場合、薄い色でその説明を表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNY3BG1nI/AAAAAAAAAas/YJB5L9kNK-c/s800/GhostText.png %}

## サンプルコード
<pre class="prettyprint"><code>class PlaceholderFocusListener implements FocusListener {
  private static final Color INACTIVE
    = UIManager.getColor("TextField.inactiveForeground");
  private final String hintMessage;
  public PlaceholderFocusListener(JTextComponent tf) {
    hintMessage = tf.getText();
    tf.setForeground(INACTIVE);
  }
  @Override public void focusGained(FocusEvent e) {
    JTextComponent tf = (JTextComponent) e.getComponent();
    if (hintMessage.equals(tf.getText())
        &amp;&amp; INACTIVE.equals(tf.getForeground())) {
      tf.setForeground(UIManager.getColor("TextField.foreground"));
      tf.setText("");
    }
  }
  @Override public void focusLost(FocusEvent e) {
    JTextComponent tf = (JTextComponent) e.getComponent();
    if ("".equals(tf.getText().trim())) {
      tf.setForeground(INACTIVE);
      tf.setText(hintMessage);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、下の`JTextField`からフォーカスが失われた時、まだ何も入力されていない場合は、その`JTextField`の説明などを透かし文字として薄く表示することができます。

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

## 参考リンク
- [JTextFieldに透かし画像を表示する](http://ateraimemo.com/Swing/WatermarkInTextField.html)
- [JPasswordFieldにヒント文字列を描画する](http://ateraimemo.com/Swing/InputHintPasswordField.html)
    - `JPasswordField`の場合、`setText(String)`は使用できないので、透かし画像と同じ要領で`paintComponent`をオーバーライドして文字列を描画

<!-- dummy comment line for breaking list -->

## コメント
- タイトルを変更?: `Input Hint`、`Placeholder`、`Watermark` ... -- *aterai* 2009-11-17 (火) 15:48:18
- `LayerUI#paint(...)`中で、子コンポーネントの`repaint()`を呼び出して再描画が無限ループしていたバグを修正。 -- *aterai* 2014-07-26 (土) 04:51:11

<!-- dummy comment line for breaking list -->
