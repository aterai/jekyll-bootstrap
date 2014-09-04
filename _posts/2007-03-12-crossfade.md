---
layout: post
title: Crossfadeで画像の切り替え
category: swing
folder: Crossfade
tags: [Animation, ImageIcon, AlphaComposite]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-03-12

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
  @Override public void paintComponent(Graphics g) {
    Graphics2D g2d = (Graphics2D)g;
    g2d.setPaint(getBackground());
    g2d.fillRect(0, 0, getWidth(), getHeight());
    if(direction &amp;&amp; alpha&lt;10) {
      alpha = alpha + 1;
    }else if(!direction &amp;&amp; alpha&gt;0) {
      alpha = alpha - 1;
    }else{
      animator.stop();
    }
    g2d.setComposite(AlphaComposite.getInstance(
      AlphaComposite.SRC_OVER, 1.0f-alpha*0.1f));
    g2d.drawImage(icon1.getImage(), 0, 0,
      (int)icon1.getIconWidth(), (int)icon1.getIconHeight(), this);
    g2d.setComposite(AlphaComposite.getInstance(
      AlphaComposite.SRC_OVER, alpha*0.1f));
    g2d.drawImage(icon2.getImage(), 0, 0,
      (int)icon2.getIconWidth(), (int)icon2.getIconHeight(), this);
  }
  @Override public void actionPerformed(ActionEvent e) {
    repaint();
  }
}
</code></pre>

## 解説
上記のサンプルでは、二枚の画像の描画に使用する`AlphaComposite`をそれぞれ変化させながら上書きすることで、`Crossfade`による画像の切り替えを行っています。

上書きの規則には、`AlphaComposite.SRC_OVER`を使っています。

## コメント
