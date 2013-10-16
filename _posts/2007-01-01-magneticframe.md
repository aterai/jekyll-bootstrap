---
layout: post
title: JDesktopPaneにJInternalFrameを吸着させる
category: swing
folder: MagneticFrame
tags: [DesktopManager, JDesktopPane, JInternalFrame]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-01-01

## JDesktopPaneにJInternalFrameを吸着させる
`JDesktopPane`と`JInternalFrame`の距離が近くなった場合、これらを自動的に吸着させます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPnXoiDZI/AAAAAAAAAeQ/9SMGwoIqOi8/s800/MagneticFrame.png)

### サンプルコード
<pre class="prettyprint"><code>desktop.setDragMode(JDesktopPane.OUTLINE_DRAG_MODE);
desktop.setDesktopManager(new DefaultDesktopManager() {
  @override public void dragFrame(JComponent frame, int x, int y) {
    int e = x; int n = y;
    int w = desktop.getSize().width -frame.getSize().width -e;
    int s = desktop.getSize().height-frame.getSize().height-n;
    if(isNear(e) || isNear(n) || isNear(w) || isNear(s)) {
      x = (e&lt;w)?(isNear(e)?0:e):(isNear(w)?w+e:e);
      y = (n&lt;s)?(isNear(n)?0:n):(isNear(s)?s+n:n);
    }
    super.dragFrame(frame, x, y);
  }
  private boolean isNear(int c) {
    return (Math.abs(c)&lt;10);
  }
});
</code></pre>

### 解説
`DesktopManager#dragFrame(JInternalFrame,int,int)`メソッドをオーバーライドすることで`JInternalFrame`の位置を調整しています。上記のサンプルでは、`JDesktopPane`と`JInternalFrame`の距離が`10px`以下になった場合、それぞれ吸着するよう設定しています。

### コメント
