---
layout: post
title: JSliderのUIや色を変更する
category: swing
folder: VolumeSlider
tags: [JSlider]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-12-04

## JSliderのUIや色を変更する
`JSlider`のトラックやつまみ、色などを変更して、音量調節風のスライダーを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTWc-B0OXI/AAAAAAAAApQ/t1b78yBXWUQ/s800/VolumeSlider.png)

### サンプルコード
<pre class="prettyprint"><code>class TriangleSliderUI extends javax.swing.plaf.metal.MetalSliderUI {
  @Override public void paintThumb(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    g2.fillOval(thumbRect.x,thumbRect.y,thumbRect.width,thumbRect.height);
  }
  @Override public void paintTrack(Graphics g) {
    int cx, cy, cw, ch;
    int pad;
    Rectangle trackBounds = trackRect;
    if(slider.getOrientation() == JSlider.HORIZONTAL ) {
      Graphics2D g2 = (Graphics2D)g;

//......

slider2.setUI(new javax.swing.plaf.metal.MetalSliderUI() {
  @Override protected void paintHorizontalLabel(Graphics g, int v, Component l) {
    JLabel lbl = (JLabel)l;
    lbl.setForeground(Color.GREEN);
    super.paintHorizontalLabel(g,v,lbl);
  }
});
slider2.setForeground(Color.BLUE);
</code></pre>

### 解説
- 上の`JSlider`
    - `MetalSliderUI`を継承する`SliderUI`をセットしています。この`SliderUI`は、`paintThumb(Graphics)`メソッドをオーバライドしてつまみの形を変更、`paintTrack(Graphics)`メソッドをオーバライドしてトラックの形と色を変更します。

<!-- dummy comment line for breaking list -->

- 下の`JSlider`
    - `JSlider#setForeground(Color)`で、目盛のキャプションの色を青にしています。また、`MetalSliderUI`を継承する`SliderUI`を作成して、`paintHorizontalLabel(Graphics, int, Component)`メソッドをオーバライドし目盛を緑色に変更しています。
    - 別の方法: [JSliderの目盛にアイコンや文字列を追加する](http://terai.xrea.jp/Swing/SliderLabelTable.html)

<!-- dummy comment line for breaking list -->

- 注意点
    - 垂直方向には対応していません。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - Problem in changing forground color of JSlider!!](https://forums.oracle.com/message/5812389)
- [JSliderの目盛にアイコンや文字列を追加する](http://terai.xrea.jp/Swing/SliderLabelTable.html)

<!-- dummy comment line for breaking list -->

### コメント
- `Java SE 6 Runtime (JRE) Update N build 12 Kernel Installer`だと、`NullPointerException`が発生する？ -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-03 (月) 19:34:50
- ~~別方法のメモ:~~ [JSliderの目盛りをアイコンに変更する](http://terai.xrea.jp/Swing/TriangleTickSlider.html)に移動 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-05-19 (水) 16:52:13
- メモ: [Bug ID: 5099681 Windows/Motif L&F: JSlider should use foreground color for ticks.](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5099681) -- [aterai](http://terai.xrea.jp/aterai.html) 2010-05-20 (木) 17:24:52

<!-- dummy comment line for breaking list -->
