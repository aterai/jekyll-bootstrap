---
layout: post
title: JPanelにマウスで自由曲線を描画
category: swing
folder: PaintPanel
tags: [JPanel, MouseListener, MouseMotionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-12-19

## JPanelにマウスで自由曲線を描画
マウスをドラッグしてパネル上に自由曲線を描画します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTQ0y2U6WI/AAAAAAAAAgM/AAHllQ3_VHw/s800/PaintPanel.png)

### サンプルコード
<pre class="prettyprint"><code>class PaintPanel extends JPanel implements MouseMotionListener, MouseListener {
  private Point startPoint = new Point(-1,-1);
  private Point endPoint   = new Point(-1,-1);
  public PaintPanel() {
    super();
    addMouseMotionListener(this);
    addMouseListener(this);
  }
  @Override public void paintComponent(Graphics g) {
    //super.paintComponent(g);
    Graphics2D g2d = (Graphics2D)g;
    g2d.setStroke(new BasicStroke(3.0F));
    g2d.setPaint(Color.BLACK);
    g2d.drawLine(startPoint.x, startPoint.y,
                 endPoint.x,   endPoint.y);
    startPoint = endPoint;
  }
  @Override public void mouseDragged(MouseEvent e) {
    endPoint = e.getPoint();
    repaint();
  }
  @Override public void mousePressed(MouseEvent e) {
    startPoint = e.getPoint();
  }
  @Override public void mouseMoved(MouseEvent e) {}
  @Override public void mouseExited(MouseEvent e) {}
  @Override public void mouseEntered(MouseEvent e) {}
  @Override public void mouseReleased(MouseEvent e) {}
  @Override public void mouseClicked(MouseEvent e) {}
}
</code></pre>

### 解説
上記のサンプルでは、パネル上でマウスがドラッグされている場合、その軌跡を短い直線でつなぎ合わせて描画することで、お絵かきしています。

- マウスがクリックされた場所を始点にする
- ドラッグされた時の位置を終点にしてパネルを`repaint()`
- `paintComponent(...)`をオーバーライドして、上記の始点、終点で直線を描画
- 次の直線のための始点を現在の終点に変更

<!-- dummy comment line for breaking list -->

### 参考リンク
- [MemoryImageSourceで配列から画像を生成](http://terai.xrea.jp/Swing/MemoryImageSource.html)

<!-- dummy comment line for breaking list -->

### コメント
- マウス右ボタンをドラッグで消しゴム…のテスト -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-12 (火) 16:16:59
    - 追記:不要なコードを削除。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-04-30 (金) 19:26:37
    - [MemoryImageSourceで配列から画像を生成](http://terai.xrea.jp/Swing/MemoryImageSource.html)に移動。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-06-07 (月) 15:21:37
- わからん！！ --  2010-04-30 (金) 18:11:55

<!-- dummy comment line for breaking list -->

