---
layout: post
title: JScrollBarのKnobの最小サイズを設定する
category: swing
folder: MinimumThumbSize
tags: [JScrollBar, UIManager, JSlider]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-03-19

## JScrollBarのKnobの最小サイズを設定する
`JScrollBar`の`Knob`の最小サイズを設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-A8TRDbOQ1p4/T2bKeM8dcvI/AAAAAAAABKI/iBKMsL6eGfM/s800/MinimumThumbSize.png)

### サンプルコード
<pre class="prettyprint"><code>UIManager.put("ScrollBar.minimumThumbSize", new Dimension(32, 32));
</code></pre>

### 解説
上記のサンプルでは、右の`JScrollPane`で、`JScrollBar`の`Knob`(`Thumb`)が短くなりすぎないように、最小サイズ(`Horizontal`の場合は幅、`Vertical`の場合は高さ)を設定します。

- - - -
`Windows 7`の`WindowsLookAndFeel`で`JSlider`を使った場合も、つまみ？のサイズが小さすぎるが、`UIManager.put("Slider.minimumHorizontalSize", new Dimension(32, 32))`などとしても効果がない？

	Slider.horizontalSize
	Slider.verticalSize
	Slider.minimumHorizontalSize
	Slider.minimumVerticalSize
	Slider.horizontalThumbIcon
	Slider.verticalThumbIcon

- 参考: [Java Swing rendering bug on Windows 7 look-and-feel? - Stack Overflow](http://stackoverflow.com/questions/2754306/java-swing-rendering-bug-on-windows-7-look-and-feel)
    - `slider.setPaintTicks(true)`とした場合は、正常なサイズにみえる。

<!-- dummy comment line for breaking list -->

### コメント
