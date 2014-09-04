---
layout: post
title: JTextFieldに透かし画像を表示する
category: swing
folder: WatermarkInTextField
tags: [JTextField, Focus, ImageIcon]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-10-26

## 概要
`JTextField`の文字列が空でフォーカスがない場合、透かし画像を表示するように設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWh1Qjh4I/AAAAAAAAApY/bLarzjLy7-8/s800/WatermarkInTextField.png %}

## サンプルコード
<pre class="prettyprint"><code>class WatermarkTextField extends JTextField implements FocusListener {
  private final ImageIcon image;
  private boolean showWatermark = true;
  public WatermarkTextField() {
    super();
    image = new ImageIcon(getClass().getResource("watermark.png"));
    addFocusListener(this);
  }
  @Override public void paintComponent(Graphics g) {
    super.paintComponent(g);
    if(showWatermark) {
      Graphics2D g2d = (Graphics2D)g;
      //Insets i = getMargin();
      Insets i = getInsets();
      int yy = (getHeight()-image.getIconHeight())/2;
      g2d.drawImage(image.getImage(), i.left, yy, this);
    }
  }
  @Override public void focusGained(FocusEvent e) {
    showWatermark = false;
    repaint();
  }
  @Override public void focusLost(FocusEvent e) {
    showWatermark = "".equals(getText().trim());
    repaint();
  }
}
</code></pre>

## 解説
- 上
    - [JTextFieldにフォーカスと文字列が無い場合の表示](http://terai.xrea.jp/Swing/GhostText.html)
- 下
    - `JTextField`の文字列が空で、フォーカスも無い場合、上記のように文字列ではなく、画像を表示します。

<!-- dummy comment line for breaking list -->

- - - -
[JTextFieldにフォーカスと文字列が無い場合の表示](http://terai.xrea.jp/Swing/GhostText.html)では、`JPasswordField`に応用できないので、以下のように透かし画像の表示と同じような方法で文字列を表示します。

- [JPasswordFieldにヒント文字列を描画する](http://terai.xrea.jp/Swing/InputHintPasswordField.html) に移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextFieldにフォーカスと文字列が無い場合の表示](http://terai.xrea.jp/Swing/GhostText.html)
- [JPasswordFieldにヒント文字列を描画する](http://terai.xrea.jp/Swing/InputHintPasswordField.html)

<!-- dummy comment line for breaking list -->

## コメント

