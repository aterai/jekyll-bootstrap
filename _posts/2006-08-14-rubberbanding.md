---
layout: post
category: swing
folder: RubberBanding
title: JListのアイテムを範囲指定で選択
tags: [JList, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2006-08-14T01:35:31+09:00
description: JListのアイテムをラバーバンドで範囲指定して選択します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSd-lu2aI/AAAAAAAAAi0/AQTsBqR1OUc/s800/RubberBanding.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2008/10/using-rubber-band-selection-in-jlist.html
    lang: en
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
  @Override protected void paintComponent(Graphics g) {
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
上記のサンプルでは、`JList`にマウスリスナーを設定して、ドラッグに応じた矩形を描画しています。

`JList`内のアイテムの配置は、`JList#setLayoutOrientation(JList.HORIZONTAL_WRAP)`メソッドを使っているため、水平方向での整列になります。

- - - -
- ラバーバンド矩形内部に重なるアイテムアイコンを検索し、それを`JList#setSelectedIndices(int[])`で選択状態に変更
    - ~~選択範囲が矩形にならずに直線になっている場合は、別途その直線と交差するアイテムを選択~~ `Polygon`の代わりに、`Path2D`を使用することでこれを回避
    - `JDK 1.8.0`以降なら、以下を`l.setSelectedIndices(IntStream.range(0, l.getModel().getSize()).filter(i -> p.intersects(l.getCellBounds(i, i))).toArray());`で置き換え可能

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private int[] getIntersectsIcons(JList l, Shape p) {
  ListModel model = l.getModel();
  List&lt;Integer&gt; list = new ArrayList&lt;&gt;(model.getSize());
  for (int i = 0; i &lt; model.getSize(); i++) {
    Rectangle r = l.getCellBounds(i, i);
    if (p.intersects(r)) {
      list.add(i);
    }
  }
  // JDK 1.8.0以降のstreamでList&lt;Integer&gt;をプリミティブなint配列に変換:
  // return list.stream().mapToInt(i -&gt; i).toArray();
  int[] il = new int[list.size()];
  for (int i = 0; i &lt; list.size(); i++) {
    il[i] = list.get(i);
  }
  return il;
}
</code></pre>

## 参考リンク
- [Swing - Can someone optimise the following code ?](https://community.oracle.com/thread/1378164)
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
- [JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え](https://ateraimemo.com/Swing/DragSelectDropReordering.html)
    - このラバーバンドで選択したアイテムを実際にドラッグして並べ替えるサンプル

<!-- dummy comment line for breaking list -->

## コメント
- 点線のアニメーション: [プログラマメモ2: java ラバーバンドを表現するためのした調べ](http://programamemo2.blogspot.com/2007/08/java.html) -- *aterai* 2008-08-01 (金) 16:24:28
- スクリーンショットなどを更新 -- *aterai* 2008-10-06 (月) 21:29:19

<!-- dummy comment line for breaking list -->
