---
layout: post
category: swing
folder: ColorChannelSwapFilter
title: JLayerを使ってJProgressBarの色相を変更する
tags: [JProgressBar, JLayer, RGBImageFilter, SwingWorker]
author: aterai
pubdate: 2013-06-24T08:32:54+09:00
description: JLayerを使ってJProgressBarの色相を緑から赤に変更します。
image: https://lh3.googleusercontent.com/-BOomq0cC-U4/UceBZ2TsWWI/AAAAAAAABug/yoXs3wbBVGk/s800/ColorChannelSwapFilter.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/06/turn-jprogressbar-red-with-jlayer-and.html
    lang: en
comments: true
---
## 概要
`JLayer`を使って`JProgressBar`の色相を緑から赤に変更します。

{% download https://lh3.googleusercontent.com/-BOomq0cC-U4/UceBZ2TsWWI/AAAAAAAABug/yoXs3wbBVGk/s800/ColorChannelSwapFilter.png %}

## サンプルコード
<pre class="prettyprint"><code>class BlockedColorLayerUI extends LayerUI&lt;JProgressBar&gt; {
  public boolean isPreventing;
  private transient BufferedImage bi;
  private int prevw = -1;
  private int prevh = -1;

  @Override public void paint(Graphics g, JComponent c) {
    if (isPreventing &amp;&amp; c instanceof JLayer) {
      JLayer jlayer = (JLayer) c;
      JProgressBar progress = (JProgressBar) jlayer.getView();
      int w = progress.getSize().width;
      int h = progress.getSize().height;

      if (bi == null || w != prevw || h != prevh) {
        bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
      }
      prevw = w;
      prevh = h;

      Graphics2D g2 = bi.createGraphics();
      super.paint(g2, c);
      g2.dispose();

      Image image = c.createImage(
        new FilteredImageSource(bi.getSource(), new RedGreenChannelSwapFilter()));
      //BUG: cause an infinite repaint loop: g.drawImage(image, 0, 0, c);
      g.drawImage(image, 0, 0, null);
    } else {
      super.paint(g, c);
    }
  }
}

class RedGreenChannelSwapFilter extends RGBImageFilter {
  @Override public int filterRGB(int x, int y, int argb) {
    int r = (int) ((argb &gt;&gt; 16) &amp; 0xFF);
    int g = (int) ((argb &gt;&gt;  8) &amp; 0xFF);
    int b = (int) ((argb)       &amp; 0xFF);
    return (argb &amp; 0xFF_00_00_00) | (g &lt;&lt; 16) | (r &lt;&lt; 8) | (b);
  }
}
</code></pre>

## 解説
- `setStringPainted(true)`: 上
    - デフォルトの`JProgressBar`に、`JProgressBar#setStringPainted(true)`を設定
- `setStringPainted(true)`: 下
    - `JProgressBar#setStringPainted(true)`を設定
    - チェックボックスが選択された場合、`JProgressBar#setForeground(Color)`で色を変更
- `setStringPainted(false)`: 上
    - デフォルトの`JProgressBar`
- `setStringPainted(false)`: 下
    - チェックボックスが選択された場合、`JLayer`を使って色を変更
        - `Windows 7`での中断状態風に、緑を赤に入れ替えるため、`RGBImageFilter#filterRGB(...)`をオーバーライド

<!-- dummy comment line for breaking list -->

## 参考リンク
- [RGBImageFilterでアイコンの色調を変更](https://ateraimemo.com/Swing/RatingLabel.html)
- [JProgressBarの文字列をJLayerを使って表示する](https://ateraimemo.com/Swing/ProgressStringLayer.html)
- [JProgressBarの進捗状況と進捗文字列色を変更する](https://ateraimemo.com/Swing/ProgressBarSelectionColor.html)

<!-- dummy comment line for breaking list -->

## コメント
- `NimbusLookAndFeel`の場合、`JProgressBar#setOpaque(true)`として`JLayer`と`RedGreenChannelSwapFilter`を使用しないと、フチが半透明にならない。また`NimbusLookAndFeel`の場合、`JProgressBar#setForeground(Color)`で変化するのは他の`LookAndFeel`とは異なり、進捗文字列になる。 -- *aterai* 2013-06-25 (火) 20:51:09
- 再描画が無限ループするバグを修正。 -- *aterai* 2014-11-30 (日) 17:57:58

<!-- dummy comment line for breaking list -->
