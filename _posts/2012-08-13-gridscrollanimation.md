---
layout: post
title: GridLayoutとJScrollPaneを使ったグリッド単位での表示切り替え
category: swing
folder: GridScrollAnimation
tags: [JScrollPane, JPanel, GridLayout, Animation]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-08-13

## GridLayoutとJScrollPaneを使ったグリッド単位での表示切り替え
`JPanel`に`GridLayout`でコンポーネントを追加し、これを`JScrollPane`に配置して、グリッド単位での表示、スクロールアニメーションによる切り替えを行います。


{% download https://lh4.googleusercontent.com/-V2E4xmdHmBE/UCiUOuOlrLI/AAAAAAAABQg/IYqzH9-WdsI/s800/GridScrollAnimation.png %}

### サンプルコード
<pre class="prettyprint"><code>class GridPanel extends JPanel implements Scrollable {
  public static int cols = 3, rows = 4;
  public static Dimension size = new Dimension(160*cols, 120*rows);
  public GridPanel() {
    super(new GridLayout(rows, cols, 0, 0));
    //putClientProperty("JScrollBar.fastWheelScrolling", Boolean.FALSE);
  }
  @Override public Dimension getPreferredScrollableViewportSize() {
    Dimension d = getPreferredSize();
    return new Dimension(d.width/cols, d.height/rows);
  }
  @Override public int getScrollableUnitIncrement(
      Rectangle visibleRect, int orientation, int direction) {
    return orientation==SwingConstants.HORIZONTAL ?
      visibleRect.width : visibleRect.height;
  }
  @Override public int getScrollableBlockIncrement(
      Rectangle visibleRect, int orientation, int direction) {
    return orientation==SwingConstants.HORIZONTAL ?
      visibleRect.width : visibleRect.height;
  }
  @Override public boolean getScrollableTracksViewportWidth() {
    return false;
  }
  @Override public boolean getScrollableTracksViewportHeight() {
    return false;
  }
  @Override public Dimension getPreferredSize() {
    return size;
  }
}

class ScrollAction extends AbstractAction {
  private static Timer scroller;
  private final Point vec;
  private final JScrollPane scrollPane;
  public ScrollAction(String name, JScrollPane scrollPane, Point vec) {
    super(name);
    this.scrollPane = scrollPane;
    this.vec = vec;
  }
  @Override public void actionPerformed(ActionEvent e) {
    final JViewport vport = scrollPane.getViewport();
    final JComponent v = (JComponent)vport.getView();
    final int w   = vport.getWidth(),
              h   = vport.getHeight(),
              sx  = vport.getViewPosition().x,
              sy  = vport.getViewPosition().y;
    final Rectangle rect = new Rectangle(w, h);
    if(scroller!=null &amp;&amp; scroller.isRunning()) return;
    scroller = new Timer(5, new ActionListener() {
      double MAX = 100d;
      int count = (int)MAX;
      @Override public void actionPerformed(ActionEvent e) {
        double a = easeInOut(--count/MAX);
        int dx = (int)(w - a*w + 0.5d);
        int dy = (int)(h - a*h + 0.5d);
        if(count&lt;=0) {
          dx = w;
          dy = h;
          scroller.stop();
        }
        rect.setLocation(sx + vec.x * dx, sy + vec.y * dy);
        v.scrollRectToVisible(rect);
      }
    });
    scroller.start();
  }
  private static double easeInOut(double t) {
    //range: 0.0&lt;=t&lt;=1.0
    if(t&lt;0.5d) {
      return 0.5d*pow3(t*2d);
    } else {
      return 0.5d*(pow3(t*2d-2d) + 2d);
    }
  }
  private static double pow3(double a) {
    //return Math.pow(a, 3d);
    return a * a * a;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`GridLayout`を使ってグリッド状に配置したコンポーネントを、`JScrollPane`と`scrollRectToVisible(...)`メソッドで、グリッド単位の表示と切り替え(スクロールアニメーション付き)を行なっています。

- 最初に表示されるコンポーネントは、左上にある(一番最初に`JPanel`に追加した)コンポーネント
- `PreferredScrollableViewportSize`の変更(グリッドのサイズ変更)には対応していない
- `JScrollPane`の各スクロールバーは常に非表示なので、マウスホイールによるスクロールには対応していない
- フォーカスの移動に表示切り替えは対応していない
- `CardLayout`+スクロールアニメーションでも同様の動作が可能？

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTextAreaをキャプションとして画像上にスライドイン](http://terai.xrea.jp/Swing/EaseInOut.html)

<!-- dummy comment line for breaking list -->

### コメント
