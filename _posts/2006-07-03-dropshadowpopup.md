---
layout: post
category: swing
folder: DropShadowPopup
title: JPopupMenuに半透明の影を付ける
tags: [JPopupMenu, Border, Robot, JMenuItem, Translucent]
author: aterai
pubdate: 2006-07-03
description: Robotで画面をキャプチャーするなどして、半透明の影をJPopupMenuに付けます。
comments: true
---
## 概要
`Robot`で画面をキャプチャーするなどして、半透明の影を`JPopupMenu`に付けます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMBgsMvZI/AAAAAAAAAYg/QBh9VXR7P-I/s800/DropShadowPopup.png %}

## サンプルコード
<pre class="prettyprint"><code>class ShadowBorder extends AbstractBorder {
  private final int xoff, yoff;
  private final transient BufferedImage screen;
  private transient BufferedImage shadow;

  public ShadowBorder(int x, int y, JComponent c, Point p) {
    super();
    this.xoff = x;
    this.yoff = y;
    BufferedImage bi = null;
    try {
      Robot robot = new Robot();
      Dimension d = c.getPreferredSize();
      bi = robot.createScreenCapture(new Rectangle(p.x, p.y, d.width + xoff, d.height + yoff));
    } catch (AWTException ex) {
      ex.printStackTrace();
    }
    screen = bi;
  }
  @Override public Insets getBorderInsets(Component c) {
    return new Insets(0, 0, xoff, yoff);
  }
  @Override public void paintBorder(Component c, Graphics g, int x, int y, int w, int h) {
    if (screen == null) {
      return;
    }
    if (shadow == null || shadow.getWidth() != w || shadow.getHeight() != h) {
      shadow = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
      Graphics2D g2 = shadow.createGraphics();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
      g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, .2f));
      g2.setPaint(Color.BLACK);
      for (int i = 0; i &lt; xoff; i++) {
        g2.fillRoundRect(xoff, xoff, w - xoff - xoff + i, h - xoff - xoff + i, 4, 4);
      }
      g2.dispose();
    }
    Graphics2D g2d = (Graphics2D) g.create();
    g2d.drawImage(screen, 0, 0, c);
    g2d.drawImage(shadow, 0, 0, c);
    g2d.setPaint(c.getBackground()); //??? 1.7.0_03
    g2d.fillRect(x, y, w - xoff, h - yoff);
    g2d.dispose();
  }
}
</code></pre>

## 解説
ポップアップメニューに半透明の影をつける際、フレームからはみ出すかどうかで異なる処理を行っています。

上記のサンプルコードは、フレームからはみ出す場合に使用する`Border`クラスです。

- フレーム内
    - `JPopupMenu#paintComponent`メソッドで半透明の影を描画しています。

<!-- dummy comment line for breaking list -->

- フレーム外
    - `Robot`を使って画面全体をキャプチャーし、これを利用して半透明の影を`Border`として作成しています。このためポップアップメニューがはみ出しても、影を付けることができますが、多少時間が掛かります。

<!-- dummy comment line for breaking list -->

- - - -
`JDK 1.7.0`や、`1.6.0_10`以上の場合は、フレーム外でも`Robot`を使用せず、以下のように`JPopupMenu`の上位`Window`の背景色を透明にすることで影をつけることができます。

<pre class="prettyprint"><code>class DropShadowPopupMenu extends JPopupMenu {
  private static final int OFFSET = 4;
  private transient BufferedImage shadow;
  private Border border;
  @Override public boolean isOpaque() {
    return false;
  }
  @Override public void updateUI() {
    setBorder(null);
    super.updateUI();
    border = null;
  }
  @Override public void paintComponent(Graphics g) {
    //super.paintComponent(g);
    Graphics2D g2 = (Graphics2D) g.create();
    g2.drawImage(shadow, 0, 0, this);
    g2.setPaint(getBackground()); //??? 1.7.0_03
    g2.fillRect(0, 0, getWidth() - OFFSET, getHeight() - OFFSET);
    g2.dispose();
  }
  @Override public void show(Component c, int x, int y) {
    if (border == null) {
      Border inner = getBorder();
      Border outer = BorderFactory.createEmptyBorder(0, 0, OFFSET, OFFSET);
      border = BorderFactory.createCompoundBorder(outer, inner);
    }
    setBorder(border);
    Dimension d = getPreferredSize();
    int w = d.width;
    int h = d.height;
    if (shadow == null || shadow.getWidth() != w || shadow.getHeight() != h) {
      shadow = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
      Graphics2D g2 = shadow.createGraphics();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, .2f));
      g2.setPaint(Color.BLACK);
      for (int i = 0; i &lt; OFFSET; i++) {
        g2.fillRoundRect(
            OFFSET, OFFSET, w - OFFSET - OFFSET + i, h - OFFSET - OFFSET + i, 4, 4);
      }
      g2.dispose();
    }
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        Window pop = SwingUtilities.getWindowAncestor(DropShadowPopupMenu.this);
        if (pop instanceof JWindow) {
          pop.setBackground(new Color(0, true)); //JDK 1.7.0
        }
      }
    });
    super.show(c, x, y);
  }
}
</code></pre>

## 参考リンク
- [Menuに半透明の影を付ける](http://ateraimemo.com/Swing/MenuWithShadow.html)

<!-- dummy comment line for breaking list -->

## コメント
- キャプチャーが遅いのは画面全体を撮っているからで、必要なサイズだけにすれば結構速いようです。サンプルを修正してみたところ、毎回キャプチャーするようにしても特に気にならない速度で動いてます。 -- *aterai* 2006-07-18 (火) 12:02:13
- ソース中で`isInRootPanel`がおかしい気がするのですが・・・

<!-- dummy comment line for breaking list -->
`convertPointToScreen`がいらないのと`return r.contains(pt)&&r.contains(p)`にしないとフレーム内の判定がおかしいようです -- *sawshun* 2006-10-05 (木) 11:23:39
    - ご指摘ありがとうごさいます。`convertPointToScreen`を削除して、`MyPopupMenu#isInRootPanel`は以下のように修正しました。 -- *aterai* 2006-10-05 (木) 12:34:12

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private boolean isInRootPanel(JComponent root, Point p) {
  Rectangle r = root.getBounds();
  Dimension d = this.getPreferredSize();
  //pointed out by sawshun
  return r.contains(p.x, p.y, d.width+off, d.height+off);
}
</code></pre>

- メモ: [Swing - Can popup menu events be consumed by other (e.g. background) components?](https://community.oracle.com/thread/1393754) -- *aterai* 2008-04-10 (木) 18:24:18

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final MyPopupMenu pop = new MyPopupMenu();
pop.add(new JMenuItem("Open"));
pop.add(new JMenuItem("Save"));
pop.add(new JMenuItem("Close"));
//pop.addSeparator(); //XXX: Nimbus
JSeparator s = new JSeparator();
s.setOpaque(true);
pop.add(s);
pop.add(new JMenuItem("Exit"));
JLabel label = new JLabel(icon);
label.setComponentPopupMenu(pop);
//JDK 1.5 label.addMouseListener(new MouseAdapter() {});
//addMouseListener(new MouseAdapter() {
//  public void mouseReleased(MouseEvent e) {
//    if(e.isPopupTrigger()) {
//      Point pt = e.getPoint();
//      pop.show(e.getComponent(), pt.x, pt.y);
//    }
//    repaint();
//  }
//});
</code></pre>
- `SynthLookAndFeel`(`Nimbus`など)で、`JSeparator`だけでなく`JMenuItem`まで透明になった修正？に対応。 -- *aterai* 2012-02-05 (日) 14:22:34
- `1.7.0_03`でなにか変更があった？のか、変な挙動をするようになったので、調査中。 -- *aterai* 2012-02-21 (火) 16:45:48
- `exit`や`close`が動作するのかと思ったのですが動かないんですよね？ `JPopupMenu`に表示させているだけでしょうか、もしそうなら`Exit`を押したときにフレームが終了するようなコードはどう書けばいいのでしょうか？ -- *hshs* 2013-03-02 (土) 05:32:25
    - 影を付けるだけのサンプルコードなので、`JMenuItem`は名前だけのダミーになっています。「フレームを終了するコード…」は、複数の`JFrame`が開いているかもしれない場合を考慮して、以下のような方法を使用するのがいいかもしれません。 -- *aterai* 2013-03-04 (月) 09:53:00

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JMenuItem mi = new JMenuItem(new AbstractAction("Exit") {
  @Override public void actionPerformed(ActionEvent e) {
    JMenuItem m = (JMenuItem)e.getSource();
    JPopupMenu popup = (JPopupMenu)m.getParent();
    JComponent invoker = (JComponent)popup.getInvoker();
    Window f = SwingUtilities.getWindowAncestor(invoker);
    if(f!=null) f.dispose();
  }
});
</code></pre>
- 返信ありがとうございます、当方`Netbeans`で開発してまして、上記のコードを`jPopupMenu1.add(この中);`に`new JMenuItem`以降を入れたのですが動きませんでした。よって`JMenuItem ｍ～f.dispose();`までを削除し、かわりに`jFrame1.setVisible(false);`を入れると動作しました。 -- *hshs* 2013-03-05 (火) 20:22:26
    - メモ: せっかくなので？、[JPopupMenuなどからWindowを閉じる](http://ateraimemo.com/Swing/WindowClosingAction.html)を作成してみました。 -- *aterai* 2013-03-11 (月) 17:09:34

<!-- dummy comment line for breaking list -->
