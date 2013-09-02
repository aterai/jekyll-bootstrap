---
layout: post
title: JScrollBarが非表示でもMouseWheelでScrollする
category: swing
folder: MouseWheelScroll
tags: [JScrollBar, JScrollPane, MouseWheelListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-01-02

## JScrollBarが非表示でもMouseWheelでScrollする
`JScrollBar`が非表示の場合の`MouseWheel`による`Scroll`をテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-65-zGNk3eWU/TwFLJU_DP4I/AAAAAAAABHg/mEXoePs30sk/s800/MouseWheelScroll.png)

### サンプルコード
<pre class="prettyprint"><code>JScrollBar vsb = new JScrollBar(JScrollBar.VERTICAL) {
  @Override public Dimension getPreferredSize() {
    Dimension dim = super.getPreferredSize();
    return new Dimension(0, dim.height);
  }
};
</code></pre>

### 解説
- `PreferredSize: 0, shift pressed: Horizontal WheelScrolling`
    - `ScrollBarPolicy`はそれぞれ`ALWAYS`で常に表示
        - `VerticalScrollBarPolicy`: `VERTICAL_SCROLLBAR_ALWAYS`
        - `HorizontalScrollBarPolicy`: `HORIZONTAL_SCROLLBAR_ALWAYS`
    - `JScrollBar#getPreferredSize()`をオーバーライドして、幅、または高さを`0`
    - 垂直スクロールバーの`JScrollBar#isVisible()`をオーバーライドして、<kbd>Shift</kbd>キーが押されている場合は、`false`を返す
        - 垂直スクロールバーが非表示で、水平スクロールバーが表示されている場合、`MouseWheel`で水平スクロール可能

<!-- dummy comment line for breaking list -->

- `SCROLLBAR_ALWAYS`
    - `ScrollBarPolicy`はそれぞれ`ALWAYS`で常に表示
        - `VerticalScrollBarPolicy`: `VERTICAL_SCROLLBAR_ALWAYS`
        - `HorizontalScrollBarPolicy`: `HORIZONTAL_SCROLLBAR_ALWAYS`

<!-- dummy comment line for breaking list -->

- `SCROLLBAR_NEVER`
    - `ScrollBarPolicy`はそれぞれ`NEVER`で常に非表示
        - `VerticalScrollBarPolicy`: `VERTICAL_SCROLLBAR_NEVER`
        - `HorizontalScrollBarPolicy`: `HORIZONTAL_SCROLLBAR_NEVER`

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Bug ID: 6911375 mouseWheel has no effect without vertical scrollbar](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6911375)

<!-- dummy comment line for breaking list -->

### コメント
