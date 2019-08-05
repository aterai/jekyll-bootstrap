---
layout: post
category: swing
folder: IndeterminateAnimation
title: JProgressBarの不確定モードアニメーションを一方向に変更する
tags: [JProgressBar, Animation, LookAndFeel]
author: aterai
pubdate: 2018-12-31T17:42:54+09:00
description: MetalLookAndFeelを適用したJProgressBarの不確定モードアニメーションを跳ね返りではなく左から右への一方向繰り返しに変更します。
image: https://drive.google.com/uc?id=18dq3XCJzHrT69mJQQafMAz808GvXj2vTPQ
comments: true
---
## 概要
`MetalLookAndFeel`を適用した`JProgressBar`の不確定モードアニメーションを跳ね返りではなく左から右への一方向繰り返しに変更します。

{% download https://drive.google.com/uc?id=18dq3XCJzHrT69mJQQafMAz808GvXj2vTPQ %}

## サンプルコード
<pre class="prettyprint"><code>class OneDirectionIndeterminateProgressBarUI extends BasicProgressBarUI {
  // @see com/sun/java/swing/plaf/windows/WindowsProgressBarUI.java
  @Override protected Rectangle getBox(Rectangle r) {
    Rectangle rect = super.getBox(r);
    int framecount = getFrameCount() / 2;
    int currentFrame = getAnimationIndex() % framecount;

    if (progressBar.getOrientation() == JProgressBar.VERTICAL) {
      int len = progressBar.getHeight();
      len += rect.height * 2; // add 2x for the trails
      double delta = len / (double) framecount;
      rect.y = (int) (delta * currentFrame);
    } else {
      int len = progressBar.getWidth();
      len += rect.width * 2; // add 2x for the trails
      double delta = len / (double) framecount;
      rect.x = (int) (delta * currentFrame);
    }
    return rect;
  }
}
</code></pre>

## 解説
- 上: デフォルト
    - `BasicLookAndFeel`や`MetalLookAndFeel`の不確定モードは矩形が左右に行ったり来たりするアニメーションがデフォルト
- 下: `Windows`風
    - `Windows`環境での不確定モードは矩形が左から右への一方向を繰り返すアニメーションがデフォルト
    - `WindowsProgressBarUI`の`getBox(...)`メソッドを参考に`BasicProgressBarUI#getBox(...)`メソッドをオーバーライド
        - フレーム数を半分にして、「行き」分だけアニメーションを表示する
    - 注: 元の`WindowsProgressBarUI`でも、`JProgressBar#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`を設定しても不確定モードのアニメーションは右から左へには変化しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Java swing indeterminate JProgressBar starting from the left when reaching end instead of bouncing - Stack Overflow](https://stackoverflow.com/questions/53957264/java-swing-indeterminate-jprogressbar-starting-from-the-left-when-reaching-end-i)
- [JProgressBarの不確定状態でのアニメーションパターンを変更する](https://ateraimemo.com/Swing/StripedProgressBar.html)
    - `JProgressBar`全体が不確定モードでアニメーションするよう変更するサンプル
- [JProgressBarのNimbusLookAndFeelにおける不確定状態アニメーションを変更する](https://ateraimemo.com/Swing/IndeterminateRegionPainter.html)
    - `NimbusLookAndFeel`で不確定モードのアニメーションを変更するサンプル
- [JProgressBarの進捗方向を右から左に変更する](https://ateraimemo.com/Swing/InvertedProgressBar.html)

<!-- dummy comment line for breaking list -->

## コメント
