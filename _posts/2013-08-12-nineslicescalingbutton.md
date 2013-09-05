---
layout: post
title: JButtonに9分割した画像を使用する
category: swing
folder: NineSliceScalingButton
tags: [JButton, Icon, BufferedImage, RGBImageFilter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-08-12

## JButtonに9分割した画像を使用する
`JButton`を拡大縮小しても四隅などのサイズが変更しないようにように`9`分割した画像を使用します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-yYRfTw-3_BU/UgaFQAAiUcI/AAAAAAAABx4/koHqjZ3o36Q/s800/NineSliceScalingButton.png)

### サンプルコード
<pre class="prettyprint"><code>class NineSliceScalingIcon implements Icon {
  private final BufferedImage image;
  private final int a, b, c, d;
  private int width, height;
  public NineSliceScalingIcon(BufferedImage image, int a, int b, int c, int d) {
    this.image = image;
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
  }
  @Override public int getIconWidth() {
    return width;
  }
  @Override public int getIconHeight() {
    return Math.max(image.getHeight(null), height);
  }
  @Override public void paintIcon(Component cmp, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D)g.create();
    g2.setRenderingHint(
        RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

    Insets i = ((JComponent)cmp).getBorder().getBorderInsets(cmp);
    //g2.translate(x, y); //JDK 1.7.0 などで描画がおかしい？

    int iw = image.getWidth(cmp);
    int ih = image.getHeight(cmp);
    width  = cmp.getWidth()-i.left-i.right;
    height = cmp.getHeight()-i.top-i.bottom;

    g2.drawImage(image.getSubimage(a, c, iw - a - b, ih - c - d),
                 a, c, width - a - b, height - c - d, cmp);

    if(a&gt;0 &amp;&amp; b&gt;0 &amp;&amp; c&gt;0 &amp;&amp; d&gt;0) {
      g2.drawImage(image.getSubimage(a, 0, iw - a - b, c),
                   a, 0, width - a - b, c, cmp);
      g2.drawImage(image.getSubimage(a, ih - d, iw - a - b, d),
                   a, height - d, width - a - b, d, cmp);
      g2.drawImage(image.getSubimage(0, c, a, ih - c - d),
                   0, c, a, height - c - d, cmp);
      g2.drawImage(image.getSubimage(iw - b, c, b, ih - c - d),
                   width - b, c, b, height - c - d, cmp);

      g2.drawImage(image.getSubimage(0, 0, a, c), 0, 0, cmp);
      g2.drawImage(image.getSubimage(iw - b, 0, b, c), width - b, 0, cmp);
      g2.drawImage(image.getSubimage(0, ih - d, a, d), 0, height - d, cmp);
      g2.drawImage(image.getSubimage(iw - b, ih - d, b, d), width - b, height - d, cmp);
    }
    g2.dispose();
  }
}
</code></pre>

### 解説
上記のサンプルでは、`BufferedImage#getSubimage`で元画像を`9`分割し、四隅はサイズ変更なし、上下辺は幅のみ拡大縮小、左右辺は高さのみ拡大縮小、中央は幅高さが拡大縮小可能になるよう、`Graphics#drawImage(...)`のスケーリングを利用して描画しています。

- 四隅などの固定サイズ
    - `a`: 左上下隅の幅
    - `b`: 右上下隅の幅
    - `c`: 左右上隅の高さ
    - `d`: 左右下隅の高さ

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Real World Illustrator: Understanding 9-Slice Scaling](http://rwillustrator.blogspot.jp/2007/04/understanding-9-slice-scaling.html)
    - テスト用の画像(`symbol_scale_2.jpg`)を拝借しています。

<!-- dummy comment line for breaking list -->

### コメント