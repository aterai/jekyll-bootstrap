---
layout: post
category: swing
folder: ChangeScrollBarWidthOnHover
title: JScrollBar上にマウスカーソルが入ったらその幅を拡張する
tags: [JScrollBar, JScrollPane, JLayer, LayoutManager, Animation]
author: aterai
pubdate: 2019-09-02T18:04:32+09:00
description: JScrollBar上へのマウスカーソルの出入りをJLayerで取得してその幅を拡大・縮小します。
image: https://drive.google.com/uc?id=1BAF8wRV7pfhmJTBiE9_cun0SbMVR2XFQ
comments: true
---
## 概要
`JScrollBar`上へのマウスカーソルの出入りを`JLayer`で取得してその幅を拡大・縮小します。

{% download https://drive.google.com/uc?id=1BAF8wRV7pfhmJTBiE9_cun0SbMVR2XFQ %}

## サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane(makeList());
scroll.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

JPanel controls = new JPanel();
Timer animator = new Timer(10, e -&gt; controls.revalidate());
controls.setLayout(new BorderLayout(0, 0) {
  private int controlsWidth = MIN_WIDTH;

  @Override public Dimension preferredLayoutSize(Container target) {
    Dimension ps = super.preferredLayoutSize(target);
    int controlsPreferredWidth = ps.width;
    if (animator.isRunning()) {
      if (willExpand) {
        if (controls.getWidth() &lt; controlsPreferredWidth) {
          controlsWidth += 1;
        }
      } else {
        if (controls.getWidth() &gt; MIN_WIDTH) {
          controlsWidth -= 1;
        }
      }
      if (controlsWidth &lt;= MIN_WIDTH) {
        controlsWidth = MIN_WIDTH;
        animator.stop();
      } else if (controlsWidth &gt;= controlsPreferredWidth) {
        controlsWidth = controlsPreferredWidth;
        animator.stop();
      }
    }
    ps.width = controlsWidth;
    return ps;
  }
});
controls.add(scroll.getVerticalScrollBar());

JPanel p = new JPanel(new BorderLayout());
p.add(controls, BorderLayout.EAST);
p.add(scroll);

JPanel pp = new JPanel(new GridLayout(1, 2));
pp.add(new JLayer&lt;&gt;(p, new LayerUI&lt;JPanel&gt;() {
  private boolean isDragging;

  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(AWTEvent.MOUSE_EVENT_MASK
                                      | AWTEvent.MOUSE_MOTION_EVENT_MASK);
    }
  }

  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }

  @Override protected void processMouseMotionEvent(MouseEvent e, JLayer&lt;? extends JPanel&gt; l) {
    int id = e.getID();
    Component c = e.getComponent();
    if (c instanceof JScrollBar &amp;&amp; id == MouseEvent.MOUSE_DRAGGED) {
      isDragging = true;
    }
  }

  @Override protected void processMouseEvent(MouseEvent e, JLayer&lt;? extends JPanel&gt; l) {
    if (e.getComponent() instanceof JScrollBar) {
      switch (e.getID()) {
      case MouseEvent.MOUSE_ENTERED:
        if (!animator.isRunning() &amp;&amp; !isDragging) {
          willExpand = true;
          animator.setInitialDelay(0);
          animator.start();
        }
        break;
      case MouseEvent.MOUSE_EXITED:
        if (!animator.isRunning() &amp;&amp; !isDragging) {
          willExpand = false;
          animator.setInitialDelay(500);
          animator.start();
        }
        break;
      case MouseEvent.MOUSE_RELEASED:
        isDragging = false;
        if (!animator.isRunning() &amp;&amp; !e.getComponent().getBounds().contains(e.getPoint())) {
          willExpand = false;
          animator.setInitialDelay(500);
          animator.start();
        }
        break;
      default:
        break;
      }
      l.getView().repaint();
    }
  }
}));
pp.add(new JLayer&lt;&gt;(makeTranslucentScrollBar(makeList()), new ScrollBarOnHoverLayerUI()));
</code></pre>

## 解説
- 左
    - `JPanel`に`JScrollPane`と縦`JScrollBar`を分けて配置
    - `JPanel`に縦`JScrollBar`の幅を`Timer`を使用して拡大・縮小するレイアウトマネージャを設定
        - [LayoutManagerを使ってパネルの展開アニメーションを行う](https://ateraimemo.com/Swing/LayoutAnimation.html)
    - `JPanel`を`JLayer`でラップし、縦`JScrollBar`へのマウスカーソルの出入りなどを検知
        - `MouseEvent.MOUSE_ENTERED`、`MouseEvent.MOUSE_EXITED`で出入りを検知して`Timer`を起動する
        - ただし、マウスドラッグ中の場合でも`MouseEvent.MOUSE_ENTERED`、`MouseEvent.MOUSE_EXITED`イベントが発生するので、`MouseEvent.MOUSE_DRAGGED`中は`Timer`を起動しない
        - `MouseEvent.MOUSE_RELEASED`イベントが発生したとき、縦`JScrollBar`内にマウスカーソルがある場合は`Timer`を起動しない(幅を拡大した状態を維持する)
    - 縦`JScrollBar`の幅を縮小する場合、`500`ミリ秒ウェイトを入れてすぐに`Timer`を起動しないよう設定
- 右
    - 縦`JScrollBar`の矢印ボタンを非表示に設定
        - [JScrollBarのArrowButtonを非表示にする](https://ateraimemo.com/Swing/ArrowButtonlessScrollBar.html)
    - マウスカーソルの出入りで縦`JScrollBar`の色と幅を変更
        - [JScrollBarをJTable上に重ねて表示するJScrollPaneを作成する](https://ateraimemo.com/Swing/OverlappedScrollBar.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollPane上にマウスカーソルが存在する場合のみJScrollBarを表示する](https://ateraimemo.com/Swing/ScrollBarOnHover.html)

<!-- dummy comment line for breaking list -->

## コメント
