---
layout: post
category: swing
folder: GradientPalletProgressBar
title: JProgressBarにUIを設定してインジケータの色を変更
tags: [JProgressBar, PixelGrabber, LinearGradientPaint]
author: aterai
pubdate: 2012-10-08T15:21:36+09:00
description: JProgressBarのインジケータの色を進行に応じてパレットから取得した色に変更します。
image: https://lh5.googleusercontent.com/-EjSzEK0Wc6g/UHJrTUTxG9I/AAAAAAAABT8/4AKSHxe6PNE/s800/GradientPalletProgressBar.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2015/05/dynamically-change-color-of.html
    lang: en
comments: true
---
## 概要
`JProgressBar`のインジケータの色を進行に応じてパレットから取得した色に変更します。

{% download https://lh5.googleusercontent.com/-EjSzEK0Wc6g/UHJrTUTxG9I/AAAAAAAABT8/4AKSHxe6PNE/s800/GradientPalletProgressBar.png %}

## サンプルコード
<pre class="prettyprint"><code>class GradientPalletProgressBarUI extends BasicProgressBarUI {
  private final int[] pallet;
  protected GradientPalletProgressBarUI() {
    super();
    this.pallet = makeGradientPallet();
  }
  private static int[] makeGradientPallet() {
    BufferedImage image = new BufferedImage(100, 1, BufferedImage.TYPE_INT_RGB);
    Graphics2D g2  = image.createGraphics();
    Point2D start  = new Point2D.Float();
    Point2D end    = new Point2D.Float(99, 0);
    float[] dist   = {0f, .5f, 1f};
    Color[] colors = {Color.RED, Color.YELLOW, Color.GREEN};
    g2.setPaint(new LinearGradientPaint(start, end, dist, colors));
    g2.fillRect(0, 0, 100, 1);
    g2.dispose();

    int width = image.getWidth(null);
    int[] pallet = new int[width];
    PixelGrabber pg = new PixelGrabber(image, 0, 0, width, 1, pallet, 0, width);
    try {
      pg.grabPixels();
    } catch (InterruptedException ex) {
      ex.printStackTrace();
    }
    return pallet;
  }
  private static Color getColorFromPallet(int[] pallet, float x) {
    if (x &lt; 0f || x &gt; 1f) {
      throw new IllegalArgumentException("Parameter outside of expected range");
    }
    int i = (int) (pallet.length * x);
    int max = pallet.length - 1;
    int index = Math.min(Math.max(i, 0), max);
    return new Color(pallet[index] &amp; 0x00_FF_FF_FF);
    //translucent
    //int pix = pallet[index] &amp; 0x00_FF_FF_FF | (0x64 &lt;&lt; 24);
    //return new Color(pix), true);
  }
  @Override public void paintDeterminate(Graphics g, JComponent c) {
    Insets b = progressBar.getInsets(); // area for border
    int barRectWidth  = progressBar.getWidth()  - b.right - b.left;
    int barRectHeight = progressBar.getHeight() - b.top   - b.bottom;
    if (barRectWidth &lt;= 0 || barRectHeight &lt;= 0) {
      return;
    }
    //int cellLength = getCellLength();
    //int cellSpacing = getCellSpacing();
    // amount of progress to draw
    int amountFull = getAmountFull(b, barRectWidth, barRectHeight);

    // draw the cells
    if (progressBar.getOrientation() == SwingConstants.HORIZONTAL) {
      float x = amountFull / (float) barRectWidth;
      g.setColor(getColorFromPallet(pallet, x));
      g.fillRect(b.left, b.top, amountFull, barRectHeight);
    } else { // VERTICAL
      float y = amountFull / (float) barRectHeight;
      g.setColor(getColorFromPallet(pallet, y));
      g.fillRect(b.left, barRectHeight + b.bottom - amountFull, barRectWidth, amountFull);
    }
    // Deal with possible text painting
    if (progressBar.isStringPainted()) {
      paintString(g, b.left, b.top, barRectWidth, barRectHeight, amountFull, b);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは高さ`1px`の画像をパレットとして予め作成し、それから`JProgressBar`の進捗に応じた色を取得して、`BasicProgressBarUI#paintDeterminate(...)`内で使用することで、色の変更を行なっています。

- パレット用の画像作成は、[JSliderのスタイルを変更する](https://ateraimemo.com/Swing/GradientTrackSlider.html)と同じ
- 注: 不確定モードには未対応

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Harmonic Code: Varying gradients...](http://harmoniccode.blogspot.jp/2011/05/varying-gradients.html)
- [JSliderのスタイルを変更する](https://ateraimemo.com/Swing/GradientTrackSlider.html)

<!-- dummy comment line for breaking list -->

## コメント
