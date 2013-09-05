---
layout: post
title: JLayerを使ってJTabbedPaneのタブの挿入位置を描画する
category: swing
folder: DnDLayerTabbedPane
tags: [JLayer, JTabbedPane, DragAndDrop, TransferHandler, JWindow, JLabel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-01-23

## JLayerを使ってJTabbedPaneのタブの挿入位置を描画する
`JLayer`を使って、タブのドラッグ＆ドロップでの移動先を`JTabbedPane`上に描画します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-xX0rzgauC5c/Txz4AxE_u2I/AAAAAAAABIM/jHQdxU1yP9g/s800/DnDLayerTabbedPane.png)

### サンプルコード
<pre class="prettyprint"><code>class DropLocationLayerUI extends LayerUI&lt;DnDTabbedPane&gt; {
  private static final int LINEWIDTH = 3;
  private final Rectangle lineRect = new Rectangle();
  @Override public void paint(Graphics g, JComponent c) {
    super.paint (g, c);
    JLayer layer = (JLayer)c;
    DnDTabbedPane tabbedPane = (DnDTabbedPane)layer.getView();
    DnDTabbedPane.DropLocation loc = tabbedPane.getDropLocation();
    if(loc != null &amp;&amp; loc.isDropable() &amp;&amp; loc.getIndex()&gt;=0) {
      int index = loc.getIndex();
      boolean isZero = index==0;
      Rectangle r = tabbedPane.getBoundsAt(isZero?0:index-1);
      if(tabbedPane.getTabPlacement()==JTabbedPane.TOP ||
         tabbedPane.getTabPlacement()==JTabbedPane.BOTTOM) {
        lineRect.setRect(
            r.x-LINEWIDTH/2+r.width*(isZero?0:1), r.y,LINEWIDTH,r.height);
      }else{
        lineRect.setRect(
            r.x,r.y-LINEWIDTH/2+r.height*(isZero?0:1), r.width,LINEWIDTH);
      }
      Graphics2D g2 = (Graphics2D)g.create();
      g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.5f));
      g2.setColor(Color.RED);
      g2.fill(lineRect);
      g2.dispose();
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、[JTabbedPaneのタブをドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDTabbedPane.html)や、[JTabbedPane間でタブのドラッグ＆ドロップ移動](http://terai.xrea.jp/Swing/DnDExportTabbedPane.html)のように`GlassPane`を使用する代わりに、`JDK 1.7.0`で導入された`JLayer`を使用して、タブの挿入先を描画しています。`JLayer`を使用することで、別ウィンドウにある`JTabbedPane`へのタブ移動などの描画が簡単にできるようになっています。

- - - -
メニューバーから、ドラッグ中の半透明タブイメージの描画方法を切り替えてテストすることができます。

- `Lightweight`
    - `JDK1.7.0`で導入された、`TransferHandler#setDragImage(...)`メソッドを使用して描画
    - ウインドウの外では非表示

<!-- dummy comment line for breaking list -->

- `Heavyweight`
    - 半透明の`JWindow`に`JLabel`を追加して表示
    - ウインドウの外でも表示可能
    - 表示位置のオフセットが(0, 0)の場合、`DragOver`イベントが元の`JFrame`に伝わらない？
        - オフセットが(0, 0)でも、`JLabel#contains(...)`が常に`false`なら問題なし

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private final JLabel label = new JLabel() {
  @Override public boolean contains(int x, int y) {
    return false;
  }
};
private final JWindow dialog = new JWindow();
public TabTransferHandler() {
  dialog.add(label);
  //dialog.setAlwaysOnTop(true); // Web Start
  dialog.setOpacity(0.5f);
  //com.sun.awt.AWTUtilities.setWindowOpacity(dialog, 0.5f); // JDK 1.6.0
  DragSource.getDefaultDragSource().addDragSourceMotionListener(
      new DragSourceMotionListener() {
    @Override public void dragMouseMoved(DragSourceDragEvent dsde) {
      Point pt = dsde.getLocation();
      pt.translate(5, 5); // offset
      dialog.setLocation(pt);
    }
  });
//...
</code></pre>

### 参考リンク
- [JTabbedPaneのタブをドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDTabbedPane.html)
- [JTabbedPane間でタブのドラッグ＆ドロップ移動](http://terai.xrea.jp/Swing/DnDExportTabbedPane.html)
- [Free the pixel: GHOST drag and drop, over multiple windows](http://free-the-pixel.blogspot.com/2010/04/ghost-drag-and-drop-over-multiple.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JFrame`の外にドロップした場合は、新しいフレームと`JTabbedPane`を作成して表示したいけど、<kbd>ESC</kbd>キーや右クリックでのキャンセルと区別がつかない？ので、難しそう。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-01-25 (水) 19:57:10

<!-- dummy comment line for breaking list -->
