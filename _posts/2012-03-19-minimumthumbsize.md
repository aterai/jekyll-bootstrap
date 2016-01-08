---
layout: post
category: swing
folder: MinimumThumbSize
title: JScrollBarのKnobの最小サイズを設定する
tags: [JScrollBar, UIManager, JSlider]
author: aterai
pubdate: 2012-03-19T15:02:42+09:00
description: JScrollBarのKnobの最小サイズを設定します。
comments: true
---
## 概要
`JScrollBar`の`Knob`の最小サイズを設定します。

{% download https://lh4.googleusercontent.com/-A8TRDbOQ1p4/T2bKeM8dcvI/AAAAAAAABKI/iBKMsL6eGfM/s800/MinimumThumbSize.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ScrollBar.minimumThumbSize", new Dimension(32, 32));
</code></pre>

## 解説
上記のサンプルでは、右の`JScrollPane`で、`JScrollBar`の`Knob`(`Thumb`)が短くなりすぎないように、最小サイズ(`Horizontal`の場合は幅、`Vertical`の場合は高さ)を設定します。

- 注: `LookAndFeel`によって、`UIManager.put("ScrollBar.minimumThumbSize", new Dimension(32, 32));`が有効かどうかは異なる
    - 有効: `BasicLookAndFeel`、`WindowsLookAndFeel`
    - 無効: `MetalLookAndFeel`、`NimbusLookAndFeel`
        - 以下のように、縦スクロールバーならその幅が最小サイズになるよう上書きされているため
            
            <pre class="prettyprint"><code>// @see javax/swing/plaf/metal/MetalScrollBarUI.java
            protected Dimension getMinimumThumbSize() {
              return new Dimension(scrollBarWidth, scrollBarWidth);
            }
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `JDK 1.8.0_20`で修正されて、この記事のスクリーンショットのようにノブのサイズが小さくなり過ぎることはなくなった
    - `WindowsScrollBarUI`(`XPStyle`)でのバグだったようだ
    - [Bug ID: JDK-8039464 The scrollbar in JScrollPane has no right border if used WindowsLookAndFeel](http://bugs.java.com/view_bug.do?bug_id=8039464)

<!-- dummy comment line for breaking list -->

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
- [JSliderのつまみの形状を変更](http://ateraimemo.com/Swing/ThumbArrowShape.html)
    - トラックを表示したくない場合は、`slider.putClientProperty("Slider.paintThumbArrowShape", Boolean.TRUE);`で、つまみの形だけ変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Java Swing rendering bug on Windows 7 look-and-feel? - Stack Overflow](http://stackoverflow.com/questions/2754306/java-swing-rendering-bug-on-windows-7-look-and-feel)
- [JSliderのつまみの形状を変更](http://ateraimemo.com/Swing/ThumbArrowShape.html)

<!-- dummy comment line for breaking list -->

## コメント
