---
layout: post
category: swing
folder: EaseInOut
title: JTextAreaをキャプションとして画像上にスライドイン
tags: [JTextArea, OverlayLayout, JLabel, MouseListener, Animation]
author: aterai
pubdate: 2011-05-09T15:30:53+09:00
description: 画像の上にJTextAreaをスライドインアニメーションで表示します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/Tcd9MqA6BlI/AAAAAAAAA64/Q7KLCkUETZ4/s800/EaseInOut.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/05/translucent-image-caption-using.html
    lang: en
comments: true
---
## 概要
画像の上に`JTextArea`をスライドインアニメーションで表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/Tcd9MqA6BlI/AAAAAAAAA64/Q7KLCkUETZ4/s800/EaseInOut.png %}

## サンプルコード
<pre class="prettyprint"><code>private int delay = 4;
private int count = 0;
@Override public void mouseEntered(MouseEvent e) {
  if (animator != null &amp;&amp; animator.isRunning() || yy == textArea.getPreferredSize().height) {
    return;
  }
  double h = (double) textArea.getPreferredSize().height;
  animator = new Timer(delay, new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      double a = easeInOut(++count / h);
      yy = (int) (.5 + a * h);
      textArea.setBackground(new Color(0f, 0f, 0f, (float) (.6 * a)));
      if (yy &gt;= textArea.getPreferredSize().height) {
        yy = textArea.getPreferredSize().height;
        animator.stop();
      }
      revalidate();
      repaint();
    }
  });
  animator.start();
}
@Override public void mouseExited(MouseEvent e) {
  if (animator != null &amp;&amp; animator.isRunning() ||
     contains(e.getPoint()) &amp;&amp; yy == textArea.getPreferredSize().height) return;
  final double h = (double) textArea.getPreferredSize().height;
  animator = new Timer(delay, new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      double a = easeInOut(--count / h);
      yy = (int) (.5 + a * h);
      textArea.setBackground(new Color(0f, 0f, 0f, (float) (.6 * a)));
      if (yy &lt;= 0) {
        yy = 0;
        animator.stop();
      }
      revalidate();
      repaint();
    }
  });
  animator.start();
}
// @see Math: EaseIn EaseOut, EaseInOut and Beziér Curves | Anima Entertainment GmbH
// http://www.anima-entertainment.de/math-easein-easeout-easeinout-and-bezier-curves
public double easeInOut(double t) {
  // range: 0.0 &lt;= t &lt;= 1.0
  if (t &lt; .5) {
    return .5 * Math.pow(t * 2d, 3d);
  } else {
    return .5 * (Math.pow(t * 2d - 2d, 3d) + 2d);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JLabel`に画像を表示してその内部にマウスカーソルが入った場合`JTextArea`がキャプションとして`ease-in`, `ease-out`でスライドインするよう設定しています。

- `OverlayLayout#layoutContainer`内で`JTextArea`の`y`座標を変更してアニメーション
- `EaseInOut`の計算は、~~[Math: EaseIn EaseOut, EaseInOut and Beziér Curves | Anima Entertainment GmbH](http://www.anima-entertainment.de/math-easein-easeout-easeinout-and-bezier-curves)~~を参考
- マウスカーソルが`JLabel`(画像)内にあってもそこに`JTextArea`がスライドインした場合、新たに`mouseExited`イベントが発生するので注意が必要
    - `JTextArea#contains(int x, int y)`が常に`false`を返すようにすれば上記の場合でも`mouseExited`イベントなどは発生しないが`JTextArea`内の文字列が選択できなくなるので、このサンプルでは`JTextArea`にマウスイベントを親へ素通しするリスナーを追加している
- `JTextArea`の背景色は`setOpaque(false)`にして描画せず、別途`JTextArea#paintComponent(...)`をオーバーライドしてアルファ成分を`EaseInOut`した色で全体を塗りつぶしている

<!-- dummy comment line for breaking list -->

- - - -
- 累乗を`Math.pow(...)`の代わりにバイナリ法で実行する場合のメモ
    - [指数が整数ならMath.powは使うな - DoMshi](http://d.hatena.ne.jp/pcl/20120617/p1)
    - [整数のべき乗 - rexpit's programming memo](http://d.hatena.ne.jp/rexpit/20110328/1301305266)
    - [Integer Power Algorithm](http://c2.com/cgi/wiki?IntegerPowerAlgorithm)
    - [The Power Algorithm - How a programmer can save time rising a real number to the power of a positive integer number. The code is dot.net but it's easily adaptable to any other language.](http://www.osix.net/modules/article/?id=696)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public static double intpow(double x, int n) {
  double aux = 1d;
  if (n &lt; 0) {
    throw new IllegalArgumentException("n must be a positive integer");
  }
  for (; n &gt; 0; x *= x, n &gt;&gt;&gt;= 1) {
    if ((n &amp; 1) != 0) {
      aux *= x;
    }
  }
  return aux;
}
</code></pre>

## 参考リンク
- ~~[Math: EaseIn EaseOut, EaseInOut and Beziér Curves | Anima Entertainment GmbH](http://www.anima-entertainment.de/math-easein-easeout-easeinout-and-bezier-curves)~~
- [Slide In Image Captions | CSS-Tricks](http://css-tricks.com/slide-in-image-captions/)
- [指数関数を使ったお手軽イーズ・アウト - Radium Software](http://radiumsoftware.tumblr.com/post/5031889912)
- [Soft maximum 関数 - Radium Software](http://radiumsoftware.tumblr.com/post/10719023826)
- [イーズイン/アウトいろいろ - wonderfl build flash online](http://wonderfl.net/c/3GhW)
- [本の虫: なんでGCCはa*a*a*a*a*a を (a*a*a)*(a*a*a) に最適化できないの？っと](http://cpplover.blogspot.jp/2014/03/gccaaaaaa-aaaaaa.html)

<!-- dummy comment line for breaking list -->

## コメント
