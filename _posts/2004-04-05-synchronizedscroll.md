---
layout: post
category: swing
folder: SynchronizedScroll
title: JScrollPaneのスクロールを同期
tags: [JScrollPane, ChangeListener, JScrollBar, BoundedRangeModel]
author: aterai
pubdate: 2004-04-05T03:13:08+09:00
description: 2つのJScrollPaneのスクロールを同期します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTT_c3UmrI/AAAAAAAAAlU/adQEhxZ2FXc/s800/SynchronizedScroll.png
comments: true
---
## 概要
`2`つの`JScrollPane`のスクロールを同期します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTT_c3UmrI/AAAAAAAAAlU/adQEhxZ2FXc/s800/SynchronizedScroll.png %}

## サンプルコード
<pre class="prettyprint"><code>ChangeListener cl = new ChangeListener() {
  private boolean adjflg;
  @Override public void stateChanged(ChangeEvent e) {
    JViewport src = null;
    JViewport tgt = null;
    if (e.getSource() == sp1.getViewport()) {
      src = sp1.getViewport();
      tgt = sp2.getViewport();
    } else if (e.getSource() == sp2.getViewport()) {
      src = sp2.getViewport();
      tgt = sp1.getViewport();
    }
    if (adjflg || tgt == null || src == null) {
      return;
    }
    adjflg = true;
    Dimension dim1 = src.getViewSize();
    Dimension siz1 = src.getSize();
    Point pnt1 = src.getViewPosition();
    Dimension dim2 = tgt.getViewSize();
    Dimension siz2 = tgt.getSize();
    //Point pnt2 = tgt.getViewPosition();
    double d;
    d = pnt1.getY() / (dim1.getHeight() - siz1.getHeight())
                    * (dim2.getHeight() - siz2.getHeight());
    pnt1.y = (int) d;
    d = pnt1.getX() / (dim1.getWidth() - siz1.getWidth())
                    * (dim2.getWidth() - siz2.getWidth());
    pnt1.x = (int) d;
    tgt.setViewPosition(pnt1);
    adjflg = false;
  }
};
sp1.getViewport().addChangeListener(cl);
sp2.getViewport().addChangeListener(cl);
</code></pre>

## 解説
上記のサンプルでは、一方のスクロールバーを移動させると、他方も同程度の割合で移動するように設定した`ChangeListener`を使用しています。

- - - -
内部コンポーネントのサイズが等しい場合は、それぞれの垂直・水平`JScrollBar`で使用する`BoundedRangeModel`を共有するだけでスクロールの同期が可能です。

<pre class="prettyprint"><code>sp2.getVerticalScrollBar().setModel(sp1.getVerticalScrollBar().getModel());
sp2.getHorizontalScrollBar().setModel(sp1.getHorizontalScrollBar().getModel());
</code></pre>

## 参考リンク
- [ChangeListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/ChangeListener.html)
- [Swing (Archive) - link to scrollbar](https://community.oracle.com/thread/1502596)
- [Swing (Archive) - Synchronizing scrollbars two scroll bars](https://community.oracle.com/thread/1484489)

<!-- dummy comment line for breaking list -->

## コメント
