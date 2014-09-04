---
layout: post
title: JPanelに表示した画像のズームとスクロール
category: swing
folder: ZoomingAndPanning
tags: [AffineTransform, Graphics, JPanel, MouseListener, MouseMotionListener, MouseWheelListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-04-21

## 概要
`JPanel`に表示した画像に`AffineTransform`による変換を適用して、マウスを使った拡大・縮小・移動を実行します。[How to implement Zoom & Pan in Java using Graphics2D](https://forums.oracle.com/thread/1263955)に投稿されているコードを参考・引用しています。

{% download https://lh3.googleusercontent.com/-c5Y9hCoRQbU/U1PhhnitgFI/AAAAAAAACD0/ZXIcyPywcr0/s800/ZoomingAndPanning.png %}

## サンプルコード
<pre class="prettyprint"><code>class ZoomAndPanHandler extends MouseAdapter {
  private static final double ZOOM_MULTIPLICATION_FACTOR = 1.2;
  private static final int MIN_ZOOM = -10;
  private static final int MAX_ZOOM = 10;
  private static final int EXTENT = 1;
  private final BoundedRangeModel zoomRange = new DefaultBoundedRangeModel(
    0, EXTENT, MIN_ZOOM, MAX_ZOOM + EXTENT);
  private final AffineTransform coordTransform = new AffineTransform();
  private final Point dragStartPoint = new Point();
  @Override public void mousePressed(MouseEvent e) {
    dragStartPoint.setLocation(e.getPoint());
  }
  @Override public void mouseDragged(MouseEvent e) {
    Point dragEndPoint = e.getPoint();
    Point dragStart = transformPoint(dragStartPoint);
    Point dragEnd   = transformPoint(dragEndPoint);
    coordTransform.translate(dragEnd.x - dragStart.x, dragEnd.y - dragStart.y);
    dragStartPoint.setLocation(dragEndPoint);
    e.getComponent().repaint();
  }
  @Override public void mouseWheelMoved(MouseWheelEvent e) {
    int dir = e.getWheelRotation();
    int z = zoomRange.getValue();
    zoomRange.setValue(z + EXTENT * (dir &gt; 0 ? -1 : 1));
    if (z == zoomRange.getValue()) {
      return;
    }
    Component c = e.getComponent();
    Rectangle r = c.getBounds();
    //Point p = e.getPoint();
    Point p = new Point(r.x + r.width / 2, r.y + r.height / 2);
    Point p1 = transformPoint(p);
    double scale = dir &gt; 0 ? 1 / ZOOM_MULTIPLICATION_FACTOR : ZOOM_MULTIPLICATION_FACTOR;
    coordTransform.scale(scale, scale);
    Point p2 = transformPoint(p);
    coordTransform.translate(p2.getX() - p1.getX(), p2.getY() - p1.getY());
    c.repaint();
  }
  //https://forums.oracle.com/thread/1263955
  //How to implement Zoom &amp; Pan in Java using Graphics2D
  private Point transformPoint(Point p1) {
    Point p2 = new Point();
    try {
      AffineTransform inverse = coordTransform.createInverse();
      inverse.transform(p1, p2);
    } catch (NoninvertibleTransformException ex) {
      ex.printStackTrace();
    }
    return p2;
  }
  public AffineTransform getCoordTransform() {
    return coordTransform;
  }
}
</code></pre>

## 解説
`AffineTransform#createInverse()`で取得した`AffineTransform`オブジェクトでマウス位置の逆変換を行い、現在表示されている倍率でのズームの中心や移動距離などを計算しています。

- ズーム
    - ホイール上回転で~~マウスの位置を中心にして~~拡大
    - ホイール下回転で~~マウスの位置を中心にして~~縮小
- スクロール
    - マウスドラッグで移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to implement Zoom & Pan in Java using Graphics2D](https://forums.oracle.com/thread/1263955)
- [ズームとパンの機能を備えたドローソフトを作成する：CodeZine](http://codezine.jp/article/detail/174)
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)
- [タッチ操作に対応した画像ビューワーをJavaScriptで作るならD3.jsが便利 - てっく煮ブログ](http://tech.nitoyon.com/ja/blog/2013/12/13/touch-viewer/)
- [CanvasでAffine変換で大いにはまる（数学的センスが足りなかった・・・） - torutkの日記](http://d.hatena.ne.jp/torutk/20140415/p1)

<!-- dummy comment line for breaking list -->

## コメント
- 表示画面の中心を 基準に拡大縮小するように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2014-04-21 (月) 14:55:12

<!-- dummy comment line for breaking list -->

