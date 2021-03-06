---
layout: post
category: swing
folder: StripedProgressBar
title: JProgressBarの不確定状態でのアニメーションパターンを変更する
tags: [JProgressBar, Animation]
author: aterai
pubdate: 2014-07-14T00:19:43+09:00
description: JProgressBarが不確定状態の場合に描画するアニメーションパターンを変更します。
image: https://lh5.googleusercontent.com/-NNzCJkyUG1U/U8KcWq3YRjI/AAAAAAAACJg/tB7jz0r9Frg/s800/StripedProgressBar.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2015/08/change-indeterminate-jprogressbar.html
    lang: en
comments: true
---
## 概要
`JProgressBar`が不確定状態の場合に描画するアニメーションパターンを変更します。

{% download https://lh5.googleusercontent.com/-NNzCJkyUG1U/U8KcWq3YRjI/AAAAAAAACJg/tB7jz0r9Frg/s800/StripedProgressBar.png %}

## サンプルコード
<pre class="prettyprint"><code>class StripedProgressBarUI extends BasicProgressBarUI {
  private final boolean dir;
  private final boolean slope;
  public StripedProgressBarUI(boolean dir, boolean slope) {
    super();
    this.dir = dir;
    this.slope = slope;
  }

  @Override protected int getBoxLength(
        int availableLength, int otherDimension) {
    return availableLength; // (int) Math.round(availableLength / 6d);
  }

  @Override public void paintIndeterminate(Graphics g, JComponent c) {
    if (!(g instanceof Graphics2D)) {
      return;
    }

    Insets b = progressBar.getInsets(); // area for border
    int barRectWidth  = progressBar.getWidth() - b.right - b.left;
    int barRectHeight = progressBar.getHeight() - b.top - b.bottom;

    if (barRectWidth &lt;= 0 || barRectHeight &lt;= 0) {
      return;
    }

    Graphics2D g2 = (Graphics2D) g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);

    // Paint the striped box.
    boxRect = getBox(boxRect);
    if (boxRect != null) {
      int w = 10;
      int x = getAnimationIndex();
      GeneralPath p = new GeneralPath();
      if (dir) {
        p.moveTo(boxRect.x,           boxRect.y);
        p.lineTo(boxRect.x + w * .5f, boxRect.y + boxRect.height);
        p.lineTo(boxRect.x + w,       boxRect.y + boxRect.height);
        p.lineTo(boxRect.x + w * .5f, boxRect.y);
      } else {
        p.moveTo(boxRect.x,           boxRect.y + boxRect.height);
        p.lineTo(boxRect.x + w * .5f, boxRect.y + boxRect.height);
        p.lineTo(boxRect.x + w,       boxRect.y);
        p.lineTo(boxRect.x + w * .5f, boxRect.y);
      }
      p.closePath();
      g2.setColor(progressBar.getForeground());
      if (slope) {
        for (int i = boxRect.width + x; i &gt; -w; i -= w) {
          g2.fill(AffineTransform.getTranslateInstance(i, 0)
                                 .createTransformedShape(p));
        }
      } else {
        for (int i = -x; i &lt; boxRect.width; i += w) {
          g2.fill(AffineTransform.getTranslateInstance(i, 0)
                                 .createTransformedShape(p));
        }
      }
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`BasicProgressBarUI#paintIndeterminate(...)`メソッドをオーバーライドした`ProgressBarUI`を設定して、不確定状態で描画されるアニメーションのパターンをストライプ模様に変更しています。

- デフォルトの不確定状態アニメーションは`JProgressBar`の内部をボックスが左右(縦の場合は上下)に移動するパターン
- `JProgressBar`全体をストライプで描画するため`BasicProgressBarUI#getBoxLength()`も`JProgressBar`自体の長さを返すようにオーバーライド

<!-- dummy comment line for breaking list -->

- - - -
アニメーションのスピードなどは[JProgressBarの不確定進捗サイクル時間を設定](https://ateraimemo.com/Swing/IndeterminateCycleTime.html)と同様に`UIManager.put(...)`を使って調整しています。

<pre class="prettyprint"><code>UIManager.put("ProgressBar.cycleTime", 1000);
UIManager.put("ProgressBar.repaintInterval", 10);
</code></pre>

## 参考リンク
- [JProgressBarのNimbusLookAndFeelにおける不確定状態アニメーションを変更する](https://ateraimemo.com/Swing/IndeterminateRegionPainter.html)
- [JProgressBarの不確定進捗サイクル時間を設定](https://ateraimemo.com/Swing/IndeterminateCycleTime.html)

<!-- dummy comment line for breaking list -->

## コメント
