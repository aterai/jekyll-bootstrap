---
layout: post
title: JScrollPaneのスクロールを同期
category: swing
folder: SynchronizedScroll
tags: [JScrollPane, ChangeListener, JScrollBar, BoundedRangeModel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-04-05

## JScrollPaneのスクロールを同期
`2`つの`JScrollPane`のスクロールを同期します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTT_c3UmrI/AAAAAAAAAlU/adQEhxZ2FXc/s800/SynchronizedScroll.png)

### サンプルコード
<pre class="prettyprint"><code>ChangeListener cl = new ChangeListener() {
  boolean adjflg = false;
  @Override public void stateChanged(ChangeEvent e) {
    JViewport src = null;
    JViewport tgt = null;
    if(e.getSource()==sp1.getViewport()) {
      src = sp1.getViewport();
      tgt = sp2.getViewport();
    }else if(e.getSource()==sp2.getViewport()) {
      src = sp2.getViewport();
      tgt = sp1.getViewport();
    }
    if(adjflg || tgt==null || src==null) return;
    adjflg = true;
    Dimension dm1 = src.getViewSize();
    Dimension sz1 = src.getSize();
    Point     pt1 = src.getViewPosition();
    Dimension dm2 = tgt.getViewSize();
    Dimension sz2 = tgt.getSize();
    Point     pt2 = tgt.getViewPosition();
    double d;
    d = pt1.getY()/(dm1.getHeight()-sz1.getHeight())
                  *(dm2.getHeight()-sz2.getHeight());
    pt1.y = (int)d;
    d = pt1.getX()/(dm1.getWidth()-sz1.getWidth())
                  *(dm2.getWidth()-sz2.getWidth());
    pt1.x = (int)d;
    tgt.setViewPosition(pt1);
    adjflg = false;
  }
};
</code></pre>

### 解説
上記のサンプルでは、一方のスクロールバーを移動させると、他方も同程度移動するように設定した`ChangeListener`を使用しています。

- - - -
内部コンポーネントのサイズが等しい場合は、それぞれの`JScrollBar`の`BoundedRangeModel`を共有するだけで、スクロールを同期することができます。

<pre class="prettyprint"><code>sp2.getVerticalScrollBar().setModel(sp1.getVerticalScrollBar().getModel());
sp2.getHorizontalScrollBar().setModel(sp1.getHorizontalScrollBar().getModel());
</code></pre>

### 参考リンク
- [Swing (Archive) - link to scrollbar](https://forums.oracle.com/thread/1502596)
- [Swing (Archive) - Synchronizing scrollbars two scroll bars](https://forums.oracle.com/thread/1484489)

<!-- dummy comment line for breaking list -->

### コメント
