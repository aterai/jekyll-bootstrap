---
layout: post
title: JSliderの目盛りをアイコンに変更する
category: swing
folder: TriangleTickSlider
tags: [JSlider, Icon, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-05-24

## JSliderの目盛りをアイコンに変更する
`JSlider`の目盛りをアイコンで描画します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWS_t-t1I/AAAAAAAAApA/78UrJyqx8og/s800/TriangleTickSlider.png)

### サンプルコード
<pre class="prettyprint"><code>JSlider slider = new JSlider(0,100);
slider.setMajorTickSpacing(10);
slider.setMinorTickSpacing(5);
slider.setPaintLabels(true);
slider.setSnapToTicks(true);
Dictionary dictionary = slider.getLabelTable();
if(dictionary != null) {
    Enumeration elements = dictionary.elements();
    Icon tick = new TickIcon();
    while(elements.hasMoreElements()) {
        JLabel label = (JLabel) elements.nextElement();
        label.setBorder(BorderFactory.createEmptyBorder(1,0,0,0));
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

### 解説
上記のサンプルでは、`JSlider`のラベル(`JLabel`)を`JSlider#getLabelTable()`メソッドで取得し、このラベルに三角形のアイコンを追加して、目盛り(`MajorTick`)の代わりとして表示しています。

- 注: `JSlider#setOrientation(SwingConstants.VERTICAL)`には未対応

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JSliderのUIや色を変更する](http://terai.xrea.jp/Swing/VolumeSlider.html)
- [JSliderの目盛にアイコンや文字列を追加する](http://terai.xrea.jp/Swing/SliderLabelTable.html)

<!-- dummy comment line for breaking list -->

### コメント
