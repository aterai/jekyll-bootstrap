---
layout: post
title: MouseWheelを使った値の増減
category: swing
folder: MouseWheel
tags: [MouseWheelListener, JSpinner, JSlider]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-03-08

## MouseWheelを使った値の増減
`JSpinner`や`JSlider`の値をマウスホイールを使って変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQH9EVaHI/AAAAAAAAAfE/Dv-UnuISmXM/s800/MouseWheel.png)

### サンプルコード
<pre class="prettyprint"><code>spinner.addMouseWheelListener(new MouseWheelListener() {
  public void mouseWheelMoved(MouseWheelEvent e) {
    JSpinner source = (JSpinner)e.getSource();
    SpinnerNumberModel model = (SpinnerNumberModel)source.getModel();
    Integer oldValue = (Integer)source.getValue();
    int newValue = oldValue.intValue()
                  -e.getWheelRotation()*model.getStepSize().intValue();
    int max = ((Integer)model.getMaximum()).intValue(); //1000
    int min = ((Integer)model.getMinimum()).intValue(); //0
    if(min&lt;=newValue &amp;&amp; newValue&lt;=max) {
      source.setValue(newValue);
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JSpinner`や`JSlider`上でマウスホイールを回転させると値が変化します。`e.getWheelRotation()`の値は、ホイールの回転が下方向の場合は増加、上方向は減少になります。

### コメント
