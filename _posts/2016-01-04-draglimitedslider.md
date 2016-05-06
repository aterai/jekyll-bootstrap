---
layout: post
category: swing
folder: DragLimitedSlider
title: JSliderでマウスドラッグによる値の変更が可能な範囲を制限する
tags: [JSlider, MouseMotionListener]
author: aterai
pubdate: 2016-01-04T00:01:14+09:00
description: JSliderの最小・最大値とは別に、マウスドラッグによる値の変更可能範囲を制限します。
comments: true
---
## 概要
JSliderの最小・最大値とは別に、マウスドラッグによる値の変更可能範囲を制限します。

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
          int x = maxPos + offset;
          MouseEvent me = new MouseEvent(
            e.getComponent(), e.getID(), e.getWhen(), e.getModifiers(),
            x, e.getY(),
            e.getXOnScreen(), e.getYOnScreen(),
            e.getClickCount(), e.isPopupTrigger(), e.getButton());
          e.consume();
          super.mouseDragged(me);
        } else {
          super.mouseDragged(e);
        }
      }
    };
  }
}
</code></pre>

## 解説
上記のサンプルでは、最小値`0`、最大値`100`の目盛りを持つ`JSlider`を作成し、その目盛りの範囲とは別に、取りうる値を制限するようにリスナーを設定しています。

- `ChangeListener`
    - `JSlider`の`BoundedRangeModel`に`ChangeListener`を追加し、`80`以上の値を指定できないように設定
    - マウスドラッグで`100`まで移動すると、リリースした時点で`80`まで戻る
- `TrackListener`
    - 上の`ChangeListener`に加えて、`MetalSliderUI#createTrackListener(...)`をオーバーライドし、独自の`TrackListener`を設定して、マウスドラッグで`80`以上に移動できないように制限
    - `TrackListener`は、`MouseMotionListener`を実装しているので、`mouseDragged(...)`メソッドをオーバーライドし、`80`以上への`MouseEvent`を`consume()`メソッドで消費して無効化

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - How can I prevent a JSlider from moving full-range? - Stack Overflow](http://stackoverflow.com/questions/34561596/how-can-i-prevent-a-jslider-from-moving-full-range)

<!-- dummy comment line for breaking list -->

## コメント