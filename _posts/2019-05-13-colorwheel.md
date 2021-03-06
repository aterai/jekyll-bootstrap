---
layout: post
category: swing
folder: ColorWheel
title: JPanelに色相環を描画する
tags: [Graphics, JPanel, BufferedImage]
author: aterai
pubdate: 2019-05-13T15:15:38+09:00
description: JPanelに明度を最大値に固定した色相環を描画します。
image: https://drive.google.com/uc?id=1ab5yQit9V_ffTOwkOV9zxIehv-q8yUnuow
hreflang:
    href: https://java-swing-tips.blogspot.com/2019/05/draw-color-wheel-on-jpanel.html
    lang: en
comments: true
---
## 概要
`JPanel`に明度を最大値に固定した色相環を描画します。

{% download https://drive.google.com/uc?id=1ab5yQit9V_ffTOwkOV9zxIehv-q8yUnuow %}

## サンプルコード
<pre class="prettyprint"><code>// Colors: a Color Dialog | Java Graphics
// https://javagraphics.blogspot.com/2007/04/jcolorchooser-making-alternative.html
private BufferedImage updateImage() {
  BufferedImage image = new BufferedImage(SIZE, SIZE, BufferedImage.TYPE_INT_ARGB);
  int[] row = new int[SIZE];
  float size = (float) SIZE;
  float radius = size / 2f;

  for (int yidx = 0; yidx &lt; SIZE; yidx++) {
    float y = yidx - size / 2f;
    for (int xidx = 0; xidx &lt; SIZE; xidx++) {
      float x = xidx - size / 2f;
      double theta = Math.atan2(y, x) - 3d * Math.PI / 2d;
      if (theta &lt; 0) {
        theta += 2d * Math.PI;
      }
      double r = Math.sqrt(x * x + y * y);
      float hue = (float) (theta / (2d * Math.PI));
      float sat = Math.min((float) (r / radius), 1f);
      float bri = 1f;
      row[xidx] = Color.HSBtoRGB(hue, sat, bri);
    }
    image.getRaster().setDataElements(0, yidx, SIZE, 1, row);
  }
  return image;
}
</code></pre>

## 解説
上記のサンプルでは、色相環をサイズ固定で`JPanel`の中央に描画しています。

- 色相(`hue`): `new Color(Color.HSBtoRGB(0f, 1f, 1f))`は赤で、これを頂点に角度に応じて色相を変更
- 彩度(`saturation`): 中心から外周へ`0f`から`1f`で彩度をグラデーション描画
- 明度(`brightness`): 最大値の`1f`で明度は固定

<!-- dummy comment line for breaking list -->

- - - -
- `1`つのピクセルごとに`HSB`から`RGB`に色変換して`BufferedImage`を作成しているので、円の縁でジャギーが発生する
    - このサンプルでは円ではなく正方形の色マップを描画し、あとでソフトクリッピング効果を使った円図形での切り抜きを行っている
        
        <pre class="prettyprint"><code>// Soft Clipping
        GraphicsConfiguration gc = g2.getDeviceConfiguration();
        BufferedImage buf = gc.createCompatibleImage(s, s, Transparency.TRANSLUCENT);
        Graphics2D g2d = buf.createGraphics();
        
        g2d.setComposite(AlphaComposite.Src);
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.fill(new Ellipse2D.Float(0f, 0f, s, s));
        
        g2d.setComposite(AlphaComposite.SrcAtop);
        g2d.drawImage(colorWheelImage, 0, 0, null);
        g2d.dispose();
        
        g2.drawImage(buf, null, (getWidth() - s) / 2, (getHeight() - s) / 2);
        g2.dispose();
</code></pre>
    - `Corretto 1.8.0_212`を使用すると、色相環が特定のサイズになると[Windowの縁をソフトクリッピングでなめらかにする](https://ateraimemo.com/Swing/SoftClippedWindow.html)と同様の描画抜け？が発生する場合がある
        - `SIZE`を`192`、`224`、`256`、`288`、`320`などの`32`の倍数にすると描画が壊れる
        - `RenderingHints.KEY_ANTIALIASING`を使用しなければ発生しない
        - [Backport JDK-8048782: OpenJDK: PiscesCache : xmax/ymax rounding up can cause RasterFormatException by sci-aws · Pull Request #94 · corretto/corretto-8](https://github.com/corretto/corretto-8/pull/94)が原因？なら`1.8.0_222`で修正される予定だが、~~すこし違うような気もする...~~ これに関連したリグレッションだった模様
    - [Java2D rendering may break when using soft clipping effects · Issue #127 · corretto/corretto-8](https://github.com/corretto/corretto-8/issues/127)で報告済み、`1.8.0_222`で修正済み~~される予定~~
    - 参考元の[Colors: a Color Dialog | Java Graphics](https://javagraphics.blogspot.com/2007/04/jcolorchooser-making-alternative.html)では、外周のピクセルに直接アンチエイリアスを実施しているので上記のバグは発生しない
        
        <pre class="prettyprint"><code>// antialias
        float k = 1.2f; // the number of pixels to antialias
        if (r &gt; radius - k) {
          int alpha = (int)(255 - 255 * (r - radius + k) / k);
          if (alpha &lt; 0) alpha = 0;
          if (alpha &gt; 255) alpha = 255;
          row[x] = row[x] &amp; 0xff_ff_ff + (alpha &lt;&lt; 24);
        }
</code></pre>
    - * 参考リンク [#reference]
- [Colors: a Color Dialog | Java Graphics](https://javagraphics.blogspot.com/2007/04/jcolorchooser-making-alternative.html)
    - カラーピッカー機能付きだが、このサンプルでは描画機能部分を参考にした
    - java.netが無くなってリポジトリが参照不可になっているので、githubのクローンや[Java Source Code: colorpicker.swing.ColorPickerPanel](http://www.javased.com/index.php?source_dir=SPREAD/src/colorpicker/swing/ColorPickerPanel.java)などでソースを参照
- [Color.HSBtoRGB(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Color.html#HSBtoRGB-float-float-float-)

<!-- dummy comment line for breaking list -->

## コメント
