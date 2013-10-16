---
layout: post
title: JScrollBarをJSliderとして使用する
category: swing
folder: ScrollBarAsSlider
tags: [JScrollBar, JSlider, JSpinner]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-12-15

## JScrollBarをJSliderとして使用する
`JScrollBar`を`JSlider`の代わりとして使用します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSgYVysvI/AAAAAAAAAi4/5UjLktCUVb8/s800/ScrollBarAsSlider.png)

### サンプルコード
<pre class="prettyprint"><code>int step   = 5;
int extent = 20;
int min    = 0;
int max    = extent*10; //200
int value  = 50;
final JScrollBar scrollbar = new JScrollBar(
            JScrollBar.HORIZONTAL, value, extent, min, max+extent);
scrollbar.setUnitIncrement(step);
scrollbar.getModel().addChangeListener(new ChangeListener(){
  @Override public void stateChanged(javax.swing.event.ChangeEvent e) {
    BoundedRangeModel m = (BoundedRangeModel)e.getSource();
    spinner.setValue(m.getValue());
  }
});
final JSpinner spinner = new JSpinner(
            new SpinnerNumberModel(value, min, max, step));
//...
</code></pre>

### 解説
上記のサンプルでは、`JScrollBar`を`JSlider`として使用し、`JSpinner`と連動させています。`JScrollBar`に設定する最大値は、スクロールバーのノブ(`extent`はノブの幅)の右ではなく左端になるように調整する必要があります。

- このため、`JSpinner`の最大値とは異なり、`max`+`extent`が`JScrollBar`に設定する最大値となる
- 垂直なら上端

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JScrollBar](http://docs.oracle.com/javase/jp/6/api/javax/swing/JScrollBar.html)

<!-- dummy comment line for breaking list -->

### コメント
