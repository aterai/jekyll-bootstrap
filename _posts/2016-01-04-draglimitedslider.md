---
layout: post
category: swing
folder: DragLimitedSlider
title: JSliderでマウスドラッグによる値の変更が可能な範囲を制限する
tags: [JSlider, MouseMotionListener]
author: aterai
pubdate: 2016-01-04T00:01:14+09:00
description: JSliderの最小・最大値とは別に、マウスドラッグによる値の変更可能範囲を制限します。
image: https://lh3.googleusercontent.com/-g2NOF6rEUgk/VokzS6_rd_I/AAAAAAAAOKc/UhGy1ZKCdpQ/s800-Ic42/DragLimitedSlider.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2019/02/limit-movable-range-of-jsliders-value.html
    lang: en
comments: true
---
## 概要
`JSlider`の最小・最大値とは別に、マウスドラッグによる値の変更可能範囲を制限します。

{% download https://lh3.googleusercontent.com/-g2NOF6rEUgk/VokzS6_rd_I/AAAAAAAAOKc/UhGy1ZKCdpQ/s800-Ic42/DragLimitedSlider.png %}

## サンプルコード
<pre class="prettyprint"><code>class MetalDragLimitedSliderUI extends MetalSliderUI {
  @Override protected TrackListener createTrackListener(JSlider slider) {
    return new TrackListener() {
      @Override public void mouseDragged(MouseEvent e) {
        //case HORIZONTAL:
        int halfThumbWidth = thumbRect.width / 2;
        int thumbLeft = e.getX() - offset;
        int maxPos = xPositionForValue(MAXI) - halfThumbWidth;
        if (thumbLeft &gt; maxPos) {
          e.translatePoint(maxPos + offset - e.getX(), 0);
        }
        super.mouseDragged(e);
      }
    };
  }
}
</code></pre>

## 解説
上記のサンプルでは、最小値`0`、最大値`100`の目盛りを持つ`JSlider`を作成し、その目盛りの範囲とは別に取りうる値を制限するためのリスナーを設定しています。

- `ChangeListener`
    - `JSlider`の`BoundedRangeModel`に`ChangeListener`を追加し、`80`以上の値を指定できないように設定
    - マウスドラッグで`100`まで移動すると、リリースした時点で`80`まで戻る
- `TrackListener`
    - 上の`ChangeListener`に加えて、`MetalSliderUI#createTrackListener(...)`をオーバーライドし、独自の`TrackListener`を設定して、マウスドラッグで`80`以上に移動できないように制限
    - `TrackListener`は`MouseMotionListener`を実装しているので、`mouseDragged(...)`メソッドをオーバーライドして`80`以上への`MouseEvent`を`translatePoint(...)`メソッドで座標変換して無効化 ~~`consume()`メソッドで消費して無効化~~

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - How can I prevent a JSlider from moving full-range? - Stack Overflow](https://stackoverflow.com/questions/34561596/how-can-i-prevent-a-jslider-from-moving-full-range)

<!-- dummy comment line for breaking list -->

## コメント
