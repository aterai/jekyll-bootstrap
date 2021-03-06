---
layout: post
category: swing
folder: PaintPanel
title: JPanelにマウスで自由曲線を描画
tags: [JPanel, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2005-12-19T14:19:26+09:00
description: マウスをドラッグしてパネル上に自由曲線を描画します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQ0y2U6WI/AAAAAAAAAgM/AAHllQ3_VHw/s800/PaintPanel.png
comments: true
---
## 概要
マウスをドラッグしてパネル上に自由曲線を描画します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQ0y2U6WI/AAAAAAAAAgM/AAHllQ3_VHw/s800/PaintPanel.png %}

## サンプルコード
<pre class="prettyprint"><code>class PaintPanel extends JPanel {
  private static final Stroke STROKE = new BasicStroke(
      3f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
  private transient List&lt;Shape&gt; list;
  private transient Path2D path;
  private transient MouseAdapter handler;

  @Override public void updateUI() {
    removeMouseMotionListener(handler);
    removeMouseListener(handler);
    super.updateUI();
    handler = new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        path = new Path2D.Double();
        list.add(path);
        Point p = e.getPoint();
        path.moveTo(p.x, p.y);
        repaint();
      }

      @Override public void mouseDragged(MouseEvent e) {
        Point p = e.getPoint();
        path.lineTo(p.x, p.y);
        repaint();
      }
    };
    addMouseMotionListener(handler);
    addMouseListener(handler);
    list = new ArrayList&lt;Shape&gt;();
  }

  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    if (list != null) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(Color.BLACK);
      g2.setStroke(STROKE);
      for (Shape s : list) {
        g2.draw(s);
      }
      g2.dispose();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、パネル上でマウスがドラッグされた場合その軌跡を短い直線でつなぎ合わせることで曲線を描画しています。

- 新規`Path2D`を生成し、マウスがクリックされた場所を`Path2D.moveTo(...)`で始点に設定
- ドラッグされた時の位置を`Path2D.lineTo(...)`で終点にしてパネルを`repaint()`
- `paintComponent(...)`をオーバーライドして、上記の直線のリスト(`Path2D`のリスト)を描画
- 次の直線のための始点を現在の終点に変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MemoryImageSourceで配列から画像を生成](https://ateraimemo.com/Swing/MemoryImageSource.html)

<!-- dummy comment line for breaking list -->

## コメント
- マウス右ボタンをドラッグで消しゴム…のテスト -- *aterai* 2010-01-12 (火) 16:16:59
    - 追記:不要なコードを削除。 -- *aterai* 2010-04-30 (金) 19:26:37
    - [MemoryImageSourceで配列から画像を生成](https://ateraimemo.com/Swing/MemoryImageSource.html)に移動。 -- *aterai* 2010-06-07 (月) 15:21:37
- わからん！！ --  2010-04-30 (金) 18:11:55
- 直線を`Path2D`で保存する方法に変更。 -- *aterai* 2015-12-08 (火) 16:16:59

<!-- dummy comment line for breaking list -->
