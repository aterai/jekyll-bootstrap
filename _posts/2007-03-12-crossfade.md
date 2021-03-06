---
layout: post
category: swing
folder: Crossfade
title: Crossfadeで画像の切り替え
tags: [Animation, ImageIcon, AlphaComposite]
author: aterai
pubdate: 2007-03-12T13:33:16+09:00
description: Crossfadeアニメーションで画像の切り替えを行います。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKRJIdouI/AAAAAAAAAVs/yU1oEsWfzvA/s800/Crossfade.png
comments: true
---
## 概要
`Crossfade`アニメーションで画像の切り替えを行います。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKRJIdouI/AAAAAAAAAVs/yU1oEsWfzvA/s800/Crossfade.png %}

## サンプルコード
<pre class="prettyprint"><code>class Crossfade extends JComponent implements ActionListener {
  private final javax.swing.Timer animator;
  private final ImageIcon icon1;
  private final ImageIcon icon2;
  private int alpha = 10;
  private boolean direction = true;

  public Crossfade(ImageIcon icon1, ImageIcon icon2) {
    this.icon1 = icon1;
    this.icon2 = icon2;
    animator = new javax.swing.Timer(50, this);
  }

  public void animationStart() {
    direction = !direction;
    animator.start();
  }

  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setPaint(getBackground());
    g2.fillRect(0, 0, getWidth(), getHeight());
    if (direction &amp;&amp; alpha &lt; 10) {
      alpha = alpha + 1;
    } else if (!direction &amp;&amp; alpha &gt; 0) {
      alpha = alpha - 1;
    } else {
      animator.stop();
    }
    g2.setComposite(AlphaComposite.getInstance(
        AlphaComposite.SRC_OVER, 1f - alpha * .1f));
    g2.drawImage(icon1.getImage(), 0, 0,
        (int) icon1.getIconWidth(), (int) icon1.getIconHeight(), this);
    g2.setComposite(AlphaComposite.getInstance(
        AlphaComposite.SRC_OVER, alpha * .1f));
    g2.drawImage(icon2.getImage(), 0, 0,
        (int) icon2.getIconWidth(), (int) icon2.getIconHeight(), this);
    g2.dispose();
  }

  @Override public void actionPerformed(ActionEvent e) {
    repaint();
  }
}
</code></pre>

## 解説
上記のサンプルでは、`2`枚の画像の描画に使用する`AlphaComposite`をそれぞれ変化させながら上書きすることで、画像の表示を切り替えています。

上書き規則には`AlphaComposite.SRC_OVER`を使っています。

## 参考リンク
- [AlphaComposite.SRC_OVER (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/AlphaComposite.html#SRC_OVER)

<!-- dummy comment line for breaking list -->

## コメント
