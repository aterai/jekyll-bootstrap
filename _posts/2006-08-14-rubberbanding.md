---
layout: post
category: swing
folder: RubberBanding
title: JListのアイテムを範囲指定で選択
tags: [JList, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2006-08-14T01:35:31+09:00
description: JListのアイテムをラバーバンドで範囲指定して選択します。
comments: true
---
## 概要
`JList`のアイテムをラバーバンドで範囲指定して選択します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSd-lu2aI/AAAAAAAAAi0/AQTsBqR1OUc/s800/RubberBanding.png %}

## サンプルコード
<pre class="prettyprint"><code>class RubberBandSelectionList&lt;E extends ListItem&gt; extends JList&lt;E&gt; {
  private static final AlphaComposite ALPHA =
    AlphaComposite.getInstance(AlphaComposite.SRC_OVER, .1f);
  private RubberBandListCellRenderer&lt;E&gt; renderer;
  private Color polygonColor;
  public RubberBandSelectionList(ListModel&lt;E&gt; model) {
    super(model);
  }
  @Override public void updateUI() {
    setSelectionForeground(null);
    setSelectionBackground(null);
    setCellRenderer(null);
    if (renderer == null) {
      renderer = new RubberBandListCellRenderer&lt;E&gt;();
    } else {
      removeMouseMotionListener(renderer);
      removeMouseListener(renderer);
    }
    super.updateUI();
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        setCellRenderer(renderer);
        addMouseMotionListener(renderer);
        addMouseListener(renderer);
        setLayoutOrientation(JList.HORIZONTAL_WRAP);
        setVisibleRowCount(0);
        setFixedCellWidth(62);
        setFixedCellHeight(62);
        setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
      }
    });
    Color c = getSelectionBackground();
    int r = c.getRed();
    int g = c.getGreen();
    int b = c.getBlue();
    polygonColor = r &gt; g ? r &gt; b ? new Color(r, 0, 0) : new Color(0, 0, b)
                         : g &gt; b ? new Color(0, g, 0) : new Color(0, 0, b);
  }
  @Override public void paintComponent(Graphics g) {
    super.paintComponent(g);
    if (renderer != null &amp;&amp; renderer.polygon != null) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(getSelectionBackground());
      g2.draw(renderer.polygon);
      g2.setComposite(ALPHA);
      g2.setPaint(polygonColor);
      g2.fill(renderer.polygon);
      g2.dispose();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JList`にマウスリスナーを設定して、ドラッグに応じた矩形が描画されるようになっています。

この矩形の内部にアイテムアイコンが重なる場合は、それを選択状態に変更しています。選択範囲が矩形にならずに直線になっている場合は、別途その直線と交差するアイテムを選択するようにしています。

`JList`内のアイテムの配置は、`JList#setLayoutOrientation(JList.HORIZONTAL_WRAP)`メソッドを使っているため、水平方向に整列されます。

## 参考リンク
- [Swing - Can someone optimise the following code ?](https://forums.oracle.com/thread/1378164)
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
- [JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え](http://ateraimemo.com/Swing/DragSelectDropReordering.html)

<!-- dummy comment line for breaking list -->

## コメント
- 点線のアニメーション: [プログラマメモ2: java ラバーバンドを表現するためのした調べ](http://programamemo2.blogspot.com/2007/08/java.html) -- *aterai* 2008-08-01 (金) 16:24:28
- スクリーンショットなどを更新 -- *aterai* 2008-10-06 (月) 21:29:19

<!-- dummy comment line for breaking list -->
