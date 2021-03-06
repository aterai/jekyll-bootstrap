---
layout: post
category: swing
folder: GradientTrackSlider
title: JSliderのスタイルを変更する
tags: [JSlider, LinearGradientPaint, Transparent, UIManager, Icon]
author: aterai
pubdate: 2011-05-23T15:19:26+09:00
description: JSliderのトラックとノブを透明にし、値を半透明の色で描画します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TdnxSfPEQLI/AAAAAAAAA7k/vYTnJ_FPktg/s800/GradientTrackSlider.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/06/gradient-translucent-track-jslider.html
    lang: en
comments: true
---
## 概要
`JSlider`のトラックとノブを透明にし、値を半透明の色で描画します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TdnxSfPEQLI/AAAAAAAAA7k/vYTnJ_FPktg/s800/GradientTrackSlider.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Slider.horizontalThumbIcon", new Icon() {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {}
  @Override public int getIconWidth()  { return 15; }
  @Override public int getIconHeight() { return 64; }
});
UIManager.put("Slider.trackWidth", 64);
UIManager.put("Slider.majorTickLength", 6);

JSlider slider = makeSlider();
slider.setUI(new MetalSliderUI() {
  int[] pallet = makeGradientPallet();
  @Override public void paintTrack(Graphics g) {
    //Color trackColor = !slider.isEnabled()
    //  ? MetalLookAndFeel.getControlShadow() : slider.getForeground();
    boolean leftToRight = true; //MetalUtils.isLeftToRight(slider);
    Color controlDarkShadow = Color.GRAY;
    Color controlHighlight = new Color(200, 255, 200);
    Color controlShadow = new Color(0, 100, 0);

    g.translate(trackRect.x, trackRect.y);

    int trackLeft = 0;
    int trackTop = 0;
    int trackRight = 0;
    int trackBottom = 0;

    // Draw the track
    if (slider.getOrientation() == SwingConstants.HORIZONTAL) {
      trackBottom = (trackRect.height - 1) - getThumbOverhang();
      trackTop = trackBottom - (getTrackWidth() - 1);
      trackRight = trackRect.width - 1;
    } else {
      if (leftToRight) {
        trackLeft = (trackRect.width - getThumbOverhang()) - getTrackWidth();
        trackRight = (trackRect.width - getThumbOverhang()) - 1;
      } else {
        trackLeft = getThumbOverhang();
        trackRight = getThumbOverhang() + getTrackWidth() - 1;
      }
      trackBottom = trackRect.height - 1;
    }

    if (slider.isEnabled()) {
      g.setColor(controlDarkShadow);
      g.drawRect(trackLeft, trackTop,
                (trackRight - trackLeft) - 1, (trackBottom - trackTop) - 1);

      g.setColor(controlHighlight);
      g.drawLine(trackLeft + 1, trackBottom, trackRight, trackBottom);
      g.drawLine(trackRight, trackTop + 1, trackRight, trackBottom);

      g.setColor(controlShadow);
      g.drawLine(trackLeft + 1, trackTop + 1, trackRight - 2, trackTop + 1);
      g.drawLine(trackLeft + 1, trackTop + 1, trackLeft + 1, trackBottom - 2);
    } else {
      g.setColor(controlShadow);
      g.drawRect(trackLeft, trackTop,
                 (trackRight - trackLeft) - 1, (trackBottom - trackTop) - 1);
    }

    // Draw the fill
    int middleOfThumb = 0;
    int fillTop = 0;
    int fillLeft = 0;
    int fillBottom = 0;
    int fillRight = 0;

    if (slider.getOrientation() == SwingConstants.HORIZONTAL) {
      middleOfThumb = thumbRect.x + (thumbRect.width / 2);
      middleOfThumb -= trackRect.x; // To compensate for the g.translate()
      fillTop = !slider.isEnabled() ? trackTop : trackTop + 1;
      fillBottom = !slider.isEnabled() ? trackBottom - 1 : trackBottom - 2;

      if (!drawInverted()) {
        fillLeft = !slider.isEnabled() ? trackLeft : trackLeft + 1;
        fillRight = middleOfThumb;
      } else {
        fillLeft = middleOfThumb;
        fillRight = !slider.isEnabled() ? trackRight - 1 : trackRight - 2;
      }
    } else {
      middleOfThumb = thumbRect.y + (thumbRect.height / 2);
      middleOfThumb -= trackRect.y; // To compensate for the g.translate()
      fillLeft = !slider.isEnabled() ? trackLeft : trackLeft + 1;
      fillRight = !slider.isEnabled() ? trackRight - 1 : trackRight - 2;

      if (!drawInverted()) {
        fillTop = middleOfThumb;
        fillBottom = !slider.isEnabled() ? trackBottom - 1 : trackBottom - 2;
      } else {
        fillTop = !slider.isEnabled() ? trackTop : trackTop + 1;
        fillBottom = middleOfThumb;
      }
    }

    if (slider.isEnabled()) {
      g.setColor(slider.getBackground());
      g.drawLine(fillLeft, fillTop, fillRight, fillTop );
      g.drawLine(fillLeft, fillTop, fillLeft, fillBottom );

      double x = (fillRight - fillLeft) / (double) (trackRight - trackLeft);
      g.setColor(getColorFromPallet(pallet, x));
      g.fillRect(fillLeft + 1, fillTop + 1,
                 fillRight - fillLeft, fillBottom - fillTop);
    } else {
      g.setColor(controlShadow);
      g.fillRect(fillLeft, fillTop, fillRight - fillLeft, trackBottom - trackTop);
    }

    int yy = trackTop + (trackBottom - trackTop) / 2;
    for (int i = 10; i &gt;= 0; i--) {
      g.setColor(new Color(1f, 1f, 1f, i * .07f));
      g.drawLine(trackLeft + 2, yy, (trackRight - trackLeft), yy);
      yy--;
    }
    g.translate(-trackRect.x, -trackRect.y);
  }
});
</code></pre>

## 解説
上記のサンプルでは、`MetalSliderUI#paintTrack(...)`メソッドをオーバーライドした`SliderUI`を設定するなどして、`JSlider`の各スタイルを変更しています。

- `Track`
    - `JSlider#setOpaque(false)`で透明化
    - `MetalSliderUI#paintTrack(...)`内で、`Fill`の後でハイライトを描画
- `Thumb`
    - `UIManager.put("Slider.horizontalThumbIcon", emptyIcon)`で、透明なアイコンを設定して非表示化
- `Fill`
    - `MetalSliderUI#paintTrack(...)`内で、値に応じて`LinearGradientPaint`から作成した色で描画

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static int[] makeGradientPallet() {
  BufferedImage image = new BufferedImage(100, 1, BufferedImage.TYPE_INT_RGB);
  Graphics2D g2  = image.createGraphics();
  Point2D start  = new Point2D.Float(0f, 0f);
  Point2D end    = new Point2D.Float(99f, 0f);
  float[] dist   = {0f, .5f, 1f};
  Color[] colors = {Color.RED, Color.YELLOW, Color.GREEN};
  g2.setPaint(new LinearGradientPaint(start, end, dist, colors));
  g2.fillRect(0, 0, 100, 1);
  int width  = image.getWidth(null);
  int[] pallet = new int[width];
  PixelGrabber pg = new PixelGrabber(image, 0, 0, width, 1, pallet, 0, width);
  try {
    pg.grabPixels();
  } catch (Exception e) {
    e.printStackTrace();
  }
  return pallet;
}
private static Color getColorFromPallet(int[] pallet, float x) {
  int i = (int) (pallet.length * x);
  int max = pallet.length-1;
  int index = i &lt; 0 ? 0 : i &gt; max ? max : i;
  int pix = pallet[index] &amp; 0x00_FF_FF_FF | (0x64 &lt;&lt; 24);
  return new Color(pix, true);
}
</code></pre>

- - - -
- メモ: 例えば`WindowsLookAndFeel`では、`UIManager.get("Slider.trackWidth")`は`null`なので、`MetalSliderUI#installUI()`中にある以下のコードでエラーになる
    - `trackWidth = ( (Integer) UIManager.get("Slider.trackWidth") ).intValue();`
    - なぜ`UIManager.getInt(...)`を使用しないのかは不明
    - `UIManager.put("Slider.majorTickLength", 6);`などで適当な値を代入して回避
    - `MetalSliderUI`ではなく、`BasicSliderUI`を継承するぺき？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Harmonic Code: Varying gradients...](http://harmoniccode.blogspot.com/2011/05/varying-gradients.html)

<!-- dummy comment line for breaking list -->

## コメント
