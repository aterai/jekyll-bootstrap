---
layout: post
category: swing
folder: TranslucentScrollBar
title: JScrollBarを半透明にする
tags: [JScrollBar, JViewport, JScrollPane, Translucent, LayoutManager]
author: aterai
pubdate: 2013-05-20T17:18:43+09:00
description: 半透明のJScrollBarを作成して、JViewport内部に配置します。
image: https://lh3.googleusercontent.com/-X8o390yxqhI/UZjhjkgUrkI/AAAAAAAABsY/Aajtim-5-uE/s800/TranslucentScrollBar.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2015/03/create-translucent-jscrollbar.html
    lang: en
comments: true
---
## 概要
半透明の`JScrollBar`を作成して、`JViewport`内部に配置します。

{% download https://lh3.googleusercontent.com/-X8o390yxqhI/UZjhjkgUrkI/AAAAAAAABsY/Aajtim-5-uE/s800/TranslucentScrollBar.png %}

## サンプルコード
<pre class="prettyprint"><code>public JComponent makeTranslucentScrollBar(JComponent c) {
  JScrollPane scrollPane = new JScrollPane(c) {
    @Override public boolean isOptimizedDrawingEnabled() {
      return false; // JScrollBar is overlap
    }
  };
  scrollPane.setVerticalScrollBarPolicy(
      ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
  scrollPane.setHorizontalScrollBarPolicy(
      ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

  scrollPane.setComponentZOrder(scrollPane.getVerticalScrollBar(), 0);
  scrollPane.setComponentZOrder(scrollPane.getViewport(), 1);
  scrollPane.getVerticalScrollBar().setOpaque(false);

  scrollPane.setLayout(new ScrollPaneLayout() {
    @Override public void layoutContainer(Container parent) {
      JScrollPane scrollPane = (JScrollPane) parent;

      Rectangle availR = scrollPane.getBounds();
      availR.x = availR.y = 0;

      Insets insets = parent.getInsets();
      availR.x = insets.left;
      availR.y = insets.top;
      availR.width  -= insets.left + insets.right;
      availR.height -= insets.top  + insets.bottom;

      Rectangle vsbR = new Rectangle();
      vsbR.width  = 12;
      vsbR.height = availR.height;
      vsbR.x = availR.x + availR.width - vsbR.width;
      vsbR.y = availR.y;

      if (viewport != null) {
        viewport.setBounds(availR);
      }
      if (vsb != null) {
        vsb.setVisible(true);
        vsb.setBounds(vsbR);
      }
    }
  });
  scrollPane.getVerticalScrollBar().setUI(new BasicScrollBarUI() {
    private final Color defaultColor = new Color(220, 100, 100, 100);
    private final Color draggingColor = new Color(200, 100, 100, 100);
    private final Color rolloverColor = new Color(255, 120, 100, 100);

    @Override protected JButton createDecreaseButton(int orientation) {
      return new ZeroSizeButton();
    }

    @Override protected JButton createIncreaseButton(int orientation) {
      return new ZeroSizeButton();
    }

    @Override protected void paintTrack(Graphics g, JComponent c, Rectangle r) { /* empty */ }

    @Override protected void paintThumb(Graphics g, JComponent c, Rectangle r) {
      Color color;
      JScrollBar sb = (JScrollBar) c;
      if (!sb.isEnabled() || r.width &gt; r.height) {
        return;
      } else if (isDragging) {
        color = draggingColor;
      } else if (isThumbRollover()) {
        color = rolloverColor;
      } else {
        color = defaultColor;
      }
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      g2.setPaint(color);
      g2.fillRect(r.x, r.y, r.width - 1, r.height - 1);
      g2.setPaint(Color.WHITE);
      g2.drawRect(r.x, r.y, r.width - 1, r.height - 1);
      g2.dispose();
    }

    @Override protected void setThumbBounds(int x, int y, int width, int height) {
      super.setThumbBounds(x, y, width, height);
      // scrollbar.repaint(x, 0, width, scrollbar.getHeight());
      scrollbar.repaint();
    }
  });
  return scrollPane;
}
</code></pre>

## 解説
上記のサンプルでは、`JScrollBar`の増減ボタンのサイズを非表示、トラックを透明、つまみを半透明にして、`JViewport`内部に配置しています。

- `ScrollPaneLayout#layoutContainer(...)`をオーバーライドして、`JScrollBar`を`JViewport`の内部にオーバーラップするように配置
    - `scrollPane.setComponentZOrder(...)`で、`JScrollBar`と`JViewport`の`Z`軸の順序を変更
- `BasicScrollBarUI#createDecreaseButton()`、`BasicScrollBarUI#createIncreaseButton()`をオーバーライドして増減ボタンのサイズを`0`に設定
    - [JScrollBarのArrowButtonを非表示にする](https://ateraimemo.com/Swing/ArrowButtonlessScrollBar.html)
- `BasicScrollBarUI#paintTrack()`をオーバーライドしてトラックを非表示
    - トラックにつまみの残像が残るので、`BasicScrollBarUI#setThumbBounds`をオーバーライドして`JScrollBar`全体を再描画
- `BasicScrollBarUI#paintThumb()`をオーバーライドして半透明のつまみを描画
- つまみ描画のチラつき防止のため、`JScrollPane#isOptimizedDrawingEnabled()`が`false`を返すようにオーバーライド
    - このサンプルでは、横スクロールバーの表示、カラムヘッダの表示に未対応
        - [JScrollBarをJTable上に重ねて表示するJScrollPaneを作成する](https://ateraimemo.com/Swing/OverlappedScrollBar.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- ["Optimized" Drawing - Painting in AWT and Swing](http://www.oracle.com/technetwork/java/painting-140037.html)
- [JScrollBarをJTable上に重ねて表示するJScrollPaneを作成する](https://ateraimemo.com/Swing/OverlappedScrollBar.html)
- [JScrollBarのArrowButtonを非表示にする](https://ateraimemo.com/Swing/ArrowButtonlessScrollBar.html)

<!-- dummy comment line for breaking list -->

## コメント
- `ScrollPaneLayout`を変更してオーバーラップするより、`JLayer`などを使ってドラッグ可能な矩形を描画する方が簡単かもしれない…。 -- *aterai* 2013-05-20 (月) 17:20:39
    - `JLayer`を使用するサンプルを追加: [JScrollPane上にマウスカーソルが存在する場合のみJScrollBarを表示する](https://ateraimemo.com/Swing/ScrollBarOnHover.html) -- *aterai* 2017-07-31 (月) 16:12:57

<!-- dummy comment line for breaking list -->
