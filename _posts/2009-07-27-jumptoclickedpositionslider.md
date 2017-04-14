---
layout: post
category: swing
folder: JumpToClickedPositionSlider
title: JSliderでクリックした位置にノブをスライド
tags: [JSlider, MouseMotionListener, MouseListener]
author: aterai
pubdate: 2009-07-27T11:47:16+09:00
description: JSliderをマウスでクリックした場合、その位置にノブをスライド、続けてドラッグ可能にします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTOt05WV7I/AAAAAAAAAc0/Eobj6KIAQzk/s800/JumpToClickedPositionSlider.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2009/11/jump-to-clicked-position-jslider.html
    lang: en
comments: true
---
## 概要
`JSlider`をマウスでクリックした場合、その位置にノブをスライド、続けてドラッグ可能にします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTOt05WV7I/AAAAAAAAAc0/Eobj6KIAQzk/s800/JumpToClickedPositionSlider.png %}

## サンプルコード
<pre class="prettyprint"><code>slider.setUI(new MetalSliderUI() {
  @Override protected TrackListener createTrackListener(JSlider slider) {
    return new TrackListener() {
      @Override public void mousePressed(MouseEvent e) {
        if (UIManager.getBoolean("Slider.onlyLeftMouseButtonDrag")
              &amp;&amp; SwingUtilities.isLeftMouseButton(e)) {
          JSlider slider = (JSlider) e.getComponent();
          switch (slider.getOrientation()) {
          case SwingConstants.VERTICAL:
            slider.setValue(valueForYPosition(e.getY()));
            break;
          case SwingConstants.HORIZONTAL:
            slider.setValue(valueForXPosition(e.getX()));
            break;
          default:
            throw new IllegalArgumentException("orientation must be one of: VERTICAL, HORIZONTAL");
          }
          super.mousePressed(e); //isDragging = true;
          super.mouseDragged(e);
        } else {
          super.mousePressed(e);
        }
      }
      @Override public boolean shouldScroll(int direction) {
        return false;
      }
    };
  }
});
</code></pre>

## 解説
- 縦左、横上の`JSlider`:
    - デフォルト
    - ノブを直接クリックすると、ドラッグ可能
    - ノブ以外の場所をクリックすると、タイマーでノブの幅ずつその方向に移動
- 縦右、横下の`JSlider`:
    - クリックした位置までスライドし、続けてドラッグ可能
        - 目盛の間隔が広い場合、ノブがスナップされてマウスカーソルからはずれてしまい、続けてドラッグできない場合がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSlider question: Position after leftclick - Stack Overflow](https://stackoverflow.com/questions/518471/jslider-question-position-after-leftclick)

<!-- dummy comment line for breaking list -->

## コメント
