---
layout: post
title: JListのアイテムを範囲指定で選択
category: swing
folder: RubberBanding
tags: [JList, MouseListener, MouseMotionListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-08-14

## 概要
`JList`のアイテムをラバーバンドで範囲指定して選択します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSd-lu2aI/AAAAAAAAAi0/AQTsBqR1OUc/s800/RubberBanding.png %}

## サンプルコード
<pre class="prettyprint"><code>class RubberBandingListener extends MouseInputAdapter {
  @Override public void mouseDragged(MouseEvent e) {
    setFocusable(true);
    if(srcPoint==null) srcPoint = e.getPoint();
    Point destPoint = e.getPoint();
    polygon.reset();
    polygon.addPoint(srcPoint.x,  srcPoint.y);
    polygon.addPoint(destPoint.x, srcPoint.y);
    polygon.addPoint(destPoint.x, destPoint.y);
    polygon.addPoint(srcPoint.x,  destPoint.y);
    //setSelectedIndices(getIntersectsIcons(polygon));
    if(srcPoint.getX()==destPoint.getX() || srcPoint.getY()==destPoint.getY()) {
      line.setLine(srcPoint.getX(),srcPoint.getY(),destPoint.getX(),destPoint.getY());
      setSelectedIndices(getIntersectsIcons(line));
    }else{
      setSelectedIndices(getIntersectsIcons(polygon));
    }
    repaint();
  }
  @Override public void mouseReleased(MouseEvent e) {
    setFocusable(true);
    srcPoint = null;
    repaint();
  }
  @Override public void mousePressed(MouseEvent e) {
    int index = locationToIndex(e.getPoint());
    Rectangle rect = getCellBounds(index,index);
    if(!rect.contains(e.getPoint())) {
      clearSelection();
      getSelectionModel().setAnchorSelectionIndex(-1);
      getSelectionModel().setLeadSelectionIndex(-1);
      //getSelectionModel().setLeadSelectionIndex(getModel().getSize());
      setFocusable(false);
    }else{
      setFocusable(true);
    }
  }
  private int[] getIntersectsIcons(Shape p) {
    ListModel model = getModel();
    Vector&lt;Integer&gt; list = new Vector&lt;&gt;(model.getSize());
    for(int i=0;i&lt;model.getSize();i++) {
      Rectangle r = getCellBounds(i,i);
      if(p.intersects(r)) {
        list.add(i);
      }
    }
    int[] il = new int[list.size()];
    for(int i=0;i&lt;list.size();i++) {
      il[i] = list.get(i);
    }
    return il;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JList`にマウスリスナーを設定して、ドラッグに応じた矩形が描画されるようになっています。

この矩形の内部にアイテムアイコンが重なる場合は、それを選択状態に変更しています。選択範囲が矩形にならずに直線になっている場合は、別途その直線と交差するアイテムを選択するようにしています。

`JList`内のアイテムの配置は、`JList#setLayoutOrientation(JList.HORIZONTAL_WRAP)`メソッドを使っているため、水平方向に整列されます。

## 参考リンク
- [Swing - Can someone optimise the following code ?](https://forums.oracle.com/thread/1378164)
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
- [JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え](http://terai.xrea.jp/Swing/DragSelectDropReordering.html)

<!-- dummy comment line for breaking list -->

## コメント
- 点線のアニメーション: [プログラマメモ2: java ラバーバンドを表現するためのした調べ](http://programamemo2.blogspot.com/2007/08/java.html) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-08-01 (金) 16:24:28
- スクリーンショットなどを更新 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-06 (月) 21:29:19

<!-- dummy comment line for breaking list -->

