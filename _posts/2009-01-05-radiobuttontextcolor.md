---
layout: post
category: swing
folder: RadioButtonTextColor
title: JRadioButtonの文字色を変更
tags: [JRadioButton, Icon]
author: aterai
pubdate: 2009-01-05T12:42:32+09:00
description: JRadioButtonの状態の変化に応じて、その文字色やアイコンを変更します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRa2rE0nI/AAAAAAAAAhI/A6NX-uUoYjM/s800/RadioButtonTextColor.png
comments: true
---
## 概要
`JRadioButton`の状態の変化に応じて、その文字色やアイコンを変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRa2rE0nI/AAAAAAAAAhI/A6NX-uUoYjM/s800/RadioButtonTextColor.png %}

## サンプルコード
<pre class="prettyprint"><code>class ColorRadioButton extends JRadioButton {
  private static final Color defaultColor  = Color.BLACK;
  private static final Color pressedColor  = Color.GREEN;
  private static final Color selectedColor = Color.RED;
  private static final Color rolloverColor = Color.BLUE;
  private static final int iconSize = 16;
  @Override protected void fireStateChanged() {
    ButtonModel model = getModel();
    if (!model.isEnabled()) {
      setForeground(Color.GRAY);
    } else if (model.isPressed() &amp;&amp; model.isArmed()) {
      setForeground(pressedColor);
    } else if (model.isSelected()) {
      setForeground(selectedColor);
    } else if (isRolloverEnabled() &amp;&amp; model.isRollover()) {
      setForeground(rolloverColor);
    } else {
      setForeground(defaultColor);
    }
    super.fireStateChanged();
  }
//...
</code></pre>

## 解説
上記のサンプルでは、`JRadioButton`が選択やロールオーバーした時の文字色を、マウスリスナーではなく、`fireStateChanged`メソッドをオーバーライドして変更しています。

アイコンは、`setPressedIcon`、`setSelectedIcon`、`setRolloverIcon`メソッドなどが用意されているので、これを使用しています。

- - - -
以下のような、`ChangeListener`を使用する方法もあります。

<pre class="prettyprint"><code>radioButton.addChangeListener(new ChangeListener() {
  @Override public void stateChanged(ChangeEvent e) {
    ButtonModel model = radioButton.getModel();
    if (!model.isEnabled()) {
      radioButton.setForeground(Color.GRAY);
    } else if (model.isPressed() &amp;&amp; model.isArmed()) {
      radioButton.setForeground(pressedColor);
    } else if (model.isSelected()) {
      radioButton.setForeground(selectedColor);
    } else if (isRolloverEnabled() &amp;&amp; model.isRollover()) {
      radioButton.setForeground(rolloverColor);
    } else {
      radioButton.setForeground(defaultColor);
    }
  }
});
</code></pre>

## コメント
- スクリーンショットのタイトルボーダーが入れ替わっていたのを修正。 -- *aterai* 2009-06-03 (水) 21:27:13

<!-- dummy comment line for breaking list -->
