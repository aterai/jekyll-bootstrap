---
layout: post
category: swing
folder: UpdateSliderLabel
title: JSliderの数値テキストラベルを更新する
tags: [JSlider, JLabel]
author: aterai
pubdate: 2015-02-23T00:36:42+09:00
description: JSliderの数値テキストラベルの値を変更した場合、その位置やサイズが正しく描画されるように更新を行うメソッドを実行します。
image: https://lh5.googleusercontent.com/-xP4QgpDpRec/VOn2C7a0GLI/AAAAAAAANxQ/HQ3F4rVgoUI/s800/UpdateSliderLabel.png
comments: true
---
## 概要
`JSlider`の数値テキストラベルの値を変更した場合、その位置やサイズが正しく描画されるように更新を行うメソッドを実行します。

{% download https://lh5.googleusercontent.com/-xP4QgpDpRec/VOn2C7a0GLI/AAAAAAAANxQ/HQ3F4rVgoUI/s800/UpdateSliderLabel.png %}

## サンプルコード
<pre class="prettyprint"><code>JSlider slider = new JSlider(0, 10000);
slider.putClientProperty("Slider.paintThumbArrowShape", Boolean.TRUE);
slider.setMajorTickSpacing(2500);
slider.setMinorTickSpacing(500);
slider.setPaintLabels(true);
slider.setPaintTicks(true);
slider.setSnapToTicks(true);
// slider.setBorder(BorderFactory.createLineBorder(Color.WHITE, 10));
Dictionary&lt;?, ?&gt; labelTable = slider.getLabelTable();
Enumeration&lt;?&gt; ed = labelTable.keys();
while (ed.hasMoreElements()) {
  Integer i = (Integer) ed.nextElement();
  JLabel label = (JLabel) labelTable.get(i);
  label.setText(String.valueOf(i / 100));
}
slider.setLabelTable(labelTable);
</code></pre>

## 解説
- `Default`
    - 最小`0`、最大`10000`で作成した`JSlider`のラベルをその`1/100`で表示
    - 各ラベルの文字数が変更されてもその幅が更新されないので、目盛り中央に数字(文字列)が配置されない
    - `NimbusLookAndFeel`などで最大値の`100`が見切れて`10`までしか表示されない
- `JSlider#updateLabelUIs()`
    - `1/100`に変更後、`JSlider#updateLabelUIs()`を実行してラベルを更新する
    - `JSlider#updateLabelUIs()`は`protected`なので内部でこれを呼び出している`JSlider#setLabelTable(...)`を実行する
    - `JSlider#updateUI()`内でも`JSlider#updateLabelUIs()`を呼び出しているので、代わりに`SwingUtilities.updateComponentTreeUI(slider);`を実行しても可

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - JSlider is drawn incomplete, Working with Netbeans - Stack Overflow](https://stackoverflow.com/questions/28491041/jslider-is-drawn-incomplete-working-with-netbeans)
- [JSlider#updateLabelUIs() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JSlider.html#updateLabelUIs--)

<!-- dummy comment line for breaking list -->

## コメント
