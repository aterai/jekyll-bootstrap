---
layout: post
category: swing
folder: RandomDissolve
title: RandomDissolveで表示を切り替え
tags: [Animation, Graphics, BufferedImage, WritableRaster]
author: aterai
pubdate: 2007-03-26T20:17:32+09:00
description: RandomDissolve効果で表示する画像を切り替えます。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRdPqz07I/AAAAAAAAAhM/h3EaItM41Yw/s800/RandomDissolve.png
comments: true
---
## 概要
`RandomDissolve`効果で表示する画像を切り替えます。このサンプルは、[Java 2D - random pixelwise fading ?](https://community.oracle.com/thread/1270228)に投稿されているソースコードを参考にしています。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRdPqz07I/AAAAAAAAAhM/h3EaItM41Yw/s800/RandomDissolve.png %}

## サンプルコード
<pre class="prettyprint"><code>class RandomDissolve extends JComponent implements ActionListener {
  private static final int STAGES = 16;
  private final Timer animator;
  private final transient BufferedImage image1;
  private final transient BufferedImage image2;
  private transient BufferedImage srcimg;
  private boolean mode = true;
  private int currentStage;
  private int[] src, dst, step;

  public RandomDissolve(BufferedImage i1, BufferedImage i2) {
    super();
    this.image1 = i1;
    this.image2 = i2;
    this.srcimg = copyImage(mode ? image2 : image1);
    animator = new Timer(10, this);
  }

  public boolean nextStage() {
    if (currentStage &gt; 0) {
      currentStage = currentStage - 1;
      for (int i = 0; i &lt; step.length; i++) {
        if (step[i] == currentStage) {
          src[i] = dst[i];
        }
      }
      return true;
    } else {
      return false;
    }
  }

  private BufferedImage copyImage(final BufferedImage image) {
    int w = image.getWidth();
    int h = image.getHeight();
    BufferedImage result = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
    Graphics2D g = result.createGraphics();
    g.drawRenderedImage(image, null);
    g.dispose();
    return result;
  }

  private int[] getData(BufferedImage image) {
    WritableRaster wr = image.getRaster();
    DataBufferInt dbi = (DataBufferInt) wr.getDataBuffer();
    return dbi.getData();
  }

  public void animationStart() {
    currentStage = STAGES;
    srcimg = copyImage(mode ? image2 : image1);
    src = getData(srcimg);
    dst = getData(copyImage(mode ? image1 : image2));
    step = new int[src.length];
    mode ^= true;
    Random rnd = new Random();
    for (int i = 0; i &lt; step.length; i++) {
      step[i] = rnd.nextInt(currentStage);
    }
    animator.start();
  }

  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    Graphics2D g2d = (Graphics2D) g.create();
    g2d.setPaint(getBackground());
    g2d.fillRect(0, 0, getWidth(), getHeight());
    g2d.drawImage(srcimg, 0, 0, srcimg.getWidth(), srcimg.getHeight(), this);
    g2d.dispose();
  }

  @Override public void actionPerformed(ActionEvent e) {
    if (nextStage()) {
      repaint();
    } else {
      animator.stop();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`BufferedImage`から`WritableRaster`を取得し、元画像と次の画像のコピーから`int`配列をそれぞれ用意しています。元画像の配列を次の画像のピクセルでランダムに置き換えて、これを再描画することで画像の切り替えを行っています。

## 参考リンク
- [Java 2D - random pixelwise fading ?](https://community.oracle.com/thread/1270228)
- [WritableRaster (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/image/WritableRaster.html)

<!-- dummy comment line for breaking list -->

## コメント
