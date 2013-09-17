---
layout: post
title: JSliderでクリックした位置にノブをスライド
category: swing
folder: JumpToClickedPositionSlider
tags: [JSlider, MouseMotionListener, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-07-27

## JSliderでクリックした位置にノブをスライド
`JSlider`をマウスでクリックした場合、その位置にノブをスライド、続けてドラッグ可能にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTOt05WV7I/AAAAAAAAAc0/Eobj6KIAQzk/s800/JumpToClickedPositionSlider.png)

### サンプルコード
<pre class="prettyprint"><code>slider.setUI(new MetalSliderUI() {
  protected TrackListener createTrackListener(JSlider slider) {
    return new TrackListener() {
      @Override public void mousePressed(MouseEvent e) {
        JSlider slider = (JSlider)e.getSource();
        switch (slider.getOrientation()) {
          case JSlider.VERTICAL:
            slider.setValue(valueForYPosition(e.getY()));
            break;
          case JSlider.HORIZONTAL:
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

### 解説
- 左と上
    - デフォルトの動作
    - ノブをクリックすると、ドラッグ可能
    - ノブ以外の場所をクリックすると、タイマーでノブの幅ずつその方向に移動

<!-- dummy comment line for breaking list -->

- 右と下
    - クリックした位置までスライドし、続けてドラッグ可能
        - 目盛の間隔が広い場合、ノブがスナップされてマウスカーソルからはずれてしまい、続けてドラッグできない場合がある
    - メディアプレイヤー風？

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JSlider question: Position after leftclick - Stack Overflow](http://stackoverflow.com/questions/518471/jslider-question-position-after-leftclick)

<!-- dummy comment line for breaking list -->

### コメント
