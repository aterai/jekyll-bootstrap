---
layout: post
category: swing
folder: WatermarkInTextField
title: JTextFieldに透かし画像を表示する
tags: [JTextField, Focus, ImageIcon]
author: aterai
pubdate: 2009-10-26T13:04:26+09:00
description: JTextFieldの文字列が空でフォーカスがない場合、透かし画像を表示するように設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWh1Qjh4I/AAAAAAAAApY/bLarzjLy7-8/s800/WatermarkInTextField.png
comments: true
---
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
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    if (showWatermark) {
      Graphics2D g2 = (Graphics2D) g.create();
      //Insets i = getMargin();
      Insets i = getInsets();
      int yy = (getHeight() - image.getIconHeight()) / 2;
      g2.drawImage(image.getImage(), i.left, yy, this);
      g2.dispose();
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
    - [JTextFieldにフォーカスと文字列が無い場合の表示](https://ateraimemo.com/Swing/GhostText.html)
- 下
    - `JTextField`の文字列が空でフォーカスも無い場合、文字列ではなく画像を表示

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextFieldにフォーカスと文字列が無い場合の表示](https://ateraimemo.com/Swing/GhostText.html)
- [JPasswordFieldにヒント文字列を描画する](https://ateraimemo.com/Swing/InputHintPasswordField.html)
    - [JTextFieldにフォーカスと文字列が無い場合の表示](https://ateraimemo.com/Swing/GhostText.html)の方法は`JPasswordField`に応用できないので、`JLabel`を配置することでヒント文字列を表示

<!-- dummy comment line for breaking list -->

## コメント
