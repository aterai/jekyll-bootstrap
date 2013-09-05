---
layout: post
title: JProgressBarにUIを設定してインジケータの色を変更
category: swing
folder: GradientPalletProgressBar
tags: [JProgressBar, PixelGrabber, LinearGradientPaint]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-10-08

## JProgressBarにUIを設定してインジケータの色を変更
`JProgressBar`のインジケータの色を進行に応じてパレットから取得した色に変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-EjSzEK0Wc6g/UHJrTUTxG9I/AAAAAAAABT8/4AKSHxe6PNE/s800/GradientPalletProgressBar.png)

### サンプルコード
<pre class="prettyprint"><code>class GradientPalletProgressBarUI extends BasicProgressBarUI{
  private final int[] pallet;
  public GradientPalletProgressBarUI() {
    super();
    this.pallet = makeGradientPallet();
  }
  private static int[] makeGradientPallet() {
    BufferedImage image = new BufferedImage(100, 1, BufferedImage.TYPE_INT_RGB);
    Graphics2D g2  = image.createGraphics();
    Point2D start  = new Point2D.Float(0f, 0f);
    Point2D end  = new Point2D.Float(99f, 0f);
    float[] dist   = {0.0f, 0.5f, 1.0f};
    Color[] colors = { Color.RED, Color.YELLOW, Color.GREEN };
    g2.setPaint(new LinearGradientPaint(start, end, dist, colors));
    g2.fillRect(0, 0, 100, 1);
    g2.dispose();

    int width  = image.getWidth(null);
    int[] pallet = new int[width];
    PixelGrabber pg = new PixelGrabber(image, 0, 0, width, 1, pallet, 0, width);
    try{
      pg.grabPixels();
    }catch(Exception e) {
      e.printStackTrace();
    }
    return pallet;
  }
  private static Color getColorFromPallet(int[] pallet, float x) {
    if(x &lt; 0.0 || x &gt; 1.0) {
      throw new IllegalArgumentException("Parameter outside of expected range");
    }
    int i = (int)(pallet.length * x);
    int max = pallet.length-1;
    int index = i&lt;0?0:i&gt;max?max:i;
    int pix = pallet[index] &amp; 0x00ffffff;
    return new Color(pix);
  }
  @Override public void paintDeterminate(Graphics g, JComponent c) {
    Insets b = progressBar.getInsets(); // area for border
    int barRectWidth  = progressBar.getWidth()  - (b.right + b.left);
    int barRectHeight = progressBar.getHeight() - (b.top + b.bottom);
    if(barRectWidth &lt;= 0 || barRectHeight &lt;= 0) {
      return;
    }
    // amount of progress to draw
    int amountFull = getAmountFull(b, barRectWidth, barRectHeight);

    if(progressBar.getOrientation() == JProgressBar.HORIZONTAL) {
      // draw the cells
      float x = amountFull / (float)barRectWidth;
      g.setColor(getColorFromPallet(pallet, x));
      g.fillRect(b.left, b.top, amountFull, barRectHeight);

    }else{ // VERTICAL
      //...
    }
    // Deal with possible text painting
    if(progressBar.isStringPainted()) {
      paintString(g, b.left, b.top, barRectWidth, barRectHeight, amountFull, b);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは高さ`1px`の画像をパレットとして予め作成し、それから`JProgressBar`の進捗に応じた色を取得して、`BasicProgressBarUI#paintDeterminate(...)`内で使用することで、色の変更を行なっています。

- パレット用の画像作成は、[JSliderのスタイルを変更する](http://terai.xrea.jp/Swing/GradientTrackSlider.html)と同じ
- 注: `VERTICAL`と、不確定モードには未対応

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Harmonic Code: Varying gradients...](http://harmoniccode.blogspot.jp/2011/05/varying-gradients.html)
- [JSliderのスタイルを変更する](http://terai.xrea.jp/Swing/GradientTrackSlider.html)

<!-- dummy comment line for breaking list -->

### コメント