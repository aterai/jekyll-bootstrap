---
layout: post
category: swing
folder: VolumeSlider
title: JSliderのUIや色を変更する
tags: [JSlider]
author: aterai
pubdate: 2006-12-04T02:52:00+09:00
description: JSliderのトラックやつまみ、色などを変更して、音量調節風のスライダーを作成します。
comments: true
---
## 概要
`JSlider`のトラックやつまみ、色などを変更して、音量調節風のスライダーを作成します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWc-B0OXI/AAAAAAAAApQ/t1b78yBXWUQ/s800/VolumeSlider.png %}

## サンプルコード
<pre class="prettyprint"><code>class TriangleSliderUI extends MetalSliderUI {
  @Override public void paintThumb(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    g2.fillOval(thumbRect.x, thumbRect.y, thumbRect.width, thumbRect.height);
    g2.dispose();
  }
  @Override public void paintTrack(Graphics g) {
    int cx, cy, cw, ch;
    int pad;
    Rectangle trackBounds = trackRect;
    if (slider.getOrientation() == SwingConstants.HORIZONTAL ) {
      Graphics2D g2 = (Graphics2D) g.create();

//...

slider2.setUI(new MetalSliderUI() {
  @Override protected void paintHorizontalLabel(Graphics g, int v, Component l) {
    JLabel lbl = (JLabel) l;
    lbl.setForeground(Color.GREEN);
    super.paintHorizontalLabel(g, v, lbl);
  }
});
slider2.setForeground(Color.BLUE);
</code></pre>

## 解説
- 上:
    - `MetalSliderUI`を継承する`SliderUI`を設定
        - `paintThumb(Graphics)`メソッドをオーバーライドしてつまみの形を変更
        - `paintTrack(Graphics)`メソッドをオーバーライドしてトラックの形と色を変更
    - 注: 垂直方向には未対応
- 下:
    - `JSlider#setForeground(Color)`で、目盛のキャプションの色を青に変更
    - `MetalSliderUI`を継承する`SliderUI`を作成して、`paintHorizontalLabel(Graphics, int, Component)`メソッドをオーバーライドし目盛を緑色に変更
    - 別の方法: [JSliderの目盛にアイコンや文字列を追加する](http://ateraimemo.com/Swing/SliderLabelTable.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - Problem in changing forground color of JSlider!!](https://community.oracle.com/thread/1375990)
- [JSliderの目盛にアイコンや文字列を追加する](http://ateraimemo.com/Swing/SliderLabelTable.html)

<!-- dummy comment line for breaking list -->

## コメント
- `Java SE 6 Runtime (JRE) Update N build 12 Kernel Installer`だと、`NullPointerException`が発生する？ -- *aterai* 2008-03-03 (月) 19:34:50
- ~~別方法のメモ:~~ [JSliderの目盛りをアイコンに変更する](http://ateraimemo.com/Swing/TriangleTickSlider.html)に移動。 -- *aterai* 2010-05-19 (水) 16:52:13
- メモ: [Bug ID: 5099681 Windows/Motif L&F: JSlider should use foreground color for ticks.](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=5099681) -- *aterai* 2010-05-20 (木) 17:24:52

<!-- dummy comment line for breaking list -->
