---
layout: post
title: JSliderの順序をを反転
category: swing
folder: InvertedSlider
tags: [JSlider]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-02-10

## JSliderの順序をを反転
`JSlider`の値や目盛りの表示などの順序を反転します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-qI_Mv8LOhi8/UvdK3TThMiI/AAAAAAAAB_0/xQR9OJ1Z8xY/s800/InvertedSlider.png)

### サンプルコード
<pre class="prettyprint"><code>slider.setInverted(true);
</code></pre>

### 解説
上記のサンプルでは、`JSlider#setInverted(true)`で、値や目盛りの表示を反転しています。

- 注:
    - `JSlider#setInverted(true)`と`setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`で言語に依存する方向を同時に指定可能
        - `JSlider.HORIZONTAL`の場合、両方指定すると元に戻る
        - `JSlider.VERTICAL`の場合、`JSlider#setInverted(true)`で上最小、下最大に変化し、`setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`で目盛りの位置が右から左に変化する
    - 範囲の塗り潰しが可能な`MetalLookAndFeel`の場合、これも反転する

<!-- dummy comment line for breaking list -->

### コメント
- 縦の`JSlider`で`ComponentOrientation.RIGHT_TO_LEFT`、`WindowsLookAndFeel`を設定した場合、ノブのフォーカスが描画されない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2014-02-26 (水) 21:22:55

<!-- dummy comment line for breaking list -->
