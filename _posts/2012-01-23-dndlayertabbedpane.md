---
layout: post
category: swing
folder: DnDLayerTabbedPane
title: JLayerを使ってJTabbedPaneのタブの挿入位置を描画する
tags: [JLayer, JTabbedPane, DragAndDrop, TransferHandler, JWindow, JLabel]
author: aterai
pubdate: 2012-01-23T18:01:31+09:00
description: JLayerを使って、タブのドラッグ＆ドロップでの移動先をJTabbedPane上に描画します。
image: https://lh3.googleusercontent.com/-xX0rzgauC5c/Txz4AxE_u2I/AAAAAAAABIM/jHQdxU1yP9g/s800/DnDLayerTabbedPane.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2012/01/sharing-tabs-between-2-jframes.html
    lang: en
comments: true
---
## 概要
`JLayer`を使って、タブのドラッグ＆ドロップでの移動先を`JTabbedPane`上に描画します。

{% download https://lh3.googleusercontent.com/-xX0rzgauC5c/Txz4AxE_u2I/AAAAAAAABIM/jHQdxU1yP9g/s800/DnDLayerTabbedPane.png %}

## サンプルコード
<pre class="prettyprint"><code>class DropLocationLayerUI extends LayerUI&lt;DnDTabbedPane&gt; {
  private static final int LINEWIDTH = 3;
  private final Rectangle lineRect = new Rectangle();
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer) {
      JLayer layer = (JLayer) c;
      DnDTabbedPane tabbedPane = (DnDTabbedPane) layer.getView();
      DnDTabbedPane.DropLocation loc = tabbedPane.getDropLocation();
      if (loc != null &amp;&amp; loc.isDroppable() &amp;&amp; loc.getIndex() &gt;= 0) {
        Graphics2D g2 = (Graphics2D) g.create();
        g2.setComposite(
            AlphaComposite.getInstance(AlphaComposite.SRC_OVER, .5f));
        g2.setColor(Color.RED);
        initLineRect(tabbedPane, loc);
        g2.fill(lineRect);
        g2.dispose();
      }
    }
  }
  private void initLineRect(JTabbedPane tabbedPane, DnDTabbedPane.DropLocation loc) {
    int index = loc.getIndex();
    int a = index == 0 ? 0 : 1;
    Rectangle r = tabbedPane.getBoundsAt(a * (index - 1));
    if (tabbedPane.getTabPlacement() == JTabbedPane.TOP
        || tabbedPane.getTabPlacement() == JTabbedPane.BOTTOM) {
      lineRect.setBounds(
        r.x - LINE_WIDTH / 2 + r.width * a, r.y, LINE_WIDTH, r.height);
    } else {
      lineRect.setBounds(
        r.x, r.y - LINE_WIDTH / 2 + r.height * a, r.width, LINE_WIDTH);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、[JTabbedPaneのタブをドラッグ＆ドロップ](http://ateraimemo.com/Swing/DnDTabbedPane.html)や、[JTabbedPane間でタブのドラッグ＆ドロップ移動](http://ateraimemo.com/Swing/DnDExportTabbedPane.html)のように`GlassPane`を使用する代わりに、`JDK 1.7.0`で導入された`JLayer`を使用して、タブの挿入先を描画しています。`JLayer`を使用することで、別ウィンドウにある`JTabbedPane`へのタブ移動などの描画が簡単にできるようになっています。

- - - -
メニューバーから、ドラッグ中の半透明タブイメージの描画方法を切り替えてテストすることができます。

- `Lightweight`
    - `JDK1.7.0`で導入された、`TransferHandler#setDragImage(...)`メソッドを使用して描画
    - ウィンドウの外では非表示

<!-- dummy comment line for breaking list -->

- `Heavyweight`
    - 半透明の`JWindow`に`JLabel`を追加して表示
    - ウィンドウの外でも表示可能
    - 表示位置のオフセットが`(0, 0)`の場合、`DragOver`イベントが元の`JFrame`に伝わらない？
        - オフセットが`(0, 0)`でも、`JLabel#contains(...)`が常に`false`なら問題なし

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
  dialog.setOpacity(.5f);
  //com.sun.awt.AWTUtilities.setWindowOpacity(dialog, .5f); // JDK 1.6.0
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

## 参考リンク
- [JTabbedPaneのタブをドラッグ＆ドロップ](http://ateraimemo.com/Swing/DnDTabbedPane.html)
- [JTabbedPane間でタブのドラッグ＆ドロップ移動](http://ateraimemo.com/Swing/DnDExportTabbedPane.html)
- [Free the pixel: GHOST drag and drop, over multiple windows](http://free-the-pixel.blogspot.com/2010/04/ghost-drag-and-drop-over-multiple.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JFrame`の外にドロップした場合は、新しいフレームと`JTabbedPane`を作成して表示したいけど、<kbd>Esc</kbd>キーや右クリックでのキャンセルと区別がつかない？ので、難しそう。 -- *aterai* 2012-01-25 (水) 19:57:10

<!-- dummy comment line for breaking list -->
