---
layout: post
category: swing
folder: StatusBar
title: JFrameのリサイズが可能なサイズグリップ付きのステータスバーを作成する
tags: [JPanel, JLabel, JFrame]
author: aterai
pubdate: 2020-06-29T05:08:14+09:00
description: JFrameの下部にマウスドラッグでリサイズが可能なサイズグリップ付きのステータスバーを配置します。
image: https://drive.google.com/uc?id=1axOgWRI88iTM2MsOfCiFhDfcAMnMYCNf
comments: true
---
## 概要
`JFrame`の下部にマウスドラッグでリサイズが可能なサイズグリップ付きのステータスバーを配置します。

{% download https://drive.google.com/uc?id=1axOgWRI88iTM2MsOfCiFhDfcAMnMYCNf %}

## サンプルコード
<pre class="prettyprint"><code>class ResizeWindowListener extends MouseInputAdapter {
  private final Rectangle rect = new Rectangle();
  private final Point startPt = new Point();

  @Override public void mousePressed(MouseEvent e) {
    Component p = SwingUtilities.getRoot(e.getComponent());
    if (p instanceof Window) {
      startPt.setLocation(e.getPoint());
      rect.setBounds(p.getBounds());
    }
  }

  @Override public void mouseDragged(MouseEvent e) {
    Component p = SwingUtilities.getRoot(e.getComponent());
    if (!rect.isEmpty() &amp;&amp; p instanceof Window) {
      Point pt = e.getPoint();
      rect.width += pt.x - startPt.x;
      rect.height += pt.y - startPt.y;
      p.setBounds(rect);
    }
  }
}
</code></pre>

## 解説
- ステータスバー
    - `BorderLayout`を設定した`JPanel`で作成

<!-- dummy comment line for breaking list -->

- サイズグリップ
    - グリップ`Icon`を設定した`JLabel`で作成し、ステータスバーの右端(`BorderLayout.EAST`)に配置
    - マウスカーソルでのリサイズは[JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする](https://ateraimemo.com/Swing/CustomDecoratedFrame.html)の右下コーナー用の処理を適用
        
        <pre class="prettyprint"><code>class BottomRightCornerLabel extends JLabel {
          private transient MouseInputListener handler;
        
          protected BottomRightCornerLabel() {
            super(new BottomRightCornerIcon());
          }
        
          @Override public void updateUI() {
            removeMouseListener(handler);
            removeMouseMotionListener(handler);
            super.updateUI();
            handler = new ResizeWindowListener();
            addMouseListener(handler);
            addMouseMotionListener(handler);
            setCursor(Cursor.getPredefinedCursor(Cursor.SE_RESIZE_CURSOR));
          }
        }
</code></pre>
- グリップアイコン
    - `Windows 10`風？の`6`個の四角形を以下のように配置して作成
        
        <pre class="prettyprint"><code>class BottomRightCornerIcon implements Icon {
          private static final Color SQUARE_COLOR = new Color(160, 160, 160, 160);
        
          @Override public void paintIcon(Component c, Graphics g, int x, int y) {
            int diff = 3;
            Graphics2D g2 = (Graphics2D) g.create();
            g2.translate(getIconWidth() - diff * 3 - 1, getIconHeight() - diff * 3 - 1);
        
            int firstRow = 0;
            int secondRow = firstRow + diff;
            int thirdRow = secondRow + diff;
        
            int firstColumn = 0;
            drawSquare(g2, firstColumn, thirdRow);
        
            int secondColumn = firstColumn + diff;
            drawSquare(g2, secondColumn, secondRow);
            drawSquare(g2, secondColumn, thirdRow);
        
            int thirdColumn = secondColumn + diff;
            drawSquare(g2, thirdColumn, firstRow);
            drawSquare(g2, thirdColumn, secondRow);
            drawSquare(g2, thirdColumn, thirdRow);
        
            g2.dispose();
          }
        
          @Override public int getIconWidth() {
            return 16;
          }
        
          @Override public int getIconHeight() {
            return 20;
          }
        
          private void drawSquare(Graphics g, int x, int y) {
            g.setColor(SQUARE_COLOR);
            g.fillRect(x, y, 2, 2);
          }
        }
</code></pre>
    - * 参考リンク [#reference]
- [JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする](https://ateraimemo.com/Swing/CustomDecoratedFrame.html)
- [java.net: Pixel Pushing - web.archive.org](https://web.archive.org/web/20050609021916/http://today.java.net/pub/a/today/2005/06/07/pixelpushing.html)

<!-- dummy comment line for breaking list -->

## コメント
