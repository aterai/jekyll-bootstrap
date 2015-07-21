---
layout: post
category: swing
folder: JumpToClickedPositionSlider
title: JSliderでクリックした位置にノブをスライド
tags: [JSlider, MouseMotionListener, MouseListener]
author: aterai
pubdate: 2009-07-27T11:47:16+09:00
description: JSliderをマウスでクリックした場合、その位置にノブをスライド、続けてドラッグ可能にします。
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
        JSlider slider = (JSlider) e.getSource();
        switch (slider.getOrientation()) {
          case SwingConstants.VERTICAL:
            slider.setValue(valueForYPosition(e.getY()));
            break;
          case SwingConstants.HORIZONTAL:
            slider.setValue(valueForXPosition(e.getX()));
            break;
        }
        super.mousePressed(e); //isDragging = true;
        super.mouseDragged(e);
      }
      @Override public boolean shouldScroll(int direction) {
        return false;
      }
    };
  }
});
</code></pre>

## 解説
- 縦の左、横の上
    - デフォルトの動作
    - ノブをクリックすると、ドラッグ可能
    - ノブ以外の場所をクリックすると、タイマーでノブの幅ずつその方向に移動

<!-- dummy comment line for breaking list -->

- 縦の右、横の下
    - クリックした位置までスライドし、続けてドラッグ可能
        - 目盛の間隔が広い場合、ノブがスナップされてマウスカーソルからはずれてしまい、続けてドラッグできない場合がある
    - メディアプレイヤー風？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSlider question: Position after leftclick - Stack Overflow](http://stackoverflow.com/questions/518471/jslider-question-position-after-leftclick)

<!-- dummy comment line for breaking list -->

## コメント
