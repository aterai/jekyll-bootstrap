---
layout: post
title: JPasswordFieldにヒント文字列を描画する
category: swing
folder: InputHintPasswordField
tags: [JPasswordField, TextLayout, Focus]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-06-04

## JPasswordFieldにヒント文字列を描画する
`JPasswordField`に入力がない場合、ヒント文字列を描画します。

{% download https://lh3.googleusercontent.com/-UKh7dosDsR4/T8xFLnpMGwI/AAAAAAAABNY/nxgzH2XN1vo/s800/InputHintPasswordField.png %}

### サンプルコード
<pre class="prettyprint"><code>class WatermarkPasswordField extends JPasswordField
                             implements FocusListener, DocumentListener {
  private boolean showWatermark = true;
  public WatermarkPasswordField() {
    super();
    addFocusListener(this);
    getDocument().addDocumentListener(this);
  }
  @Override public void paintComponent(Graphics g) {
    super.paintComponent(g);
    if(showWatermark) {
      Graphics2D g2 = (Graphics2D)g.create();
      Insets i = getInsets();
      Font font = getFont();
      FontRenderContext frc = g2.getFontRenderContext();
      TextLayout tl = new TextLayout("Password", font, frc);
      g2.setPaint(hasFocus()?Color.GRAY:Color.BLACK);
      int baseline = getBaseline(getWidth(), getHeight());
      tl.draw(g2, i.left+1, baseline);
      g2.dispose();
    }
  }
  @Override public void focusGained(FocusEvent e) {
    repaint();
  }
  @Override public void focusLost(FocusEvent e) {
    showWatermark = getPassword().length==0;
    repaint();
  }
  @Override public void insertUpdate(DocumentEvent e) {
    showWatermark = e.getDocument().getLength()==0;
    repaint();
  }
  @Override public void removeUpdate(DocumentEvent e) {
    showWatermark = e.getDocument().getLength()==0;
    repaint();
  }
  @Override public void changedUpdate(DocumentEvent e) {}
}
</code></pre>

### 解説
上記のサンプルでは、`JPasswordField#paintComponent(...)`をオーバーライドしてヒント文字列を描画しています。

`paintComponent(...)`メソッドをオーバーライドするのは同じですが、[JTextFieldに透かし画像を表示する](http://terai.xrea.jp/Swing/WatermarkInTextField.html)とは異なり、`JPasswordField`にフォーカスがあっても、まだ入力がない場合(`DocumentListener`を追加)などに、ヒント文字列を非表示にはせず、薄く表示するようにしています(参考: [Text Prompt « Java Tips Weblog](http://tips4java.wordpress.com/2009/11/29/text-prompt/))。

### 参考リンク
- [Text Prompt « Java Tips Weblog](http://tips4java.wordpress.com/2009/11/29/text-prompt/)
    - `JTextComponent`に`BorderLayout`を設定して、文字列やアイコンを設定した`JLabel`を追加し、これを`JLabel#setVisible(boolean)`で切り替えているので、汎用的に使用することができます。

<!-- dummy comment line for breaking list -->

- [JTextFieldにフォーカスと文字列が無い場合の表示](http://terai.xrea.jp/Swing/GhostText.html)
    - `setText()`を使用

<!-- dummy comment line for breaking list -->

- [JTextFieldに透かし画像を表示する](http://terai.xrea.jp/Swing/WatermarkInTextField.html)
    - `paintComponent(...)`メソッドをオーバーライド

<!-- dummy comment line for breaking list -->

### コメント
