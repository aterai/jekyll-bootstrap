---
layout: post
title: JProgressBarの進捗状況を円形で表示する
category: swing
folder: ProgressCircle
tags: [JProgressBar, SwingWorker]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-06-02

## JProgressBarの進捗状況を円形で表示する
`JProgressBar`の進捗状況を円形表示するように設定します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/-K2Us5zyEGJs/U4rt4SgHxVI/AAAAAAAACGo/IBfgQ2C1jxE/s800/ProgressCircle.png)

### サンプルコード
<pre class="prettyprint"><code>class ProgressCircleUI extends BasicProgressBarUI {
  @Override public Dimension getPreferredSize(JComponent c) {
    Dimension d = super.getPreferredSize(c);
    int v = Math.max(d.width, d.height);
    d.setSize(v, v);
    return d;
  }
  @Override public void paint(Graphics g, JComponent c) {
    Insets b = progressBar.getInsets(); // area for border
    int barRectWidth  = progressBar.getWidth()  - b.right - b.left;
    int barRectHeight = progressBar.getHeight() - b.top - b.bottom;
    if (barRectWidth &lt;= 0 || barRectHeight &lt;= 0) {
      return;
    }

    // draw the cells
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    double degree = 360 * progressBar.getPercentComplete();
    double sz = Math.min(barRectWidth, barRectHeight);
    double cx = b.left + barRectWidth  * .5;
    double cy = b.top  + barRectHeight * .5;
    double or = sz * .5;
    double ir = or * .5; //or - 20;
    Shape inner  = new Ellipse2D.Double(cx - ir, cy - ir, ir * 2, ir * 2);
    Shape outer  = new Ellipse2D.Double(cx - or, cy - or, sz, sz);
    Shape sector = new Arc2D.Double(
        cx - or, cy - or, sz, sz, 90 - degree, degree, Arc2D.PIE);

    Area foreground = new Area(sector);
    Area background = new Area(outer);
    Area hole = new Area(inner);

    foreground.subtract(hole);
    background.subtract(hole);

    g2.setPaint(new Color(0xDDDDDD));
    g2.fill(background);

    g2.setPaint(progressBar.getForeground());
    g2.fill(foreground);
    g2.dispose();

    // Deal with possible text painting
    if (progressBar.isStringPainted()) {
      paintString(g, b.left, b.top, barRectWidth, barRectHeight, 0, b);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`BasicProgressBarUI#paint(Graphics g, JComponent c)`をオーバーライドして進捗状況を円形で表現する`ProgressBarUI`を作成し、`JProgressBar`に設定しています。

- 注:
    - 表示上、中心から表示枠矩形の上辺中央を結ぶ線が弧の始角で、増加は時計回り方向に見えるよう`Arc2D`を作成
    - 推奨サイズが常に正方形になるように、`BasicProgressBarUI#getPreferredSize(JComponent c)`をオーバーライドしているので、方向(`SwingConstants.VERTICAL`,`SwingConstants.HORIZONTAL`)は無視される
    - 不確定状態の描画(`BasicProgressBarUI#paintDeterminate(...)`,`BasicProgressBarUI#paintIndeterminate(...)`はオーバーライドしていない)は未対応

<!-- dummy comment line for breaking list -->

### 参考リンク
- [OverlayLayoutで複数のJButtonを重ねて複合ボタンを作成](http://terai.xrea.jp/Swing/CompoundButton.html)
- [JProgressBarにUIを設定してインジケータの色を変更](http://terai.xrea.jp/Swing/GradientPalletProgressBar.html)

<!-- dummy comment line for breaking list -->

### コメント