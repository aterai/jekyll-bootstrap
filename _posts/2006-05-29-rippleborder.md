---
layout: post
title: Borderのアニメーション
category: swing
folder: RippleBorder
tags: [Border, Animation]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-05-29

## Borderのアニメーション
`Border`の描画をアニメーションさせます。


{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTR9UHQaAI/AAAAAAAAAiA/_Kn7tNr8M3s/s800/RippleBorder.png %}

### サンプルコード
<pre class="prettyprint"><code>class RippleBorder extends EmptyBorder {
  private final javax.swing.Timer animator;
  private final JComponent comp;
  public RippleBorder(JComponent c, int width) {
    super(width, width, width, width);
    this.comp = c;
    animator = new Timer(80, new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        comp.repaint();
        count+=0.9f;
      }
    });
    comp.addMouseListener(new MouseAdapter() {
      @Override public void mouseEntered(MouseEvent e) {
        comp.setForeground(Color.RED);
        animator.start();
      }
      @Override public void mouseExited(MouseEvent e) {
        comp.setForeground(Color.BLACK);
      }
    });
  }
  private float count = 1.0f;
  @Override public void paintBorder(Component c, Graphics g, int x, int y, int w, int h) {
    if(!animator.isRunning()) {
      super.paintBorder(c, g, x, y, w, h);
      return;
    }
    Graphics2D g2 = (Graphics2D) g;
    g2.setPaint(Color.WHITE);
    float a = 1.0f/count;
    if( 0.12f-a&gt;1.0e-2 ) a = 0.0f;
    g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER,a));
    Insets i = getBorderInsets();
    int xx = i.left-(int)count;
    int yy = i.top-(int)count;
    int ww = i.left+i.right-(int)(count*2.0f);
    int hh = i.top+i.bottom-(int)(count*2.0f);
    g2.setStroke(new BasicStroke(count*1.2f));
    g2.drawRoundRect(xx, yy, w-ww, h-hh, 10, 10);
    if(xx&lt;0 &amp;&amp; animator.isRunning()) {
      count = 1.0f;
      animator.stop();
    }
  }
}
</code></pre>

### 解説
コンポーネント上にカーソルがきた場合、`Border`をアニメーションさせることで、波紋状の効果を描画しています。

### コメント
