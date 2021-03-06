---
layout: post
category: swing
folder: IndeterminateRegionPainter
title: JProgressBarのNimbusLookAndFeelにおける不確定状態アニメーションを変更する
tags: [JProgressBar, UIDefaults, Painter, NimbusLookAndFeel, Animation]
author: aterai
pubdate: 2014-06-30T15:57:20+09:00
description: JProgressBarをNimbusLookAndFeelで使用している場合、その不確定状態アニメーションを変更します。
image: https://lh5.googleusercontent.com/-L28C52EISs4/U7AofjsiWqI/AAAAAAAACIo/OHDDAqKKk6E/s800/IndeterminateRegionPainter.png
comments: true
---
## 概要
`JProgressBar`を`NimbusLookAndFeel`で使用している場合、その不確定状態アニメーションを変更します。

{% download https://lh5.googleusercontent.com/-L28C52EISs4/U7AofjsiWqI/AAAAAAAACIo/OHDDAqKKk6E/s800/IndeterminateRegionPainter.png %}

## サンプルコード
<pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
d.put("ProgressBar[Enabled+Indeterminate].foregroundPainter",
      new AbstractRegionPainter() {
  // ...
  private final PaintContext ctx = new PaintContext(
      new Insets(5, 5, 5, 5), new Dimension(29, 19), false);
  @Override public void doPaint(
        Graphics2D g, JComponent c, int width, int height,
        Object[] extendedCacheKeys) {
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
  // ...
});
progress = new JProgressBar(model);
progress.putClientProperty("Nimbus.Overrides", d);
</code></pre>

## 解説
上記のサンプルでは、`NimbusLookAndFeel`で`JProgressBar`の不確定状態を表現するアニメーションを変更するために、セルの描画を行う`AbstractRegionPainter#doPaint(...)`をオーバーライドした`Painter`を作成し、これを`UIDefaults`に設定しています。

`AbstractRegionPainter#doPaint(...)`の中身は`ProgressBarPainter#paintForegroundEnabled(...)`と同等ですが、このメソッドや関連する`ProgressBarPainter#decodePath1()`などのメソッドは`protected`ではなくすべて`private`のため、コピーすることで対応しています。

## 参考リンク
- [JProgressBarの不確定状態でのアニメーションパターンを変更する](https://ateraimemo.com/Swing/StripedProgressBar.html)

<!-- dummy comment line for breaking list -->

## コメント
