---
layout: post
title: GlassPaneで画像をLightbox風に表示
category: swing
folder: LightboxLikeDisplay
tags: [GlassPane, JFrame, Animation, ImageIcon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-12-08

## GlassPaneで画像をLightbox風に表示
`GlassPane`を使用して、`Lightbox`風にアニメーションしながら画像を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTPJaQROVI/AAAAAAAAAdg/MXDWfchqmso/s800/LightboxLikeDisplay.png)

### サンプルコード
<pre class="prettyprint"><code>class LightboxGlassPane extends JComponent {
  private final ImageIcon image;
  private final AnimeIcon animatedIcon = new AnimeIcon();
  private float alpha = 0.0f;
  private int w = 0;
  private int h = 0;
  private Rectangle rect = new Rectangle();
  private javax.swing.Timer animator;
  public LightboxGlassPane() {
    setOpaque(false);
    super.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
    image = new ImageIcon(getClass().getResource("test.png"));
    addMouseListener(new MouseAdapter() {
      @Override public void mouseClicked(MouseEvent me) {
        setVisible(false);
      }
    });
  }
  @Override public void setVisible(boolean isVisible) {
    boolean oldVisible = isVisible();
    super.setVisible(isVisible);
    JRootPane rootPane = SwingUtilities.getRootPane(this);
    if(rootPane!=null &amp;&amp; isVisible()!=oldVisible) {
      rootPane.getLayeredPane().setVisible(!isVisible);
    }
    if(isVisible &amp;&amp; (animator==null || !animator.isRunning())) {
      w = 40;
      h = 40;
      alpha = 0.0f;
      animator = new javax.swing.Timer(10, new ActionListener() {
        @Override public void actionPerformed(ActionEvent e) {
          animatedIcon.next();
          repaint();
        }
      });
      animator.start();
    }else{
      if(animator!=null) animator.stop();
    }
    animatedIcon.setRunning(isVisible);
  }
  @Override public void paintComponent(Graphics g) {
    JRootPane rootPane = SwingUtilities.getRootPane(this);
    if(rootPane!=null) {
      rootPane.getLayeredPane().print(g);
    }
    super.paintComponent(g);
    Graphics2D g2d = (Graphics2D)g;

    if(h&lt;image.getIconHeight()+5+5) {
      h += image.getIconHeight()/16;
    }else if(w&lt;image.getIconWidth()+5+5) {
      h  = image.getIconHeight()+5+5;
      w += image.getIconWidth()/16;
    }else if(alpha&lt;1.0) {
      w  = image.getIconWidth()+5+5;
      alpha = alpha + 0.1f;
    }else{
      animatedIcon.setRunning(false);
      animator.stop();
    }
    rect.setSize(w, h);
    Rectangle screen = getBounds();
    rect.setLocation(screen.x + screen.width/2  - rect.width/2,
             screen.y + screen.height/2 - rect.height/2);

    g2d.setColor(new Color(100,100,100,100));
    g2d.fill(screen);
    g2d.setColor(new Color(255,255,255,200));
    g2d.fill(rect);

    if(alpha&gt;0) {
      if(alpha&gt;1.0f) alpha = 1.0f;
      g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, alpha));
      g2d.drawImage(image.getImage(), rect.x+5, rect.y+5,
              image.getIconWidth(),
              image.getIconHeight(), this);
    }else{
      animatedIcon.paintIcon(this, g2d,
                   screen.x + screen.width/2  - animatedIcon.getIconWidth()/2,
                   screen.y + screen.height/2 - animatedIcon.getIconHeight()/2);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JFrame`に`GlassPane`を設定して、この`GlassPane`の中央にインジケータ、高さ幅がアニメーションしながら拡大する矩形、画像を順番に表示しています。

`GlassPane`に自分を`setVisible(false)`するマウスリスナーを追加しているので、任意の場所をクリックするとこの画像は非表示になります。

### 参考リンク
- [Lightbox 2](http://www.huddletogether.com/projects/lightbox2/)

<!-- dummy comment line for breaking list -->

### コメント