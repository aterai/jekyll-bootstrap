---
layout: post
category: swing
folder: OnlyLeftMouseButtonDrag
title: JSliderのノブをマウスの右ボタンで操作不可に設定する
tags: [JSlider, UIManager]
author: aterai
pubdate: 2015-11-09T00:56:22+09:00
description: JSliderのノブをマウスの右ボタンで操作可能かどうかを設定で切り替えます。
image: https://lh3.googleusercontent.com/-coZSnO6AOYE/Vj9vbNsYp8I/AAAAAAAAOGA/2KnLThlR9u4/s800-Ic42/OnlyLeftMouseButtonDrag.png
comments: true
---
## 概要
`JSlider`のノブをマウスの右ボタンで操作可能かどうかを設定で切り替えます。

{% download https://lh3.googleusercontent.com/-coZSnO6AOYE/Vj9vbNsYp8I/AAAAAAAAOGA/2KnLThlR9u4/s800-Ic42/OnlyLeftMouseButtonDrag.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Slider.onlyLeftMouseButtonDrag", Boolean.TRUE);
</code></pre>

## 解説
- `UIManager.put("Slider.onlyLeftMouseButtonDrag", Boolean.TRUE);`
    - `JSlider`のノブをマウスの右ボタンでドラッグしても操作不可
    - `WindowsLookAndFeel`などのデフォルト
- `UIManager.put("Slider.onlyLeftMouseButtonDrag", Boolean.FALSE);`
    - `JSlider`のノブをマウスの右ボタンでドラッグで操作可能
    - `NimbusLookAndFeel`などのデフォルト

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Bug ID: JDK-6614972 JSlider value should not change on right-click](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6614972)
- [java - How to disable position change of JSlider on mouse right click - Stack Overflow](https://stackoverflow.com/questions/9736237/how-to-disable-position-change-of-jslider-on-mouse-right-click)

<!-- dummy comment line for breaking list -->

## コメント
