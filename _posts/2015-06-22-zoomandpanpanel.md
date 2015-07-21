---
layout: post
category: swing
folder: ZoomAndPanPanel
title: JScrollPane内に配置したJPanelをマウスで拡大、縮小、移動する
tags: [JScrollPane, JPanel, AffineTransform, Image, WheelListener]
author: aterai
pubdate: 2015-06-22T10:03:20+09:00
description: JScrollPane内に配置したJPanelを、マウスホイールを使った拡大縮小と、スクロールバーを使った表示領域の移動が可能になるように設定します。
hreflang:
    href: http://java-swing-tips.blogspot.com/2015/06/an-image-inside-jscrollpane-zooming-by.html
    lang: en
comments: true
---
## 概要
`JScrollPane`内に配置した`JPanel`を、マウスホイールを使った拡大縮小と、スクロールバーを使った表示領域の移動が可能になるように設定します。

{% download https://lh3.googleusercontent.com/-Um9j8O0t3Kg/VYdMPIUOfwI/AAAAAAAAN7A/LAJ5KRiDdp0/s800/ZoomAndPanPanel.png %}

## サンプルコード
<pre class="prettyprint"><code>class ZoomAndPanePanel extends JPanel {
  private final AffineTransform coordTransform = new AffineTransform();
  private final transient Image img;
  private final Rectangle imgrect;
  private transient ZoomHandler handler;
  private transient DragScrollListener listener;

  public ZoomAndPanePanel(Image img) {
    super();
    this.img = img;
    this.imgrect = new Rectangle(img.getWidth(null), img.getHeight(null));
  }
  @Override public void paintComponent(Graphics g) {
    super.paintComponent(g);
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setPaint(new Color(0x55FF0000, true));
    Rectangle r = new Rectangle(500, 140, 150, 150);

    //AffineTransform at = g2.getTransform();
    //at.concatenate(coordTransform);
    //g2.setTransform(at);
    //g2.drawImage(img, 0, 0, this);
    //g2.fill(r);

    //g2.drawRenderedImage((java.awt.image.RenderedImage) img, coordTransform);
    g2.drawImage(img, coordTransform, this);
    g2.fill(coordTransform.createTransformedShape(r));

    //XXX
    //g2.setTransform(coordTransform);
    //g2.drawImage(img, 0, 0, this);

    g2.dispose();
  }
  @Override public Dimension getPreferredSize() {
    Rectangle r = coordTransform.createTransformedShape(imgrect).getBounds();
    return new Dimension(r.width, r.height);
  }
  @Override public void updateUI() {
    removeMouseListener(listener);
    removeMouseMotionListener(listener);
    removeMouseWheelListener(handler);
    super.updateUI();
    listener = new DragScrollListener();
    addMouseListener(listener);
    addMouseMotionListener(listener);
    handler = new ZoomHandler();
    addMouseWheelListener(handler);
  }

  protected class ZoomHandler extends MouseAdapter {
    private static final int MIN_ZOOM = -9;
    private static final int MAX_ZOOM = 16;
    private static final int EXTENT = 1;
    private final BoundedRangeModel zoomRange = new DefaultBoundedRangeModel(
        0, EXTENT, MIN_ZOOM, MAX_ZOOM + EXTENT);
    @Override public void mouseWheelMoved(MouseWheelEvent e) {
      int dir = e.getWheelRotation();
      int z = zoomRange.getValue();
      zoomRange.setValue(z + EXTENT * (dir &gt; 0 ? -1 : 1));
      if (z != zoomRange.getValue()) {
        Component c = e.getComponent();
        Container p = SwingUtilities.getAncestorOfClass(JViewport.class, c);
        if (p instanceof JViewport) {
          JViewport vport = (JViewport) p;
          Rectangle ovr = vport.getViewRect();
          double s = dir &gt; 0 ? 1d / 1.2 : 1.2;
          coordTransform.scale(s, s);
          //double s = 1d + zoomRange.getValue() * .1;
          //coordTransform.setToScale(s, s);
          AffineTransform at = AffineTransform.getScaleInstance(s, s);
          Rectangle nvr = at.createTransformedShape(ovr).getBounds();
          Point vp = nvr.getLocation();
          vp.translate((nvr.width - ovr.width) / 2,
                       (nvr.height - ovr.height) / 2);
          vport.setViewPosition(vp);
          c.revalidate();
          c.repaint();
        }
      }
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JPanel#getPreferredSize()`を拡大後の画像サイズを返すようにオーバーライドすることで、画像が`JViewport`より大きくなる場合は、スクロールバーが表示されるように設定しています。

- - - -
ズーム自体は、[JPanelに表示した画像のズームとスクロール](http://ateraimemo.com/Swing/ZoomingAndPanning.html)で使用しているものとほぼ同じ`MouseWheelListener`を設定して実行していますが、画像を描画している`JPanel`を`JScrollPane`内に設定してスクロールバーでのスクロールを可能にしているため、`JPanel#paintComponent(...)`内での`AffineTransform`の使用方法などを変更しています。

- [JPanelに表示した画像のズームとスクロール](http://ateraimemo.com/Swing/ZoomingAndPanning.html)のようにズームを行うための`AffineTransform`(このサンプルでは`coordTransform`)を直接`Graphics2D`に設定すると、元からある`Graphics2D`コンテキスト内の`AffineTransform`(`JScrollBar`による移動)と競合して描画が乱れてしまう
    
    <pre class="prettyprint"><code>g2.setTransform(coordTransform);
    g2.drawImage(img, 0, 0, this);
</code></pre>
- 2つの`AffineTransform`を`AffineTransform#concatenate(AffineTransform)`で連結してから、`Graphics2D#setTransform(AffineTransform)`で設定することで回避
    
    <pre class="prettyprint"><code>AffineTransform at = g2.getTransform();
    at.concatenate(coordTransform);
    g2.setTransform(at);
    g2.drawImage(img, 0, 0, this);
</code></pre>
- または、[Graphics2D#drawImage(Image, AffineTransform, ImageObserver) (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/docs/api/java/awt/Graphics2D.html#drawImage-java.awt.Image-java.awt.geom.AffineTransform-java.awt.image.ImageObserver-)を使用することで、`Graphics2D`コンテキスト内の`AffineTransform`が適用される前にイメージにズーム変換を適用しておくことで回避
    
    <pre class="prettyprint"><code>g2.drawImage(img, coordTransform, this);

</code></pre>
- * 参考リンク [#pd1ded23]
- [JPanelに表示した画像のズームとスクロール](http://ateraimemo.com/Swing/ZoomingAndPanning.html)
    - マウスホイールによるズーム用のリスナを引用
- [JScrollPaneのViewportをマウスで掴んでスクロール](http://ateraimemo.com/Swing/HandScroll.html)
    - マウスドラッグによるスクロール用のリスナを引用
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)

<!-- dummy comment line for breaking list -->

## コメント