---
layout: post
title: JSliderのSnapToTicksをマウスのドラッグでも適用する
category: swing
folder: SnapToTicksDrag
tags: [JSlider, MouseMotionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-12-14

## JSliderのSnapToTicksをマウスのドラッグでも適用する
`JSlider`の`SnapToTicks`をマウスでのドラッグ中にも適用されるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTTU-ruijI/AAAAAAAAAkM/p3Mze4pjyEk/s800/SnapToTicksDrag.png)

### サンプルコード
<pre class="prettyprint"><code>slider.setUI(new MetalSliderUI() {
  @Override protected TrackListener createTrackListener(final JSlider slider) {
    return new TrackListener() {
      @Override public void mouseDragged(MouseEvent e) {
        if(!slider.getSnapToTicks() || slider.getMajorTickSpacing()==0) {
          super.mouseDragged(e);
          return;
        }
        //case JSlider.HORIZONTAL:
        int halfThumbWidth = thumbRect.width / 2;
        final int trackLength = trackRect.width;
        final int trackLeft   = trackRect.x - halfThumbWidth;
        final int trackRight  = trackRect.x + trackRect.width - 1 + halfThumbWidth;
        int xPos = e.getX();
        int snappedPos = xPos;
        if(xPos &lt;= trackLeft) {
          snappedPos = trackLeft;
        }else if(xPos &gt;= trackRight) {
          snappedPos = trackRight;
        }else{
          //int tickSpacing = slider.getMajorTickSpacing();
          //float actualPixelsForOneTick = trackLength * tickSpacing / (float)slider.getMaximum();

          // a problem if you choose to set a negative MINIMUM for the JSlider;
          // the calculated drag-positions are wrong.
          // Fixed by bobndrew:
          int possibleTickPositions = slider.getMaximum() - slider.getMinimum();
          int tickSpacing = (slider.getMinorTickSpacing()==0)
                      ? slider.getMajorTickSpacing()
                      : slider.getMinorTickSpacing();
          float actualPixelsForOneTick = trackLength * tickSpacing / (float) possibleTickPositions;
          xPos -= trackLeft;
          snappedPos = (int) (Math.round(xPos/actualPixelsForOneTick) * actualPixelsForOneTick + 0.5) + trackLeft;
          offset = 0;
          //System.out.println(snappedPos);
        }
        MouseEvent me = new MouseEvent(
          e.getComponent(), e.getID(), e.getWhen(), e.getModifiers(),
          snappedPos, e.getY(),
          e.getXOnScreen(), e.getYOnScreen(),
          e.getClickCount(), e.isPopupTrigger(), e.getButton());
        e.consume();
        super.mouseDragged(me);
      }
    };
  }
});
</code></pre>

### 解説
- 上:デフォルト
    - `slider.setSnapToTicks(true);`としているので、マウスをリリースした時点で、ノブを置いた位置にもっとも近い目盛にスナップされる
- 下:
    - `TrackListener#mouseDragged`をオーバーライドして、マウスでドラッグ中でもカーソルからもっとも近い目盛にスナップされる

<!-- dummy comment line for breaking list -->

### コメント
- `JSlider.HORIZONTAL`にしか対応していません。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-12-21 (月) 11:01:51
- bobndrewさんからの指摘で、ミニマムにマイナスの値を入れるとおかしくなるバグ修正と、`MinorTickSpacing`に対応。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-10-26 (火) 15:32:11

<!-- dummy comment line for breaking list -->
