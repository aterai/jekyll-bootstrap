---
layout: post
category: swing
folder: SnapToTicksDrag
title: JSliderのSnapToTicksをマウスのドラッグでも適用する
tags: [JSlider, MouseMotionListener]
author: aterai
pubdate: 2009-12-14T13:49:28+09:00
description: JSliderのSnapToTicksをマウスでのドラッグ中にも適用されるように設定します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTU-ruijI/AAAAAAAAAkM/p3Mze4pjyEk/s800/SnapToTicksDrag.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/12/snap-to-ticks-drag-jslider.html
    lang: en
comments: true
---
## 概要
`JSlider`の`SnapToTicks`をマウスでのドラッグ中にも適用されるように設定します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTU-ruijI/AAAAAAAAAkM/p3Mze4pjyEk/s800/SnapToTicksDrag.png %}

## サンプルコード
<pre class="prettyprint"><code>slider.setUI(new MetalSliderUI() {
  @Override protected TrackListener createTrackListener(final JSlider slider) {
    return new TrackListener() {
      @Override public void mouseDragged(MouseEvent e) {
        if (!slider.getSnapToTicks() || slider.getMajorTickSpacing() == 0) {
          super.mouseDragged(e);
          return;
        }
        // case SwingConstants.HORIZONTAL:
        int halfThumbWidth = thumbRect.width / 2;
        final int trackLength = trackRect.width;
        final int trackLeft = trackRect.x - halfThumbWidth;
        final int trackRight = trackRect.x + trackRect.width - 1 + halfThumbWidth;
        int xPos = e.getX();
        int snappedPos = xPos;
        if (xPos &lt;= trackLeft) {
          snappedPos = trackLeft;
        } else if (xPos &gt;= trackRight) {
          snappedPos = trackRight;
        } else {
          // int tickSpacing = slider.getMajorTickSpacing();
          // float actualPixelsForOneTick =
          //     trackLength * tickSpacing / (float) slider.getMaximum();

          // a problem if you choose to set a negative MINIMUM for the JSlider;
          // the calculated drag-positions are wrong.
          // Fixed by bobndrew:
          int possibleTickPositions = slider.getMaximum() - slider.getMinimum();
          int tickSpacing = (slider.getMinorTickSpacing() == 0)
              ? slider.getMajorTickSpacing()
              : slider.getMinorTickSpacing();
          float actualPixelsForOneTick =
              trackLength * tickSpacing / (float) possibleTickPositions;
          xPos -= trackLeft;
          snappedPos = (int) (Math.round(
              xPos / actualPixelsForOneTick) * actualPixelsForOneTick + .5) + trackLeft;
          offset = 0;
          // System.out.println(snappedPos);
        }
        e.translatePoint(snappedPos - e.getX(), 0);
        super.mouseDragged(e);
      }
    };
  }
});
</code></pre>

## 解説
- 上: `Default SnapToTicks`
    - `slider.setSnapToTicks(true);`としているので、マウスをリリースした時点でノブを置いた位置にもっとも近い目盛にスナップされる
- 下: `Custom SnapToTicks`
    - `TrackListener#mouseDragged`をオーバーライドして、マウスでドラッグ中でもカーソルからもっとも近い目盛にスナップされる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BasicSliderUI.TrackListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicSliderUI.TrackListener.html)

<!-- dummy comment line for breaking list -->

## コメント
- `SwingConstants.HORIZONTAL`にしか対応していません。 -- *aterai* 2009-12-21 (月) 11:01:51
- bobndrewさんからの指摘で、ミニマムにマイナスの値を入れるとおかしくなるバグ修正と、`MinorTickSpacing`に対応。 -- *aterai* 2010-10-26 (火) 15:32:11

<!-- dummy comment line for breaking list -->
