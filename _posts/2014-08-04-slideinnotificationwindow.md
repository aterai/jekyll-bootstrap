---
layout: post
category: swing
folder: SlideInNotificationWindow
title: JWindowをデスクトップにスライドインで表示する
tags: [JWindow, JOptionPane, Animation]
author: aterai
pubdate: 2014-08-04T16:21:27+09:00
description: JOptionPaneを追加したJWindowを、スライドインアニメーションを使ってデスクトップ上に表示します。
image: https://lh4.googleusercontent.com/-axruZWDGZys/U98iB0eZi8I/AAAAAAAACK0/hh_jWt5nsi4/s800/SlideInNotificationWindow.png
comments: true
---
## 概要
`JOptionPane`を追加した`JWindow`を、スライドインアニメーションを使ってデスクトップ上に表示します。

{% download https://lh4.googleusercontent.com/-axruZWDGZys/U98iB0eZi8I/AAAAAAAACK0/hh_jWt5nsi4/s800/SlideInNotificationWindow.png %}

## サンプルコード
<pre class="prettyprint"><code>class SlideInNotification implements PropertyChangeListener, HierarchyListener {
  private static final int DELAY = 5;
  private final JFrame frame;
  private JWindow dialog;
  private Timer animator;
  private int dx;
  private int dy;

  public SlideInNotification(JFrame frame) {
    super();
    this.frame = frame;
  }
  public void startSlideIn(final SlideInAnimation slideInAnimation) {
    if (animator != null &amp;&amp; animator.isRunning()) {
      return;
    }
    if (dialog != null &amp;&amp; dialog.isVisible()) {
      dialog.dispose();
    }
    GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment();
    Rectangle desktopBounds = env.getMaximumWindowBounds();

    JOptionPane optionPane = new JOptionPane("Warning", JOptionPane.WARNING_MESSAGE);
    DragWindowListener dwl = new DragWindowListener();
    optionPane.addMouseListener(dwl);
    optionPane.addMouseMotionListener(dwl);
    optionPane.addPropertyChangeListener(this);
    optionPane.addHierarchyListener(this);

    GraphicsConfiguration gc = frame.getGraphicsConfiguration();
    dialog = new JWindow(gc);
    dialog.getContentPane().add(optionPane);
    dialog.pack();

    final Dimension d = dialog.getContentPane().getPreferredSize();
    dx = desktopBounds.width - d.width;
    dy = desktopBounds.height;

    dialog.setLocation(new Point(dx, dy));
    dialog.setVisible(true);

    animator = new Timer(DELAY, new ActionListener() {
      private int count;
      @Override public void actionPerformed(ActionEvent e) {
        double a = 1d;
        switch (slideInAnimation) {
          case EASE_IN:
          a = AnimationUtil.easeIn(count++ / (double) d.height);
          break;
          case EASE_OUT:
          a = AnimationUtil.easeOut(count++ / (double) d.height);
          break;
          case EASE_IN_OUT:
          default:
          a = AnimationUtil.easeInOut(count++ / (double) d.height);
          break;
        }
        int visibleHeight = (int) (.5 + a * d.height);
        if (visibleHeight &gt;= d.height) {
          visibleHeight = d.height;
          animator.stop();
        }
        dialog.setLocation(new Point(dx, dy - visibleHeight));
      }
    });
    animator.start();
  }
  @Override public void propertyChange(PropertyChangeEvent e) {
    if (dialog != null &amp;&amp; dialog.isVisible() &amp;&amp; e.getNewValue() != null &amp;&amp;
        e.getNewValue() != JOptionPane.UNINITIALIZED_VALUE) {
      dialog.dispose();
    }
  }
  @Override public void hierarchyChanged(HierarchyEvent e) {
    JComponent c = (JComponent) e.getComponent();
    if ((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0 &amp;&amp;
        animator != null &amp;&amp; !c.isDisplayable()) {
      animator.stop();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`Window#setLocation(int, int)`メソッドを使用して`JOptionPane`を追加した`JWindow`のデスクトップ上での表示位置を変更し、画面右下からスライドインするように設定しています。

- マルチスクリーン環境では、メインの`JFrame`が存在する画面(`frame.getGraphicsConfiguration()`)に警告(`new JWindow(GraphicsConfiguration)`)がスライドインすることを想定しているが未検証
- `JOptionPane.WARNING_MESSAGE`以外の`JOptionPane`は未検証
- このページのスクリーンショットでは親フレーム中央に`JOptionPane`が表示されているが、これは手動で移動している

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextAreaをキャプションとして画像上にスライドイン](https://ateraimemo.com/Swing/EaseInOut.html)

<!-- dummy comment line for breaking list -->

## コメント
