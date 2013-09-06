---
layout: post
title: JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする
category: swing
folder: CustomDecoratedFrame
tags: [JFrame, MouseListener, MouseMotionListener, JPanel, JLabel, ContentPane, Transparent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-01-18

## JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする
`JFrame`のタイトルバーなどを非表示にして独自に描画し、これに移動リサイズなどの機能も追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKV1P7mYI/AAAAAAAAAV0/u4qjd-ItBYU/s800/CustomDecoratedFrame.png)

### サンプルコード
<pre class="prettyprint"><code>class ResizeWindowListener extends MouseAdapter {
  private Rectangle startSide = null;
  private final JFrame frame;
  public ResizeWindowListener(JFrame frame) {
    this.frame = frame;
  }
  @Override public void mousePressed(MouseEvent e) {
    startSide = frame.getBounds();
  }
  @Override public void mouseDragged(MouseEvent e) {
    if(startSide==null) return;
    Component c = e.getComponent();
    if(c==topleft) {
      startSide.y += e.getY();
      startSide.height -= e.getY();
      startSide.x += e.getX();
      startSide.width -= e.getX();
    }else if(c==top) {
      startSide.y += e.getY();
      startSide.height -= e.getY();
    }else if(c==topright) {
      startSide.y += e.getY();
      startSide.height -= e.getY();
      startSide.width += e.getX();
    }else if(c==left) {
      startSide.x += e.getX();
      startSide.width -= e.getX();
    }else if(c==right) {
      startSide.width += e.getX();
    }else if(c==bottomleft) {
      startSide.height += e.getY();
      startSide.x += e.getX();
      startSide.width -= e.getX();
    }else if(c==bottom) {
      startSide.height += e.getY();
    }else if(c==bottomright) {
      startSide.height += e.getY();
      startSide.width += e.getX();
    }
    frame.setBounds(startSide);
  }
}
</code></pre>

### 解説
上記のサンプルではタイトルバーを、`setUndecorated(true)`で非表示にし、移動可能にした`JPanel`を追加してタイトルバーにしています。
リサイズは、[Undecorated and resizable dialog | Oracle Forums](https://forums.oracle.com/message/5765194)や`BasicInternalFrameUI.java`、`MetalRootPaneUI#MouseInputHandler`などを参考にして、周辺にそれぞれ対応するリサイズカーソルを設定した`JLabel`を配置しています。

- - - -
`JDK 1.7.0`の場合、`JFrame`の背景色を透明(`frame.setBackground(new Color(0,0,0,0));`)にし、`ContentPane`の左右上の角をクリアして透明にしています。

### 参考リンク
- [Undecorated and resizable dialog | Oracle Forums](https://forums.oracle.com/message/5765194)
- [JWindowをマウスで移動](http://terai.xrea.jp/Swing/DragWindow.html)
- [JInternalFrameをJFrameとして表示する](http://terai.xrea.jp/Swing/InternalFrameTitleBar.html)

<!-- dummy comment line for breaking list -->

### コメント
- `blogger`の方にコメントをもらって、調査、修正中だけど、`dual-monitor`環境が無いのでテストしづらい…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-10-06 (水) 13:01:36
- [blogspot](http://java-swing-tips.blogspot.com/2010/05/custom-decorated-titlebar-jframe.html)で指摘されていた件について: このサンプルを`1.6.0_xx`+`WebStart`で実行すると、画面の外にフレームをドラッグすることが出来なかったのですが、`JRE`のバージョンを`1.7.0`にすると、`WebStart`で起動しても画面外に移動可能になっているみたいです。もしかしてデュアルディスプレイでも移動できるようになっているのかも？(確認してないですが...) -- [aterai](http://terai.xrea.jp/aterai.html) 2011-09-06 (火) 21:27:18
- マルチモニター関係のメモ: [Bug ID: 7123767 Wrong tooltip location in Multi-Monitor configurations](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=7123767) -- [aterai](http://terai.xrea.jp/aterai.html) 2012-08-14 (火) 13:55:29

<!-- dummy comment line for breaking list -->

