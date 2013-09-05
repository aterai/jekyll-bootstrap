---
layout: post
title: Timerでアニメーションするアイコンを作成
category: swing
folder: AnimeIcon
tags: [Timer, Animation, Icon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-03-13

## Timerでアニメーションするアイコンを作成
`javax.swing.Timer`を使って、アニメーションするアイコンを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTHuI0XeDI/AAAAAAAAARo/CVs615Dtkqs/s800/AnimeIcon.png)

### サンプルコード
<pre class="prettyprint"><code>class AnimatedLabel extends JLabel implements ActionListener {
  private final javax.swing.Timer animator;
  private final AnimeIcon icon = new AnimeIcon();
  public AnimatedLabel() {
    super();
    animator = new javax.swing.Timer(100, this);
    setIcon(icon);
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
class AnimeIcon implements Icon {
  private static final Color cColor = new Color(0.5f,0.5f,0.5f);
  private final List&lt;Shape&gt; list = new ArrayList&lt;Shape&gt;();
  private final Dimension dim;
  private boolean isRunning = false;
  public AnimeIcon() {
    super();
    double r  = 2.0d;
    double sx = 1.0d;
    double sy = 1.0d;
    list.add(new Ellipse2D.Double(sx+3*r, sy+0*r, 2*r, 2*r));
    list.add(new Ellipse2D.Double(sx+5*r, sy+1*r, 2*r, 2*r));
    list.add(new Ellipse2D.Double(sx+6*r, sy+3*r, 2*r, 2*r));
    list.add(new Ellipse2D.Double(sx+5*r, sy+5*r, 2*r, 2*r));
    list.add(new Ellipse2D.Double(sx+3*r, sy+6*r, 2*r, 2*r));
    list.add(new Ellipse2D.Double(sx+1*r, sy+5*r, 2*r, 2*r));
    list.add(new Ellipse2D.Double(sx+0*r, sy+3*r, 2*r, 2*r));
    list.add(new Ellipse2D.Double(sx+1*r, sy+1*r, 2*r, 2*r));
    dim = new Dimension((int)(r*8+sx*2), (int)(r*8+sy*2));
  }
  @Override public int getIconWidth() {
    return dim.width;
  }
  @Override public int getIconHeight() {
    return dim.height;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2d = (Graphics2D) g;
    g2d.setPaint((c!=null)?c.getBackground():Color.WHITE);
    g2d.fillRect(x, y, getIconWidth(), getIconHeight());
    g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                         RenderingHints.VALUE_ANTIALIAS_ON);
    g2d.setColor(cColor);
    float alpha = 0.0f;
    g2d.translate(x, y);
    for(Shape s: list) {
      alpha = isRunning?alpha+0.1f:0.5f;
      g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, alpha));
      g2d.fill(s);
    }
    g2d.translate(-x, -y);
  }
  public void next() {
    if(isRunning) list.add(list.remove(0));
  }
  public void setRunning(boolean isRunning) {
    this.isRunning = isRunning;
  }
}
</code></pre>

### 解説
上記のサンプルでは、スタートボタンを押すと(`JTextArea`に表示している作業状況はダミーで、実際は`Thread.sleep()`で時間を稼いでいるだけ)アイコンが`FireFox`風にアニメーションします。

アニメーションは、`8`個の円からアイコンを生成して、それぞれのインデックスを順に変更することで行っています。

- アイコンの生成
    - リスト(`Vector`)に、座標の異なる円(`Ellipse2D.Double`)を`8`個生成して追加します。
- インデックスの変更
    - `Timer`を使って、リストの先頭にある円を最後に移動します。
- 異なるアルファ値で円を描画
    - インデックスに応じたアルファ値でそれぞれの円を描画します。

<!-- dummy comment line for breaking list -->

円がいびつだったので、アンチエイリアスをかけていまが、`Java 1.6.0`では「小さな円(曲線)が円に見えなかった問題」が解消されているようです([参考](http://www.02.246.ne.jp/~torutk/jvm/mustang.html#SEC26))。

- - - -
一々自分で座標を計算して`new Ellipse2D`を`8`個も並べるのが嫌だったり、もうすこし正確に円を配置したい場合は、`AffineTransform`などを使ってアイコンを生成する方法もあります。

<pre class="prettyprint"><code>class AnimeIcon implements Icon {
  private static final Color cColor = new Color(0.5f,0.8f,0.5f);
  //private final Vector&lt;Shape&gt; list = new Vector&lt;Shape&gt;();
  private final List&lt;Shape&gt; list = new ArrayList&lt;Shape&gt;();
  private final Dimension dim;
  private boolean isRunning = false;
  //int rotate = 45;
  public AnimeIcon() {
    super();
    int r = 4;
    Shape s = new Ellipse2D.Float(0, 0, 2*r, 2*r);
    for(int i=0;i&lt;8;i++) {
      AffineTransform at = AffineTransform.getRotateInstance(i*2*Math.PI/8);
      at.concatenate(AffineTransform.getTranslateInstance(r, r));
      list.add(at.createTransformedShape(s));
    }
    //int d = (int)(r*2*(1+2*Math.sqrt(2)));
    int d = (int)r*2*(1+3); // 2*Math.sqrt(2) is nearly equal to 3.
    dim = new Dimension(d, d);
  }
  @Override public int getIconWidth() {
    return dim.width;
  }
  @Override public int getIconHeight() {
    return dim.height;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2d = (Graphics2D) g;
    g2d.setPaint((c!=null)?c.getBackground():Color.WHITE);
    g2d.fillRect(x, y, getIconWidth(), getIconHeight());
    g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    g2d.setColor(cColor);
    float alpha = 0.0f;
    int xx = x + dim.width/2;
    int yy = y + dim.height/2;
    //AffineTransform at = AffineTransform.getRotateInstance(Math.toRadians(rotate), xx, yy);
    //at.concatenate(AffineTransform.getTranslateInstance(xx, yy));
    g2d.translate(xx, yy);
    for(Shape s: list) {
      alpha = isRunning?alpha+0.1f:0.5f;
      g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, alpha));
      //g2d.fill(at.createTransformedShape(s));
      g2d.fill(s);
    }
  }
  public void next() {
    if(isRunning) {
      list.add(list.remove(0));
      //rotate = rotate&lt;360?rotate+45:45;
    }
  }
  public void setRunning(boolean isRunning) {
    this.isRunning = isRunning;
  }
}
</code></pre>

### コメント
- 色の濃い円が時計回りに回転するように変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-15 (水) 11:12:08
- ロードインジケータと呼ぶらしい。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-07-11 (水) 23:49:44
- ~~このサンプルでは、`Swing Tutorial`にあった古い`SwingWorker`を使用しているけど、~~ [Swingworker — Java.net](http://java.net/projects/swingworker) にある`JDK 1.6`からバックポートされた`org.jdesktop.swingworker.SwingWorker`を使用 ~~したほうがいいかも。そのうち修正する予定~~ するように変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-12-17 (木) 01:44:29

<!-- dummy comment line for breaking list -->
