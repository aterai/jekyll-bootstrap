---
layout: post
category: swing
folder: TriangleTickSlider
title: JSliderの目盛りをアイコンに変更する
tags: [JSlider, Icon, JLabel]
author: aterai
pubdate: 2010-05-24T15:00:41+09:00
description: JSliderの目盛りに使用するJLabelを取得し、アイコンを追加したり文字色を変更するなどの変更を行います。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWS_t-t1I/AAAAAAAAApA/78UrJyqx8og/s800/TriangleTickSlider.png
comments: true
---
## 概要
`JSlider`の目盛りに使用する`JLabel`を取得し、アイコンを追加したり文字色を変更するなどの変更を行います。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWS_t-t1I/AAAAAAAAApA/78UrJyqx8og/s800/TriangleTickSlider.png %}

## サンプルコード
<pre class="prettyprint"><code>JSlider slider = new JSlider(0, 100);
slider.setMajorTickSpacing(10);
slider.setMinorTickSpacing(5);
slider.setPaintLabels(true);
slider.setSnapToTicks(true);
slider.putClientProperty("Slider.paintThumbArrowShape", Boolean.TRUE);
Dictionary dictionary = slider.getLabelTable();
if (dictionary != null) {
  Enumeration elements = dictionary.elements();
  Icon tick = new TickIcon();
  while (elements.hasMoreElements()) {
    JLabel label = (JLabel) elements.nextElement();
    label.setBorder(BorderFactory.createEmptyBorder(1, 0, 0, 0));
    label.setIcon(tick);
    label.setIconTextGap(0);
    label.setVerticalAlignment(SwingConstants.TOP);
    label.setVerticalTextPosition(SwingConstants.BOTTOM);
    label.setHorizontalAlignment(SwingConstants.CENTER);
    label.setHorizontalTextPosition(SwingConstants.CENTER);
    label.setForeground(Color.RED);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JSlider`のラベル(`JLabel`)一覧を`JSlider#getLabelTable()`メソッドで取得し、この各`JLabel`に三角形のアイコンを追加して目盛り(`MajorTick`)の代替としています。

- 垂直`JSlider`(`JSlider#setOrientation(SwingConstants.VERTICAL)`)には未対応

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSliderのUIや色を変更する](https://ateraimemo.com/Swing/VolumeSlider.html)
- [JSliderの目盛にアイコンや文字列を追加する](https://ateraimemo.com/Swing/SliderLabelTable.html)

<!-- dummy comment line for breaking list -->

## コメント
