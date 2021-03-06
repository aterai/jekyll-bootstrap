---
layout: post
category: swing
folder: MouseWheelScroll
title: JScrollBarが非表示でもMouseWheelでScrollする
tags: [JScrollBar, JScrollPane, MouseWheelListener]
author: aterai
pubdate: 2012-01-02T15:22:30+09:00
description: JScrollBarが非表示の場合のMouseWheelによるScrollをテストします。
image: https://lh6.googleusercontent.com/-65-zGNk3eWU/TwFLJU_DP4I/AAAAAAAABHg/mEXoePs30sk/s800/MouseWheelScroll.png
comments: true
---
## 概要
`JScrollBar`が非表示の場合の`MouseWheel`による`Scroll`をテストします。

{% download https://lh6.googleusercontent.com/-65-zGNk3eWU/TwFLJU_DP4I/AAAAAAAABHg/mEXoePs30sk/s800/MouseWheelScroll.png %}

## サンプルコード
<pre class="prettyprint"><code>JScrollBar vsb = new JScrollBar(Adjustable.VERTICAL) {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.height = 0;
    return d;
  }
};
</code></pre>

## 解説
- `PreferredSize: 0, shift pressed: Horizontal WheelScrolling`
    - `ScrollBarPolicy`はそれぞれ`ALWAYS`で常に表示
        - `VerticalScrollBarPolicy`: `VERTICAL_SCROLLBAR_ALWAYS`
        - `HorizontalScrollBarPolicy`: `HORIZONTAL_SCROLLBAR_ALWAYS`
    - `JScrollBar#getPreferredSize()`をオーバーライドして、幅、または高さを`0`にして返す
    - 垂直スクロールバーの`JScrollBar#isVisible()`をオーバーライドして<kbd>Shift</kbd>キーが押されている場合は`false`を返す
        - 垂直スクロールバーが非表示で水平スクロールバーが表示されている場合、`MouseWheel`で水平スクロール可能
- `SCROLLBAR_ALWAYS`
    - `ScrollBarPolicy`はそれぞれ`ALWAYS`で常に表示
        - `VerticalScrollBarPolicy`: `VERTICAL_SCROLLBAR_ALWAYS`
        - `HorizontalScrollBarPolicy`: `HORIZONTAL_SCROLLBAR_ALWAYS`
- `SCROLLBAR_NEVER`
    - `ScrollBarPolicy`はそれぞれ`NEVER`で常に非表示
        - `VerticalScrollBarPolicy`: `VERTICAL_SCROLLBAR_NEVER`
        - `HorizontalScrollBarPolicy`: `HORIZONTAL_SCROLLBAR_NEVER`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JDK-6911375 mouseWheel has no effect without vertical scrollbar - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6911375)

<!-- dummy comment line for breaking list -->

## コメント
