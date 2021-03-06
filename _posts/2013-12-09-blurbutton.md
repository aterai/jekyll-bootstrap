---
layout: post
category: swing
folder: BlurButton
title: ConvolveOpでコンポーネントにぼかしを入れる
tags: [JButton, ConvolveOp, BufferedImage]
author: aterai
pubdate: 2013-12-09T00:54:27+09:00
description: ConvolveOpを使って、使用不可状態のJButtonにぼかしを入れます。
image: https://lh6.googleusercontent.com/-KJB6Hz9n1R0/UqSGnCNV3HI/AAAAAAAAB70/sTyoJce2HZQ/s800/BlurButton.png
comments: true
---
## 概要
`ConvolveOp`を使って、使用不可状態の`JButton`にぼかしを入れます。

{% download https://lh6.googleusercontent.com/-KJB6Hz9n1R0/UqSGnCNV3HI/AAAAAAAAB70/sTyoJce2HZQ/s800/BlurButton.png %}

## サンプルコード
<pre class="prettyprint"><code>class BlurButton extends JButton {
  private final ConvolveOp op = new ConvolveOp(
      new Kernel(3, 3, new float[] {
    .05f, .05f, .05f,
    .05f, .60f, .05f,
    .05f, .05f, .05f
  }), ConvolveOp.EDGE_NO_OP, null);
  private BufferedImage buf;
  public BlurButton(String label) {
    super(label);
    // System.out.println(op.getEdgeCondition());
  }
  @Override protected void paintComponent(Graphics g) {
    if (isEnabled()) {
      super.paintComponent(g);
    } else {
      int w = getWidth();
      int h = getHeight();
      buf = Optional.ofNullable(buf)
          .filter(bi -&gt; bi.getWidth() == w &amp;&amp; bi.getHeight() == h)
          .orElseGet(() -&gt; new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB));
      Graphics2D g2 = buf.createGraphics();
      g2.setFont(g.getFont()); // pointed out by 八ツ玉舘
      super.paintComponent(g2);
      g2.dispose();
      g.drawImage(op.filter(buf, null), 0, 0, null);
    }
  }
  // @Override public Dimension getPreferredSize() {
  //   Dimension d = super.getPreferredSize();
  //   d.width += 3 * 3;
  //   return d;
  // }
}
</code></pre>

## 解説
- 上
    - デフォルトの`JButton`
- 中
    - `ConvolveOp`を使って、使用不可状態の`JButton`にぼかし
    - [Java Swing Hacks 9. 使用不可状態のコンポーネントをぼかし表示する](https://www.oreilly.co.jp/books/4873112788/)から引用
- 下
    - `WindowsLookAndFeel`の場合、右端`1`ドットの表示が乱れる場合があるので、`EdgeCondition`をデフォルトの`EDGE_ZERO_FILL`から、`EDGE_NO_OP`に変更
    - ~~`WindowsLookAndFeel`の場合、これらのぼかしを入れると文字が拡大されて？(左右の`Border`が広いから？)、文字列が省略されてしまうので、`JButton#getPreferredSize()`をオーバーライドして幅を拡大~~
        - コメントで八ツ玉舘さんから指摘があり、文字が拡大されるのは`BufferedImage`から生成した`Graphics`とコンポーネントの`Graphics`で異なるフォントが設定されていることが原因と判明
        - `g2.setFont(g.getFont());`を使用するよう修正

<!-- dummy comment line for breaking list -->

## 参考リンク
- [ConvolveOp (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/image/ConvolveOp.html)
- [5.8.1 イメージ処理操作の使用方法](https://docs.oracle.com/javase/jp/1.4/guide/2d/spec/j2d-image.fm8.html)
- [Java Image Processing - Blurring for Beginners](http://www.jhlabs.com/ip/blurring.html)
- [Java Swing Hacks 9. 使用不可状態のコンポーネントをぼかし表示する](https://www.oreilly.co.jp/books/4873112788/)

<!-- dummy comment line for breaking list -->

## コメント
