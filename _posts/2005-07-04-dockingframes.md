---
layout: post
title: JFrameの移動を同期
category: swing
folder: DockingFrames
tags: [JFrame, ComponentListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-07-04

## JFrameの移動を同期
`JFrame`を`2`つ並べて作成し、その位置関係を保ったまま移動できるようにします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.ggpht.com/_9Z4BYR88imo/TQTLtEL3M0I/AAAAAAAAAYA/9HmyXI1Uw0M/s800/DockingFrames.png)

### サンプルコード
<pre class="prettyprint"><code>private void positionFrames(ComponentEvent e) {
  if(e.getSource().equals(frame1)) {
    int x = frame1.getBounds().x;
    int y = frame1.getBounds().y + frame1.getBounds().height;
    frame2.removeComponentListener(this);
    frame2.setLocation(x, y);
    frame2.addComponentListener(this);
  }else{
    int x = frame2.getBounds().x;
    int y = frame2.getBounds().y - frame1.getBounds().height;
    frame1.removeComponentListener(this);
    frame1.setLocation(x, y);
    frame1.addComponentListener(this);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JFrame`を上下に並べて、それぞれに`ComponentListener`インタフェースを実装したリスナーを追加しています。片方のフレームが移動された時、残りのフレームの位置を指定する前に、一旦このリスナーを削除してやることで、処理がループしないようになっています。

### 参考リンク
- [Swing (Archive) - how to dock two jdialogs?](https://forums.oracle.com/thread/1479997)
- [Swing (Archive) - how to catch drag event in the title bar of a jframe](https://forums.oracle.com/thread/1492552)

<!-- dummy comment line for breaking list -->

### コメント
