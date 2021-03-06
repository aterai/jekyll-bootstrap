---
layout: post
category: swing
folder: SliderFocusBorder
title: JSliderのFocusBorderを非表示に設定する
tags: [JSlider, Focus, Border, WindowsLookAndFeel]
author: aterai
pubdate: 2017-11-27T15:20:49+09:00
description: WindowsLookAndFeelを使用するJSliderで、点線のFocusBorderを非表示に設定します。
image: https://drive.google.com/uc?id=1zvmXqQPcE3P84DbjDk0vFmBympd7es24Gw
comments: true
---
## 概要
`WindowsLookAndFeel`を使用する`JSlider`で、点線の`FocusBorder`を非表示に設定します。

{% download https://drive.google.com/uc?id=1zvmXqQPcE3P84DbjDk0vFmBympd7es24Gw %}

## サンプルコード
<pre class="prettyprint"><code>JSlider slider2 = new JSlider(0, 100, 0) {
  private transient FocusListener listener;
  @Override public void updateUI() {
    removeFocusListener(listener);
    super.updateUI();
    if (getUI() instanceof WindowsSliderUI) {
      setUI(new WindowsSliderUI(this) {
        @Override public void paintFocus(Graphics g) {}
      });
      Color bgc = getBackground();
      listener = new FocusListener() {
        @Override public void focusGained(FocusEvent e) {
          setBackground(bgc.brighter());
        }
        @Override public void focusLost(FocusEvent e) {
          setBackground(bgc);
        }
      };
      addFocusListener(listener);
    }
  }
};
</code></pre>

## 解説
- `Default`
    - `JSlider`にフォーカスが移動すると、`WindowsLookAndFeel`のデフォルトでは目盛りなどを含む領域に黒色で点線の`FocusBorder`が描画される
        - `MotifLookAndFeel`の場合は、赤色の実線
        - `MetalLookAndFeel`、`NimbusLookAndFeel`の場合は、`Thumb`の描画が変化する
- `Override SliderUI#paintFocus(...)`
    - `BasicSliderUI#paintFocus(...)`をオーバーライドして`FocusBorder`を非表示に設定
    - `UIManager.put("Slider.focus", UIManager.get("Slider.background"));`として`FocusBorder`の色を背景色と同じにしてすべての`JSlider`の`FocusBorder`を非表示にする方法もある
    - 点線を非表示にする代わりに`FocusListener`を追加してフォーカスがある場合は背景色を変更
        - `WindowsLookAndFeel`で`MetalLookAndFeel`などのようにフォーカスありで`Thumb`の描画を変更するのはすこし面倒

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - How to remove the Border of jSlider - Stack Overflow](https://stackoverflow.com/questions/20285522/how-to-remove-the-border-of-jslider)

<!-- dummy comment line for breaking list -->

## コメント
