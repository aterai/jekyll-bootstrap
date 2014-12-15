---
layout: post
category: swing
folder: SliderCurrentLabelColor
title: JSliderの現在値に対応するラベルの文字色を変更する
tags: [JSlider, JLabel]
author: aterai
pubdate: 2014-12-15T00:11:41+09:00
description: JSliderの大目盛りなどに設定した値ラベルが現在値を表すノブにもっとも近い場合、その色を変更します。
comments: true
---
## 概要
`JSlider`の大目盛りなどに設定した値ラベルが現在値を表すノブにもっとも近い場合、その色を変更します。

{% download https://lh3.googleusercontent.com/-QQwUIqqviTE/VI2lBcawp1I/AAAAAAAANtA/VWJPpQJoyyo/s800/SliderCurrentLabelColor.png %}

## サンプルコード
<pre class="prettyprint"><code>slider.getModel().addChangeListener(new ChangeListener() {
  private int prev = -1;
  private void resetForeground(Object o, Color c) {
    if (o instanceof Component) {
      ((Component) o).setForeground(c);
    }
  }
  @Override public void stateChanged(ChangeEvent e) {
    BoundedRangeModel m = (BoundedRangeModel) e.getSource();
    int i = m.getValue();
    if ((slider.getMajorTickSpacing() == 0 ||
         i % slider.getMajorTickSpacing() == 0) &amp;&amp; i != prev) {
      Dictionary dictionary = slider.getLabelTable();
      resetForeground(dictionary.get(i), Color.RED);
      resetForeground(dictionary.get(prev), Color.BLACK);
      slider.repaint();
      prev = i;
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JSlider`の`BoundedRangeModel`に`ChangeListener`を追加し、ノブにもっとも近い値ラベルの文字色をハイライトするように設定しています。

- 上: デフォルト
- 中: `setMajorTickSpacing(10)`
    - 現在値をハイライトするリスナーを追加
    - 現在値が大目盛りになったら(`model.getValue() % slider.getMajorTickSpacing() == 0`)、対応する`JLabel`を`JSlider#getLabelTable()`から取得して、文字色を変更
- 下: `setMajorTickSpacing(0)`
    - 現在値をハイライトするリスナーを追加
    - 現在値(`slider.getMajorTickSpacing()`が`0`なので)に対応する`JLabel`を`JSlider#getLabelTable()`から取得して、文字色を変更

<!-- dummy comment line for breaking list -->

## コメント
