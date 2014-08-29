---
layout: post
title: JProgressBarのNimbusLookAndFeelにおける不確定状態アニメーションを変更する
category: swing
folder: IndeterminateRegionPainter
tags: [JProgressBar, UIDefaults, Painter, NimbusLookAndFeel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-06-30

## JProgressBarのNimbusLookAndFeelにおける不確定状態アニメーションを変更する
`JProgressBar`を`NimbusLookAndFeel`で使用している場合、その不確定状態アニメーションを変更します。

{% download https://lh5.googleusercontent.com/-L28C52EISs4/U7AofjsiWqI/AAAAAAAACIo/OHDDAqKKk6E/s800/IndeterminateRegionPainter.png %}

### サンプルコード
<pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
d.put("ProgressBar[Enabled+Indeterminate].foregroundPainter", new AbstractRegionPainter() {
  //...
  private final PaintContext ctx = new PaintContext(
      new Insets(5, 5, 5, 5), new Dimension(29, 19), false);
  @Override public void doPaint(
      Graphics2D g, JComponent c, int width, int height, Object[] extendedCacheKeys) {
    path = decodePath1();
    g.setPaint(color17);
    g.fill(path);
    rect = decodeRect3();
    g.setPaint(decodeGradient5(rect));
    g.fill(rect);
    rect = decodeRect4();
    g.setPaint(decodeGradient6(rect));
    g.fill(rect);
  }
  @Override public PaintContext getPaintContext() {
    return ctx;
  }
  //...
});
progressBar1 = new JProgressBar(model);
progressBar1.putClientProperty("Nimbus.Overrides", d);
</code></pre>

### 解説
上記のサンプルでは、`NimbusLookAndFeel`で`JProgressBar`の不確定状態アニメーションを変更するために、セルの描画を行う`AbstractRegionPainter#doPaint(...)`をオーバーライドし、これを`UIDefaults`に設定しています。

### 参考リンク
- [JProgressBarの不確定状態でのアニメーションパターンを変更する](http://terai.xrea.jp/Swing/StripedProgressBar.html)

<!-- dummy comment line for breaking list -->

### コメント
