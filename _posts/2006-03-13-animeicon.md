---
layout: post
category: swing
folder: AnimeIcon
title: Timerでアニメーションするアイコンを作成
tags: [Timer, Animation, Icon]
author: aterai
pubdate: 2006-03-13T00:29:10+09:00
description: javax.swing.Timerを使って、アニメーションするアイコンを作成します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTHuI0XeDI/AAAAAAAAARo/CVs615Dtkqs/s800/AnimeIcon.png
comments: true
---
## 概要
`javax.swing.Timer`を使って、アニメーションするアイコンを作成します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTHuI0XeDI/AAAAAAAAARo/CVs615Dtkqs/s800/AnimeIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>class AnimatedLabel extends JLabel implements ActionListener {
  private final Timer animator;
  private final AnimeIcon icon = new AnimeIcon();
  public AnimatedLabel() {
    super();
    animator = new Timer(100, this);
    setIcon(icon);
    addHierarchyListener(new HierarchyListener() {
      @Override public void hierarchyChanged(HierarchyEvent e) {
        if ((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0
            &amp;&amp; !e.getComponent().isDisplayable()) {
          stopAnimation();
        }
      }
    });
  }
  @Override public void actionPerformed(ActionEvent e) {
    icon.next();
    repaint();
  }
  public void startAnimation() {
    icon.setRunning(true);
    animator.start();
  }
  public void stopAnimation() {
    icon.setRunning(false);
    animator.stop();
  }
}

class AnimeIcon implements Icon, Serializable {
  private static final long serialVersionUID = 1L;
  private static final Color ELLIPSE_COLOR = new Color(.5f, .5f, .5f);
  private static final double R  = 2d;
  private static final double SX = 1d;
  private static final double SY = 1d;
  private static final int WIDTH  = (int) (R * 8 + SX * 2);
  private static final int HEIGHT = (int) (R * 8 + SY * 2);
  private final List&lt;Shape&gt; list = new ArrayList&lt;Shape&gt;(Arrays.asList(
        new Ellipse2D.Double(SX + 3 * R, SY + 0 * R, 2 * R, 2 * R),
        new Ellipse2D.Double(SX + 5 * R, SY + 1 * R, 2 * R, 2 * R),
        new Ellipse2D.Double(SX + 6 * R, SY + 3 * R, 2 * R, 2 * R),
        new Ellipse2D.Double(SX + 5 * R, SY + 5 * R, 2 * R, 2 * R),
        new Ellipse2D.Double(SX + 3 * R, SY + 6 * R, 2 * R, 2 * R),
        new Ellipse2D.Double(SX + 1 * R, SY + 5 * R, 2 * R, 2 * R),
        new Ellipse2D.Double(SX + 0 * R, SY + 3 * R, 2 * R, 2 * R),
        new Ellipse2D.Double(SX + 1 * R, SY + 1 * R, 2 * R, 2 * R)));

  private boolean isRunning;
  public void next() {
    if (isRunning) {
      list.add(list.remove(0));
    }
  }
  public void setRunning(boolean isRunning) {
    this.isRunning = isRunning;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setPaint(c == null ? Color.WHITE : c.getBackground());
    g2.fillRect(x, y, getIconWidth(), getIconHeight());
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setColor(ELLIPSE_COLOR);
    g2.translate(x, y);
    int size = list.size();
    for (int i = 0; i &lt; size; i++) {
      float alpha = isRunning ? (i + 1) / (float) size : .5f;
      g2.setComposite(AlphaComposite.getInstance(
          AlphaComposite.SRC_OVER, alpha));
      g2.fill(list.get(i));
    }
    // g2.translate(-x, -y);
    g2.dispose();
  }
  @Override public int getIconWidth() {
    return WIDTH;
  }
  @Override public int getIconHeight() {
    return HEIGHT;
  }
}
</code></pre>

## 解説
上記のサンプルでは、スタートボタンを押すと(`JTextArea`に表示している作業状況はダミーで、実際は`Thread.sleep()`で時間を稼いでいるだけ)アイコンが`FireFox`風にアニメーションします。

アニメーションは、`8`個の小さな円からアイコンを生成して、それぞれのインデックスを順に変更することで行っています。

- アイコンの生成
    - リスト(`ArrayList`)に、座標の異なる円(`Ellipse2D.Double`)を`8`個生成して追加
- インデックスの変更
    - `Timer`を使って、リストの先頭にある円を最後に移動
- 異なるアルファ値で円を描画
    - インデックスに応じたアルファ値でそれぞれの円を描画
    - `Java 1.6.0`では「小さな円(曲線)が円に見えなかった問題」が解消されている([参考](http://www.02.246.ne.jp/~torutk/jvm/mustang.html#SEC26))

<!-- dummy comment line for breaking list -->

- - - -
一々自分で座標を計算して`new Ellipse2D`を`8`個も並べるのを避けたい、またはもうすこし正確に円を配置したい場合は、`AffineTransform`などを使ってアイコンを生成する方法もあります。

<pre class="prettyprint"><code>class AnimeIcon2 implements Icon, Serializable {
  private static final long serialVersionUID = 1L;
  private static final Color ELLIPSE_COLOR = new Color(.5f, .8f, .5f);
  private final List&lt;Shape&gt; list = new ArrayList&lt;&gt;();
  private final Dimension dim;
  private boolean isRunning;
  public AnimeIcon2() {
    super();
    int r = 4;
    Shape s = new Ellipse2D.Float(0, 0, 2 * r, 2 * r);
    for (int i = 0; i &lt; 8; i++) {
      AffineTransform at = AffineTransform.getRotateInstance(
          i * 2 * Math.PI / 8);
      at.concatenate(AffineTransform.getTranslateInstance(r, r));
      list.add(at.createTransformedShape(s));
    }
    //int d = (int) (r * 2*(1 + 2 * Math.sqrt(2)));
    int d = (int) r * 2 * (1 + 3); // 2 * Math.sqrt(2) is nearly equal to 3.
    dim = new Dimension(d, d);
  }
  @Override public int getIconWidth() {
    return dim.width;
  }
  @Override public int getIconHeight() {
    return dim.height;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setPaint(c == null ? Color.WHITE : c.getBackground());
    g2.fillRect(x, y, getIconWidth(), getIconHeight());
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setColor(ELLIPSE_COLOR);
    int xx = x + dim.width / 2;
    int yy = y + dim.height / 2;
    g2.translate(xx, yy);
    int size = list.size();
    for (int i = 0; i &lt; size; i++) {
      float alpha = isRunning ? (i + 1) / (float) size : .5f;
      g2.setComposite(AlphaComposite.getInstance(
          AlphaComposite.SRC_OVER, alpha));
      g2.fill(list.get(i));
    }
    //g2.translate(-xx, -yy);
    g2.dispose();
  }
  public void next() {
    if (isRunning) {
      list.add(list.remove(0));
    }
  }
  public void setRunning(boolean isRunning) {
    this.isRunning = isRunning;
  }
}
</code></pre>

## 参考リンク
- [Icon (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/Icon.html)

<!-- dummy comment line for breaking list -->

## コメント
- 色の濃い円が時計回りに回転するように変更しました。 -- *aterai* 2006-03-15 (水) 11:12:08
- ロードインジケータと呼ぶらしい。 -- *aterai* 2007-07-11 (水) 23:49:44
- ~~このサンプルでは、`Swing Tutorial`に存在した古い`SwingWorker`を使用しているが、~~ [Swingworker — Java.net](http://java.net/projects/swingworker) にある`JDK 1.6`からバックポートされた`org.jdesktop.swingworker.SwingWorker`を使用 ~~したほうが良さそう。そのうち修正する予定。~~ 変更修正済。 -- *aterai* 2009-12-17 (木) 01:44:29

<!-- dummy comment line for breaking list -->
