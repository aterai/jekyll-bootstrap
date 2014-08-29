---
layout: post
title: Iconを回転する
category: swing
folder: RotatedIcon
tags: [Icon, AffineTransform]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-06-11

## Iconを回転する
画像ファイルから`90`、`180`、`270`度回転した`Icon`を作成します。

{% download https://lh4.googleusercontent.com/-OK_vUTiAiCA/T9WIzXvRm9I/AAAAAAAABNk/ubus049qH04/s800/RotatedIcon.png %}

### サンプルコード
<pre class="prettyprint"><code>class RotateIcon implements Icon{
  private int width, height;
  private Image image;
  private AffineTransform trans;
  public RotateIcon(Icon icon, int rotate) {
    if((rotate%90)!=0) {
      throw new IllegalArgumentException(
        rotate + ": Rotate must be (rotate % 90 == 0)");
    }

    width  = icon.getIconWidth();
    height = icon.getIconHeight();
    image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
    Graphics g = image.getGraphics();
    icon.paintIcon(null, g, 0, 0);
    g.dispose();

    int numquadrants = (rotate / 90) % 4;
    if(numquadrants==1 || numquadrants==-3) {
      trans = AffineTransform.getTranslateInstance(height, 0);
      int v = width; width = height; height = v;
    }else if(numquadrants==-1 || numquadrants==3) {
      trans = AffineTransform.getTranslateInstance(0, width);
      int v = width; width = height; height = v;
    }else if(Math.abs(numquadrants)==2) {
      trans = AffineTransform.getTranslateInstance(width, height);
    }else{
      trans = AffineTransform.getTranslateInstance(0, 0);
    }
    trans.quadrantRotate(numquadrants);
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D)g.create();
    g2.translate(x, y);
    g2.drawImage(image, trans, c);
    g2.translate(-x, -y);
    g2.dispose();
  }
  @Override public int getIconWidth()  {
    return width;
  }
  @Override public int getIconHeight() {
    return height;
  }
}
</code></pre>

### 解説
- `Default`
    - 幅高さ: `83x100`
- `Rotate`: `180`
    - 幅高さ: `83x100`
    - 上下反転と同等: [AffineTransformOpで画像を反転する](http://terai.xrea.jp/Swing/AffineTransformOp.html)
- `Rotate`: `90`(時計回りに`90`度)
    - 幅高さ: `100x83`(元画像の幅高さを入れ替え)
    - 左上を原点に`90`度回転し、元画像の高さだけ`X`軸プラス方向に移動
- `Rotate`: `-90`(反時計回りに`90`度)
    - 幅高さ: `100x83`(元画像の幅高さを入れ替え)
    - 左上を原点に`270`度回転し、元画像の幅だけ`Y`軸プラス方向に移動

<!-- dummy comment line for breaking list -->

- - - -
以下のような方法もあります。

<pre class="prettyprint"><code>enum QuadrantRotate {
  CLOCKWISE(1),
  VERTICAL_FLIP(2),
  COUNTER_CLOCKWISE(-1);
  private final int numquadrants;
  private QuadrantRotate(int numquadrants) {
    this.numquadrants = numquadrants;
  }
  public int getNumQuadrants() {
    return numquadrants;
  }
}
class QuadrantRotateIcon implements Icon{
  private final QuadrantRotate rotate;
  private final Icon icon;
  public QuadrantRotateIcon(Icon icon, QuadrantRotate rotate) {
    this.icon = icon;
    this.rotate = rotate;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    int w = icon.getIconWidth();
    int h = icon.getIconHeight();
    Graphics2D g2 = (Graphics2D)g.create();
    g2.translate(x, y);
    switch(rotate) {
      case CLOCKWISE:         g2.translate(h, 0); break;
      case VERTICAL_FLIP:     g2.translate(w, h); break;
      case COUNTER_CLOCKWISE: g2.translate(0, w); break;
    }
    g2.rotate(Math.toRadians(90*rotate.getNumQuadrants()));
    icon.paintIcon(c, g2, 0, 0);
    g2.dispose();
  }
  @Override public int getIconWidth()  {
    return rotate==QuadrantRotate.VERTICAL_FLIP
      ? icon.getIconWidth() : icon.getIconHeight();
  }
  @Override public int getIconHeight() {
    return rotate==QuadrantRotate.VERTICAL_FLIP
      ? icon.getIconHeight() : icon.getIconWidth();
  }
}
</code></pre>

### 参考リンク
- [Duke Images: iconSized](http://duke.kenai.com/iconSized/index.html)
- [AffineTransformOpで画像を反転する](http://terai.xrea.jp/Swing/AffineTransformOp.html)
- [Mouseで画像を移動、回転](http://terai.xrea.jp/Swing/MouseDrivenImageRotation.html)

<!-- dummy comment line for breaking list -->

### コメント
