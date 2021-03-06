---
layout: post
category: swing
folder: LightboxLikeDisplay
title: GlassPaneで画像をLightbox風に表示
tags: [GlassPane, JFrame, Animation, ImageIcon]
author: aterai
pubdate: 2008-12-08T13:07:38+09:00
description: GlassPaneを使用して、Lightbox風にアニメーションしながら画像を表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPJaQROVI/AAAAAAAAAdg/MXDWfchqmso/s800/LightboxLikeDisplay.png
comments: true
---
## 概要
`GlassPane`を使用して、`Lightbox`風にアニメーションしながら画像を表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPJaQROVI/AAAAAAAAAdg/MXDWfchqmso/s800/LightboxLikeDisplay.png %}

## サンプルコード
<pre class="prettyprint"><code>class LightboxGlassPane extends JPanel {
  private final ImageIcon image = new ImageIcon(
      LightboxGlassPane.class.getResource("test.png"));
  private final AnimeIcon animatedIcon = new AnimeIcon();
  private float alpha;
  private int w;
  private int h;
  private final Rectangle rect = new Rectangle();
  private Timer animator;
  private Handler handler;

  @Override public void updateUI() {
    removeMouseListener(handler);
    removeHierarchyListener(handler);
    super.updateUI();
    setOpaque(false);
    super.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
    if (handler == null) {
      handler = new Handler();
    }
    addMouseListener(handler);
    addHierarchyListener(handler);
  }
  private class Handler extends MouseAdapter implements HierarchyListener {
    @Override public void mouseClicked(MouseEvent me) {
      me.getComponent().setVisible(false);
    }

    @Override public void hierarchyChanged(HierarchyEvent e) {
      if ((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0
          &amp;&amp; !e.getComponent().isDisplayable() &amp;&amp; animator != null) {
        animator.stop();
      }
    }
  }

  @Override public void setVisible(boolean isVisible) {
    boolean oldVisible = isVisible();
    super.setVisible(isVisible);
    JRootPane rootPane = getRootPane();
    if (rootPane != null &amp;&amp; isVisible() != oldVisible) {
      rootPane.getLayeredPane().setVisible(!isVisible);
    }
    boolean b = animator == null || !animator.isRunning();
    if (isVisible &amp;&amp; b) {
      w = 40;
      h = 40;
      alpha = 0f;
      animator = new Timer(10, new ActionListener() {
        @Override public void actionPerformed(ActionEvent e) {
          animatedIcon.next();
          repaint();
        }
      });
      animator.start();
    } else {
      if (animator != null) {
        animator.stop();
      }
    }
    animatedIcon.setRunning(isVisible);
  }

  @Override protected void paintComponent(Graphics g) {
    JRootPane rootPane = getRootPane();
    if (rootPane != null) {
      rootPane.getLayeredPane().print(g);
    }
    super.paintComponent(g);
    Graphics2D g2d = (Graphics2D) g.create();

    if (h &lt; image.getIconHeight() + 5 + 5) {
      h += image.getIconHeight() / 16;
    } else if (w &lt; image.getIconWidth() + 5 + 5) {
      h  = image.getIconHeight() + 5 + 5;
      w += image.getIconWidth() / 16;
    } else if (alpha &lt; 1f) {
      w  = image.getIconWidth() + 5 + 5;
      alpha = alpha + .1f;
    } else {
      animatedIcon.setRunning(false);
      animator.stop();
    }
    rect.setSize(w, h);
    Rectangle screen = getBounds();
    rect.setLocation(screen.x + screen.width / 2  - rect.width / 2,
                     screen.y + screen.height / 2 - rect.height / 2);

    g2d.setColor(new Color(100, 100, 100, 100));
    g2d.fill(screen);
    g2d.setColor(new Color(255, 255, 255, 200));
    g2d.fill(rect);

    if (alpha &gt; 0) {
      if (alpha &gt; 1f) {
        alpha = 1f;
      }
      g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, alpha));
      g2d.drawImage(image.getImage(), rect.x + 5, rect.y + 5,
                    image.getIconWidth(),
                    image.getIconHeight(), this);
    } else {
      animatedIcon.paintIcon(
          this, g2d,
          screen.x + screen.width / 2  - animatedIcon.getIconWidth() / 2,
          screen.y + screen.height / 2 - animatedIcon.getIconHeight() / 2);
    }
    g2d.dispose();
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JFrame`に`GlassPane`を設定して、この`GlassPane`の中央にインジケータ、高さ幅がアニメーションしながら拡大する矩形、画像を順番に表示しています。

`GlassPane`に自分を`setVisible(false)`するマウスリスナーを追加しているので、任意の場所をクリックするとこの画像は非表示になります。

## 参考リンク
- [JFrameをスクリーン中央に表示](https://ateraimemo.com/Swing/CenterFrame.html)

<!-- dummy comment line for breaking list -->

## コメント
